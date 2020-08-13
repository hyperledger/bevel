# -*- coding: utf-8 -*- #
# Copyright 2014 Google LLC. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Create cluster command."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

from apitools.base.py import exceptions as apitools_exceptions

from googlecloudsdk.api_lib.compute import metadata_utils
from googlecloudsdk.api_lib.compute import utils
from googlecloudsdk.api_lib.container import api_adapter
from googlecloudsdk.api_lib.container import kubeconfig as kconfig
from googlecloudsdk.api_lib.container import util
from googlecloudsdk.calliope import actions
from googlecloudsdk.calliope import arg_parsers
from googlecloudsdk.calliope import base
from googlecloudsdk.calliope import exceptions
from googlecloudsdk.command_lib.container import constants
from googlecloudsdk.command_lib.container import container_command_util as cmd_util
from googlecloudsdk.command_lib.container import flags
from googlecloudsdk.command_lib.container import messages
from googlecloudsdk.core import log
from googlecloudsdk.core.console import console_io


def _AddAdditionalZonesFlag(parser, deprecated=True):
  action = None
  if deprecated:
    action = actions.DeprecationAction(
        'additional-zones',
        warn='This flag is deprecated. '
        'Use --node-locations=PRIMARY_ZONE,[ZONE,...] instead.')
  parser.add_argument(
      '--additional-zones',
      type=arg_parsers.ArgList(min_length=1),
      action=action,
      metavar='ZONE',
      help="""\
The set of additional zones in which the specified node footprint should be
replicated. All zones must be in the same region as the cluster's primary zone.
If additional-zones is not specified, all nodes will be in the cluster's primary
zone.

Note that `NUM_NODES` nodes will be created in each zone, such that if you
specify `--num-nodes=4` and choose one additional zone, 8 nodes will be created.

Multiple locations can be specified, separated by commas. For example:

  $ {command} example-cluster --zone us-central1-a --additional-zones us-central1-b,us-central1-c
""")


def _AddAdditionalZonesGroup(parser):
  group = parser.add_mutually_exclusive_group()
  _AddAdditionalZonesFlag(group, deprecated=True)
  flags.AddNodeLocationsFlag(group)


def _GetEnableStackdriver(args):
  # hasattr checks if field exists, if not isSpecified would throw exception
  if not hasattr(args, 'enable_stackdriver_kubernetes'):
    return None
  if not args.IsSpecified('enable_stackdriver_kubernetes'):
    return None
  return args.enable_stackdriver_kubernetes


def _Args(parser):
  """Register flags for this command.

  Args:
    parser: An argparse.ArgumentParser-like object. It is mocked out in order to
      capture some information, but behaves like an ArgumentParser.
  """
  parser.add_argument(
      'name',
      help="""\
The name of the cluster to create.

The name may contain only lowercase alphanumerics and '-', must start with a
letter and end with an alphanumeric, and must be no longer than 40
characters.
""")
  # Timeout in seconds for operation
  parser.add_argument(
      '--timeout',
      type=int,
      default=3600,
      hidden=True,
      help='Timeout (seconds) for waiting on the operation to complete.')
  flags.AddAsyncFlag(parser)
  parser.add_argument(
      '--num-nodes',
      type=arg_parsers.BoundedInt(1),
      help='The number of nodes to be created in each of the cluster\'s zones.',
      default=3)
  flags.AddMachineTypeFlag(parser)
  parser.add_argument(
      '--subnetwork',
      help="""\
The Google Compute Engine subnetwork
(https://cloud.google.com/compute/docs/subnetworks) to which the cluster is
connected. The subnetwork must belong to the network specified by --network.

Cannot be used with the "--create-subnetwork" option.
""")
  parser.add_argument(
      '--network',
      help='The Compute Engine Network that the cluster will connect to. '
      'Google Kubernetes Engine will use this network when creating routes '
      'and firewalls for the clusters. Defaults to the \'default\' network.')
  parser.add_argument(
      '--cluster-ipv4-cidr',
      help='The IP address range for the pods in this cluster in CIDR '
      'notation (e.g. 10.0.0.0/14).  Prior to Kubernetes version 1.7.0 '
      'this must be a subset of 10.0.0.0/8; however, starting with version '
      '1.7.0 can be any RFC 1918 IP range.')
  parser.add_argument(
      '--enable-cloud-logging',
      action=actions.DeprecationAction(
          '--enable-cloud-logging',
          warn='From 1.14, legacy Stackdriver GKE logging is deprecated. Thus, '
          'flag `--enable-cloud-logging` is also deprecated. Please use '
          '`--enable-stackdriver-kubernetes` instead, to migrate to new '
          'Stackdriver Kubernetes Engine monitoring and logging. For more '
          'details, please read: '
          'https://cloud.google.com/monitoring/kubernetes-engine/migration.',
          action='store_true'),
      help='Automatically send logs from the cluster to the Google Cloud '
      'Logging API. This flag is deprecated, use '
      '`--enable-stackdriver-kubernetes` instead.')
  parser.add_argument(
      '--enable-cloud-monitoring',
      action=actions.DeprecationAction(
          '--enable-cloud-monitoring',
          warn='From 1.14, legacy Stackdriver GKE monitoring is deprecated. '
          'Thus, flag `--enable-cloud-monitoring` is also deprecated. Please '
          'use `--enable-stackdriver-kubernetes` instead, to migrate to new '
          'Stackdriver Kubernetes Engine monitoring and logging. For more '
          'details, please read: '
          'https://cloud.google.com/monitoring/kubernetes-engine/migration.',
          action='store_true'),
      help='Automatically send metrics from pods in the cluster to the Google '
      'Cloud Monitoring API. VM metrics will be collected by Google Compute '
      'Engine regardless of this setting. This flag is deprecated, use '
      '`--enable-stackdriver-kubernetes` instead.')
  parser.add_argument(
      '--disk-size',
      type=arg_parsers.BinarySize(lower_bound='10GB'),
      help='Size for node VM boot disks. Defaults to 100GB.')
  flags.AddBasicAuthFlags(parser)
  parser.add_argument(
      '--max-nodes-per-pool',
      type=arg_parsers.BoundedInt(100, api_adapter.MAX_NODES_PER_POOL),
      help='The maximum number of nodes to allocate per default initial node '
      'pool. Kubernetes Engine will automatically create enough nodes pools '
      'such that each node pool contains less than '
      '--max-nodes-per-pool nodes. Defaults to {nodes} nodes, but can be set '
      'as low as 100 nodes per pool on initial create.'.format(
          nodes=api_adapter.MAX_NODES_PER_POOL))
  flags.AddImageTypeFlag(parser, 'cluster')
  flags.AddImageFlag(parser, hidden=True)
  flags.AddImageProjectFlag(parser, hidden=True)
  flags.AddImageFamilyFlag(parser, hidden=True)
  flags.AddNodeLabelsFlag(parser)
  flags.AddTagsFlag(
      parser, """\
Applies the given Compute Engine tags (comma separated) on all nodes in the new
node-pool. Example:

  $ {command} example-cluster --tags=tag1,tag2

New nodes, including ones created by resize or recreate, will have these tags
on the Compute Engine API instance object and can be used in firewall rules.
See https://cloud.google.com/sdk/gcloud/reference/compute/firewall-rules/create
for examples.
""")
  parser.display_info.AddFormat(util.CLUSTERS_FORMAT)
  flags.AddIssueClientCertificateFlag(parser)
  flags.AddAcceleratorArgs(parser)
  flags.AddDiskTypeFlag(parser)
  flags.AddMetadataFlags(parser)
  flags.AddDatabaseEncryptionFlag(parser)
  flags.AddShieldedInstanceFlags(parser)
  flags.AddEnableShieldedNodesFlags(parser)


def ValidateBasicAuthFlags(args):
  """Validates flags associated with basic auth.

  Overwrites username if enable_basic_auth is specified; checks that password is
  set if username is non-empty.

  Args:
    args: an argparse namespace. All the arguments that were provided to this
      command invocation.

  Raises:
    util.Error, if username is non-empty and password is not set.
  """
  if args.IsSpecified('enable_basic_auth'):
    if not args.enable_basic_auth:
      args.username = ''
    # `enable_basic_auth == true` is a no-op defaults are resoved server-side
    # based on the version of the cluster. For versions before 1.12, this is
    # 'admin', otherwise '' (disabled).
  if not args.username and args.IsSpecified('password'):
    raise util.Error(constants.USERNAME_PASSWORD_ERROR_MSG)


def ParseCreateOptionsBase(args, is_autogke):
  """Parses the flags provided with the cluster creation command."""
  if args.IsSpecified('addons') and api_adapter.DASHBOARD in args.addons:
    log.warning(
        'The `KubernetesDashboard` addon is deprecated, and will be removed as '
        'an option for new clusters starting in 1.15. It is recommended to use '
        'the Cloud Console to manage and monitor your Kubernetes clusters, '
        'workloads and applications. See: '
        'https://cloud.google.com/kubernetes-engine/docs/concepts/dashboards')

  flags.MungeBasicAuthFlags(args)

  if args.IsSpecified('issue_client_certificate') and not (
      args.IsSpecified('enable_basic_auth') or args.IsSpecified('username')):
    log.warning('If `--issue-client-certificate` is specified but '
                '`--enable-basic-auth` or `--username` is not, our API will '
                'treat that as `--no-enable-basic-auth`.')

  enable_ip_alias = None
  if hasattr(args, 'enable_ip_alias'):
    enable_ip_alias = args.enable_ip_alias
    flags.WarnForUnspecifiedIpAllocationPolicy(args)

  enable_autorepair = False
  if hasattr(args, 'enable_autorepair'):
    enable_autorepair = cmd_util.GetAutoRepair(args)
    flags.WarnForNodeModification(args, enable_autorepair)

  metadata = metadata_utils.ConstructMetadataDict(args.metadata,
                                                  args.metadata_from_file)
  # TODO(b/154823988)
  # getattr should use the same defaults from the flags for the message
  return api_adapter.CreateClusterOptions(
      accelerators=getattr(args, 'accelerator', None),
      additional_zones=getattr(args, 'additional_zones', None),
      addons=getattr(args, 'addons', None),
      boot_disk_kms_key=getattr(args, 'boot_disk_kms_key', None),
      cluster_ipv4_cidr=getattr(args, 'cluster_ipv4_cidr', None),
      cluster_secondary_range_name=getattr(
          args, 'cluster_secondary_range_name',
          None),
      cluster_version=getattr(args, 'cluster_version', None),
      node_version=getattr(args, 'node_version', None),
      create_subnetwork=getattr(args, 'create_subnetwork', None),
      disk_type=getattr(args, 'disk_type', None),
      enable_autorepair=enable_autorepair,
      enable_autoscaling=getattr(args, 'enable_autoscaling', None),
      enable_autoupgrade=(cmd_util.GetAutoUpgrade(args) if
                          hasattr(args, 'enable_autoupgrade')
                          else None),
      enable_binauthz=getattr(args, 'enable_binauthz', None),
      enable_stackdriver_kubernetes=_GetEnableStackdriver(args),
      enable_cloud_logging=args.enable_cloud_logging if (hasattr(args, 'enable_cloud_logging') and args.IsSpecified('enable_cloud_logging')) else None,
      enable_cloud_monitoring=args.enable_cloud_monitoring if (hasattr(args, 'enable_cloud_monitoring') and args.IsSpecified('enable_cloud_monitoring')) else None,
      enable_ip_alias=enable_ip_alias,
      enable_intra_node_visibility=getattr(args, 'enable_intra_node_visibility', None),
      enable_kubernetes_alpha=getattr(args, 'enable_kubernetes_alpha', None),
      enable_cloud_run_alpha=args.enable_cloud_run_alpha if (hasattr(args, 'enable_cloud_run_alpha') and args.IsSpecified('enable_cloud_run_alpha')) else None,
      enable_legacy_authorization=getattr(args, 'enable_legacy_authorization', None),
      enable_master_authorized_networks=getattr(args, 'enable_master_authorized_networks', None),
      enable_network_policy=getattr(args, 'enable_network_policy', None),
      enable_private_nodes=getattr(args, 'enable_private_nodes', None),
      enable_private_endpoint=getattr(args, 'enable_private_endpoint', None),
      image_type=getattr(args, 'image_type', None),
      image=getattr(args, 'image', None),
      image_project=getattr(args, 'image_project', None),
      image_family=getattr(args, 'image_family', None),
      issue_client_certificate=getattr(args, 'issue_client_certificate', None),
      labels=getattr(args, 'labels', None),
      local_ssd_count=getattr(args, 'local_ssd_count', None),
      maintenance_window=getattr(args, 'maintenance_window', None),
      maintenance_window_start=getattr(args, 'maintenance_window_start', None),
      maintenance_window_end=getattr(args, 'maintenance_window_end', None),
      maintenance_window_recurrence=getattr(args, 'maintenance_window_recurrence', None),
      master_authorized_networks=getattr(args, 'master_authorized_networks', None),
      master_ipv4_cidr=getattr(args, 'master_ipv4_cidr', None),
      max_nodes=getattr(args, 'max_nodes', None),
      max_nodes_per_pool=getattr(args, 'max_nodes_per_pool', None),
      min_cpu_platform=getattr(args, 'min_cpu_platform', None),
      min_nodes=getattr(args, 'min_nodes', None),
      network=getattr(args, 'network', None),
      node_disk_size_gb=utils.BytesToGb(args.disk_size) if hasattr(args, 'disk_size') else None,
      node_labels=getattr(args, 'node_labels', None),
      node_locations=getattr(args, 'node_locations', None),
      node_machine_type=getattr(args, 'machine_type', None),
      node_taints=getattr(args, 'node_taints', None),
      num_nodes=getattr(args, 'num_nodes', None),
      password=getattr(args, 'password', None),
      preemptible=getattr(args, 'preemptible', None),
      scopes=getattr(args, 'scopes', None),
      service_account=getattr(args, 'service_account', None),
      services_ipv4_cidr=getattr(args, 'services_ipv4_cidr', None),
      services_secondary_range_name=\
        getattr(args, 'services_secondary_range_name', None),
      subnetwork=getattr(args, 'subnetwork', None),
      tags=getattr(args, 'tags', None),
      user=getattr(args, 'username', None),
      metadata=metadata,
      default_max_pods_per_node=\
        getattr(args, 'default_max_pods_per_node', None),
      max_pods_per_node=getattr(args, 'max_pods_per_node', None),
      enable_tpu=getattr(args, 'enable_tpu', None),
      tpu_ipv4_cidr=getattr(args, 'tpu_ipv4_cidr', None),
      resource_usage_bigquery_dataset=\
        getattr(args, 'resource_usage_bigquery_dataset', None),
      enable_network_egress_metering=\
        getattr(args, 'enable_network_egress_metering', None),
      enable_resource_consumption_metering=\
        getattr(args, 'enable_resource_consumption_metering', None),
      database_encryption_key=getattr(args, 'database_encryption_key', None),
      workload_pool=getattr(args, 'workload_pool', None),
      identity_provider=getattr(args, 'identity_provider', None),
      workload_metadata=getattr(args, 'workload_metadata', None),
      workload_metadata_from_node=\
        getattr(args, 'workload_metadata_from_node', None),
      enable_vertical_pod_autoscaling=\
        getattr(args, 'enable_vertical_pod_autoscaling', None),
      enable_autoprovisioning=getattr(args, 'enable_autoprovisioning', None),
      autoprovisioning_config_file=\
        getattr(args, 'autoprovisioning_config_file', None),
      autoprovisioning_service_account=\
        getattr(args, 'autoprovisioning_service_account', None),
      autoprovisioning_scopes=getattr(args, 'autoprovisioning_scopes', None),
      autoprovisioning_locations=\
        getattr(args, 'autoprovisioning_locations', None),
      autoprovisioning_max_surge_upgrade=\
        getattr(args, 'autoprovisioning_max_surge_upgrade', None),
      autoprovisioning_max_unavailable_upgrade=\
        getattr(args, 'autoprovisioning_max_unavailable_upgrade', None),
      enable_autoprovisioning_autorepair=\
        getattr(args, 'enable_autoprovisioning_autorepair', None),
      enable_autoprovisioning_autoupgrade=\
        getattr(args, 'enable_autoprovisioning_autoupgrade', None),
      autoprovisioning_min_cpu_platform=\
        getattr(args, 'autoprovisioning_min_cpu_platform', None),
      min_cpu=getattr(args, 'min_cpu', None),
      max_cpu=getattr(args, 'max_cpu', None),
      min_memory=getattr(args, 'min_memory', None),
      max_memory=getattr(args, 'max_memory', None),
      min_accelerator=getattr(args, 'min_accelerator', None),
      max_accelerator=getattr(args, 'max_accelerator', None),
      shielded_secure_boot=getattr(args, 'shielded_secure_boot', None),
      shielded_integrity_monitoring=\
        getattr(args, 'shielded_integrity_monitoring', None),
      reservation_affinity=getattr(args, 'reservation_affinity', None),
      reservation=getattr(args, 'reservation', None),
      release_channel=getattr(args, 'release_channel', None),
      enable_shielded_nodes=getattr(args, 'enable_shielded_nodes', None),
      max_surge_upgrade=getattr(args, 'max_surge_upgrade', None),
      max_unavailable_upgrade=getattr(args, 'max_unavailable_upgrade', None),
      auto_gke=is_autogke)


GA = 'ga'
BETA = 'beta'
ALPHA = 'alpha'


def AddAutoRepair(parser):
  flags.AddEnableAutoRepairFlag(parser, for_create=True)


def AddPrivateClusterDeprecated(parser):
  flags.AddPrivateClusterFlags(parser, with_deprecated=True)


def AddEnableAutoUpgradeWithDefault(parser):
  flags.AddEnableAutoUpgradeFlag(parser, default=True)


def AddAutoprovisioningGA(parser):
  flags.AddAutoprovisioningFlags(parser, hidden=False, for_create=True, ga=True)


def AddAutoprovisioning(parser):
  flags.AddAutoprovisioningFlags(parser, hidden=False, for_create=True)


def AddTpuWithServiceNetworking(parser):
  flags.AddTpuFlags(parser, enable_tpu_service_networking=True)


def AddWorkloadIdentityWithProvider(parser):
  flags.AddWorkloadIdentityFlags(parser, use_identity_provider=True)


def AddDisableDefaultSnatFlagForClusterCreate(parser):
  flags.AddDisableDefaultSnatFlag(parser, for_cluster_create=True)


def AddMasterSignalsFlag(parser):
  flags.AddEnableMasterSignalsFlags(parser, for_create=True)


def AddPrivateIPv6Flag(api, parser):
  flags.AddPrivateIpv6GoogleAccessTypeFlag(api, parser, hidden=True)


flags_to_add = {
    GA: {
        'additionalzones': _AddAdditionalZonesFlag,
        'addons': flags.AddAddonsFlags,
        'autorepair': AddAutoRepair,
        'autoprovisioning': AddAutoprovisioningGA,
        'autoupgrade': AddEnableAutoUpgradeWithDefault,
        'args': _Args,
        'binauthz': flags.AddEnableBinAuthzFlag,
        'bootdiskkms': flags.AddBootDiskKmsKeyFlag,
        'cloudrunalpha': flags.AddEnableCloudRunAlphaFlag,
        'clusterautoscaling': flags.AddClusterAutoscalingFlags,
        'clusterversion': flags.AddClusterVersionFlag,
        'intranodevisibility': flags.AddEnableIntraNodeVisibilityFlag,
        'ipalias': flags.AddIPAliasFlags,
        'kubernetesalpha': flags.AddEnableKubernetesAlphaFlag,
        'labels': flags.AddLabelsFlag,
        'legacyauth': flags.AddEnableLegacyAuthorizationFlag,
        'localssd': flags.AddLocalSSDFlag,
        'maintenancewindow': flags.AddMaintenanceWindowGroup,
        'masterauth': flags.AddMasterAuthorizedNetworksFlags,
        'maxpodspernode': flags.AddMaxPodsPerNodeFlag,
        'maxunavailable': flags.AddMaxUnavailableUpgradeFlag,
        'mincpu': flags.AddMinCpuPlatformFlag,
        'networkpolicy': flags.AddNetworkPolicyFlags,
        'nodeidentity': flags.AddClusterNodeIdentityFlags,
        'nodelocations': flags.AddNodeLocationsFlag,
        'nodetaints': flags.AddNodeTaintsFlag,
        'nodeversion': flags.AddNodeVersionFlag,
        'preemptible': flags.AddPreemptibleFlag,
        'privatecluster': flags.AddPrivateClusterFlags,
        'releasechannel': flags.AddReleaseChannelFlag,
        'reservationaffinity': flags.AddReservationAffinityFlags,
        'resourceusageexport': flags.AddResourceUsageExportFlags,
        'surgeupgrade': flags.AddSurgeUpgradeFlag,
        'stackdriver': flags.AddEnableStackdriverKubernetesFlag,
        'tpu': flags.AddTpuFlags,
        'verticalpodautoscaling': flags.AddVerticalPodAutoscalingFlag,
        'workloadidentity': flags.AddWorkloadIdentityFlags,
        'workloadmetadata': flags.AddWorkloadMetadataFlag,
    },
    BETA: {
        'additionalzones':
            _AddAdditionalZonesGroup,
        'addons':
            flags.AddBetaAddonsFlags,
        'allowrouteoverlap':
            flags.AddAllowRouteOverlapFlag,
        'args':
            _Args,
        'autorepair':
            AddAutoRepair,
        'autoprovisioning':
            AddAutoprovisioning,
        'autoscalingprofiles':
            flags.AddAutoscalingProfilesFlag,
        'authenticatorsecurity':
            flags.AddAuthenticatorSecurityGroupFlags,
        'autoupgrade':
            AddEnableAutoUpgradeWithDefault,
        'binauthz':
            flags.AddEnableBinAuthzFlag,
        'bootdiskkms':
            flags.AddBootDiskKmsKeyFlag,
        'cloudrunalpha':
            flags.AddEnableCloudRunAlphaFlag,
        'clusterautoscaling':
            flags.AddClusterAutoscalingFlags,
        'clusterversion':
            flags.AddClusterVersionFlag,
        'confidentialnodes':
            flags.AddEnableConfidentialNodesFlag,
        'datapath':
            (lambda p: flags.AddDatapathProviderFlag(p, hidden=True)),
        'dataplanev2':
            flags.AddDataplaneV2Flag,
        'disabledefaultsnat':
            AddDisableDefaultSnatFlagForClusterCreate,
        'intranodevisibility':
            flags.AddEnableIntraNodeVisibilityFlag,
        'ipalias':
            flags.AddIPAliasFlags,
        'istioconfig':
            flags.AddIstioConfigFlag,
        'kubernetesalpha':
            flags.AddEnableKubernetesAlphaFlag,
        'gvnic':
            flags.AddEnableGvnicFlag,
        'localssd':
            flags.AddLocalSSDFlag,
        'loggingmonitoring':
            flags.AddEnableLoggingMonitoringSystemOnlyFlag,
        'labels':
            flags.AddLabelsFlag,
        'legacyauth':
            flags.AddEnableLegacyAuthorizationFlag,
        'maintenancewindow':
            flags.AddMaintenanceWindowGroup,
        'masterglobalaccess':
            flags.AddMasterGlobalAccessFlag,
        'masterauth':
            flags.AddMasterAuthorizedNetworksFlags,
        'mastersignals':
            AddMasterSignalsFlag,
        'maxpodspernode':
            flags.AddMaxPodsPerNodeFlag,
        'maxunavailable':
            (lambda p: flags.AddMaxUnavailableUpgradeFlag(p, is_create=True)),
        'mincpu':
            flags.AddMinCpuPlatformFlag,
        'networkpolicy':
            flags.AddNetworkPolicyFlags,
        'nodetaints':
            flags.AddNodeTaintsFlag,
        'nodeidentity':
            flags.AddClusterNodeIdentityFlags,
        'nodeversion':
            flags.AddNodeVersionFlag,
        'notificationconfig':
            (lambda p: flags.AddNotificationConfigFlag(p, hidden=True)),
        'podsecuritypolicy':
            flags.AddPodSecurityPolicyFlag,
        'preemptible':
            flags.AddPreemptibleFlag,
        'privatecluster':
            AddPrivateClusterDeprecated,
        'privateipv6type': (lambda p: AddPrivateIPv6Flag('v1beta1', p)),
        'releasechannel':
            flags.AddReleaseChannelFlag,
        'resourceusageexport':
            flags.AddResourceUsageExportFlags,
        'reservationaffinity':
            flags.AddReservationAffinityFlags,
        'stackdriver':
            flags.AddEnableStackdriverKubernetesFlag,
        'surgeupgrade': (lambda p: flags.AddSurgeUpgradeFlag(p, default=1)),
        'systemconfig':
            lambda p: flags.AddSystemConfigFlag(p, hidden=False),
        'tpu':
            AddTpuWithServiceNetworking,
        'verticalpodautoscaling':
            flags.AddVerticalPodAutoscalingFlag,
        'workloadidentity':
            AddWorkloadIdentityWithProvider,
        'workloadmetadata':
            (lambda p: flags.AddWorkloadMetadataFlag(p, use_mode=False)),
    },
    ALPHA: {
        'additionalzones':
            _AddAdditionalZonesGroup,
        'addons':
            flags.AddAlphaAddonsFlags,
        'allowrouteoverlap':
            flags.AddAllowRouteOverlapFlag,
        'args':
            _Args,
        'authenticatorsecurity':
            flags.AddAuthenticatorSecurityGroupFlags,
        'autoprovisioning':
            AddAutoprovisioning,
        'autorepair':
            AddAutoRepair,
        'autoscalingprofiles':
            flags.AddAutoscalingProfilesFlag,
        'clusterversion':
            flags.AddClusterVersionFlag,
        'autoupgrade':
            AddEnableAutoUpgradeWithDefault,
        'binauthz':
            flags.AddEnableBinAuthzFlag,
        'bootdiskkms':
            flags.AddBootDiskKmsKeyFlag,
        'cloudrunalpha':
            flags.AddEnableCloudRunAlphaFlag,
        'cloudrunconfig':
            flags.AddCloudRunConfigFlag,
        'clusterautoscaling':
            flags.AddClusterAutoscalingFlags,
        'clusterdns':
            flags.AddClusterDNSFlags,
        'confidentialnodes':
            flags.AddEnableConfidentialNodesFlag,
        'costmanagementconfig':
            flags.AddCostManagementConfigFlag,
        'datapath':
            lambda p: flags.AddDatapathProviderFlag(p, hidden=True),
        'dataplanev2':
            flags.AddDataplaneV2Flag,
        'disabledefaultsnat':
            AddDisableDefaultSnatFlagForClusterCreate,
        'gvnic':
            flags.AddEnableGvnicFlag,
        'ilbsubsetting':
            flags.AddILBSubsettingFlags,
        'intranodevisibility':
            flags.AddEnableIntraNodeVisibilityFlag,
        'ipalias':
            flags.AddIPAliasFlags,
        'istioconfig':
            flags.AddIstioConfigFlag,
        'kubernetesalpha':
            flags.AddEnableKubernetesAlphaFlag,
        'labels':
            flags.AddLabelsFlag,
        'legacyauth':
            flags.AddEnableLegacyAuthorizationFlag,
        'linuxsysctl':
            flags.AddLinuxSysctlFlags,
        'localssdandlocalssdvol':
            flags.AddLocalSSDAndLocalSSDVolumeConfigsFlag,
        'loggingmonitoring':
            flags.AddEnableLoggingMonitoringSystemOnlyFlag,
        'npname':
            lambda p: flags.AddInitialNodePoolNameArg(p, hidden=False),
        'maxunavailable':
            (lambda p: flags.AddMaxUnavailableUpgradeFlag(p, is_create=True)),
        'masterglobalaccess':
            flags.AddMasterGlobalAccessFlag,
        'maxpodspernode':
            flags.AddMaxPodsPerNodeFlag,
        'maintenancewindow':
            flags.AddMaintenanceWindowGroup,
        'masterauth':
            flags.AddMasterAuthorizedNetworksFlags,
        'mastersignals':
            AddMasterSignalsFlag,
        'mincpu':
            flags.AddMinCpuPlatformFlag,
        'networkpolicy':
            flags.AddNetworkPolicyFlags,
        'nodetaints':
            flags.AddNodeTaintsFlag,
        'nodeidentity':
            flags.AddClusterNodeIdentityFlags,
        'nodeversion':
            flags.AddNodeVersionFlag,
        'notificationconfig':
            (lambda p: flags.AddNotificationConfigFlag(p, hidden=True)),
        'podsecuritypolicy':
            flags.AddPodSecurityPolicyFlag,
        'preemptible':
            flags.AddPreemptibleFlag,
        'privatecluster':
            AddPrivateClusterDeprecated,
        'privateipv6':
            (lambda p: flags.AddEnablePrivateIpv6AccessFlag(p, hidden=True)),
        'privateipv6type': (lambda p: AddPrivateIPv6Flag('v1alpha1', p)),
        'reservationaffinity':
            flags.AddReservationAffinityFlags,
        'resourceusageexport':
            flags.AddResourceUsageExportFlags,
        'releasechannel':
            flags.AddReleaseChannelFlag,
        'stackdriver':
            flags.AddEnableStackdriverKubernetesFlag,
        'securityprofile':
            flags.AddSecurityProfileForCreateFlags,
        'surgeupgrade': (lambda p: flags.AddSurgeUpgradeFlag(p, default=1)),
        'systemconfig':
            lambda p: flags.AddSystemConfigFlag(p, hidden=False),
        'tpu':
            AddTpuWithServiceNetworking,
        'verticalpodautoscaling':
            flags.AddVerticalPodAutoscalingFlag,
        'workloadidentity':
            AddWorkloadIdentityWithProvider,
        'workloadmetadata':
            (lambda p: flags.AddWorkloadMetadataFlag(p, use_mode=False)),
    },
}


def AddFlags(channel, parser, allowlist=None):
  """Adds flags to the current parser.

  Args:
    channel: channel from which to add flags. eg. "GA" or "BETA"
    parser: parser to add current flags to
    allowlist: only add intersection of this list and channel flags
  """
  add_flag_for_channel = flags_to_add[channel]

  for flagname in add_flag_for_channel:
    if allowlist is None or (flagname in allowlist):
      add_flag_for_channel[flagname](parser)


@base.ReleaseTracks(base.ReleaseTrack.GA)
class Create(base.CreateCommand):
  """Create a cluster for running containers."""

  detailed_help = {
      'DESCRIPTION':
          '{description}',
      'EXAMPLES':
          """\
          To create a cluster with the default configuration, run:

            $ {command} sample-cluster
          """,
  }

  autogke = False

  @staticmethod
  def Args(parser):
    AddFlags(GA, parser)

  def ParseCreateOptions(self, args):
    return ParseCreateOptionsBase(args, self.autogke)

  def Run(self, args):
    """This is what gets called when the user runs this command.

    Args:
      args: an argparse namespace. All the arguments that were provided to this
        command invocation.

    Returns:
      Cluster message for the successfully created cluster.

    Raises:
      util.Error, if creation failed.
    """
    if args.async_ and not args.IsSpecified('format'):
      args.format = util.OPERATIONS_FORMAT

    util.CheckKubectlInstalled()

    adapter = self.context['api_adapter']
    location_get = self.context['location_get']
    location = location_get(args)

    cluster_ref = adapter.ParseCluster(args.name, location)
    options = self.ParseCreateOptions(args)

    if options.private_cluster and not (
        options.enable_master_authorized_networks or
        options.master_authorized_networks):
      log.warning(
          '`--private-cluster` makes the master inaccessible from '
          'cluster-external IP addresses, by design. To allow limited '
          'access to the master, see the `--master-authorized-networks` flags '
          'and our documentation on setting up private clusters: '
          'https://cloud.google.com'
          '/kubernetes-engine/docs/how-to/private-clusters')

    if not options.enable_shielded_nodes:
      log.warning(
          'Starting with version 1.18, clusters will have shielded GKE nodes by default.'
      )

    if options.enable_ip_alias:
      log.warning(
          'The Pod address range limits the maximum size of the cluster. '
          'Please refer to https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr to learn how to optimize IP address allocation.'
      )
    else:
      max_node_number = util.CalculateMaxNodeNumberByPodRange(
          options.cluster_ipv4_cidr)
      if max_node_number > 0:
        log.warning(
            'Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most %d node(s). '
            % max_node_number)

    if options.enable_kubernetes_alpha:
      console_io.PromptContinue(
          message=constants.KUBERNETES_ALPHA_PROMPT,
          throw_if_unattended=True,
          cancel_on_no=True)

    if options.enable_autorepair is not None:
      log.status.Print(
          messages.AutoUpdateUpgradeRepairMessage(options.enable_autorepair,
                                                  'autorepair'))

    if options.accelerators is not None:
      log.status.Print(constants.KUBERNETES_GPU_LIMITATION_MSG)

    operation = None
    try:
      operation_ref = adapter.CreateCluster(cluster_ref, options)
      if args.async_:
        return adapter.GetCluster(cluster_ref)

      operation = adapter.WaitForOperation(
          operation_ref,
          'Creating cluster {0} in {1}'.format(cluster_ref.clusterId,
                                               cluster_ref.zone),
          timeout_s=args.timeout)
      cluster = adapter.GetCluster(cluster_ref)
    except apitools_exceptions.HttpError as error:
      raise exceptions.HttpException(error, util.HTTP_ERROR_FORMAT)

    log.CreatedResource(cluster_ref)
    cluster_url = util.GenerateClusterUrl(cluster_ref)
    log.status.Print('To inspect the contents of your cluster, go to: ' +
                     cluster_url)
    if operation.detail:
      # Non-empty detail on a DONE create operation should be surfaced as
      # a warning to end user.
      log.warning(operation.detail)

    try:
      util.ClusterConfig.Persist(cluster, cluster_ref.projectId)
    except kconfig.MissingEnvVarError as error:
      log.warning(error)

    return [cluster]


@base.ReleaseTracks(base.ReleaseTrack.BETA)
class CreateBeta(Create):
  """Create a cluster for running containers."""

  @staticmethod
  def Args(parser):
    AddFlags(BETA, parser)

  def ParseCreateOptions(self, args):
    ops = ParseCreateOptionsBase(args, self.autogke)
    flags.WarnForNodeVersionAutoUpgrade(args)
    flags.ValidateSurgeUpgradeSettings(args)
    flags.ValidateNotificationConfigFlag(args)
    ops.boot_disk_kms_key = getattr(args, 'boot_disk_kms_key', None)
    ops.min_cpu_platform = getattr(args, 'min_cpu_platform', None)
    ops.enable_pod_security_policy = \
        getattr(args, 'enable_pod_security_policy', None)

    ops.allow_route_overlap = getattr(args, 'allow_route_overlap', None)
    ops.private_cluster = getattr(args, 'private_cluster', None)
    ops.istio_config = getattr(args, 'istio_config', None)
    ops.enable_vertical_pod_autoscaling = \
        getattr(args, 'enable_vertical_pod_autoscaling', None)
    ops.security_group = getattr(args, 'security_group', None)
    flags.ValidateIstioConfigCreateArgs(
        getattr(args, 'istio_config', None), getattr(args, 'addons', None))
    ops.max_surge_upgrade = getattr(args, 'max_surge_upgrade', None)
    ops.max_unavailable_upgrade = getattr(args, 'max_unavailable_upgrade', None)
    ops.autoscaling_profile = getattr(args, 'autoscaling_profile', None)
    ops.enable_tpu_service_networking = \
        getattr(args, 'enable_tpu_service_networking', None)
    ops.enable_logging_monitoring_system_only = \
        getattr(args, 'enable_logging_monitoring_system_only', None)
    ops.enable_master_global_access = \
        getattr(args, 'enable_master_global_access', None)
    ops.enable_gvnic = getattr(args, 'enable_gvnic', None)
    ops.system_config_from_file = getattr(args, 'system_config_from_file', None)
    ops.datapath_provider = getattr(args, 'datapath_provider', None)
    ops.dataplane_v2 = getattr(args, 'enable_dataplane_v2', None)
    ops.disable_default_snat = getattr(args, 'disable_default_snat', None)
    ops.enable_master_metrics = getattr(args, 'enable_master_metrics', None)
    ops.master_logs = getattr(args, 'master_logs', None)
    ops.notification_config = getattr(args, 'notification_config', None)
    ops.private_ipv6_google_access_type = getattr(
        args, 'private_ipv6_google_access_type', None)
    ops.enable_confidential_nodes = \
        getattr(args, 'enable_confidential_nodes', None)
    return ops


@base.ReleaseTracks(base.ReleaseTrack.ALPHA)
class CreateAlpha(Create):
  """Create a cluster for running containers."""

  @staticmethod
  def Args(parser):
    AddFlags(ALPHA, parser)

  def ParseCreateOptions(self, args):
    ops = ParseCreateOptionsBase(args, self.autogke)
    flags.WarnForNodeVersionAutoUpgrade(args)
    flags.ValidateSurgeUpgradeSettings(args)
    flags.ValidateCloudRunConfigCreateArgs(args.cloud_run_config, args.addons)
    flags.ValidateNotificationConfigFlag(args)
    ops.boot_disk_kms_key = getattr(args, 'boot_disk_kms_key', None)
    ops.autoscaling_profile = getattr(args, 'autoscaling_profile', None)
    ops.local_ssd_volume_configs = getattr(args, 'local_ssd_volumes', None)
    ops.enable_pod_security_policy = \
        getattr(args, 'enable_pod_security_policy', None)
    ops.allow_route_overlap = getattr(args, 'allow_route_overlap', None)
    ops.private_cluster = getattr(args, 'private_cluster', None)
    ops.enable_private_nodes = getattr(args, 'enable_private_nodes', None)
    ops.enable_private_endpoint = getattr(args, 'enable_private_endpoint', None)
    ops.master_ipv4_cidr = getattr(args, 'master_ipv4_cidr', None)
    ops.enable_tpu_service_networking = \
        getattr(args, 'enable_tpu_service_networking', None)
    ops.istio_config = getattr(args, 'istio_config', None)
    ops.cloud_run_config = getattr(args, 'cloud_run_config', None)
    ops.security_group = getattr(args, 'security_group', None)
    flags.ValidateIstioConfigCreateArgs(
        getattr(args, 'istio_config', None), getattr(args, 'addons', None))
    ops.enable_vertical_pod_autoscaling = \
        getattr(args, 'enable_vertical_pod_autoscaling', None)
    ops.security_profile = getattr(args, 'security_profile', None)
    ops.security_profile_runtime_rules = \
        getattr(args, 'security_profile_runtime_rules', None)
    ops.node_pool_name = getattr(args, 'node_pool_name', None)
    ops.enable_network_egress_metering = \
        getattr(args, 'enable_network_egress_metering', None)
    ops.enable_resource_consumption_metering = \
        getattr(args, 'enable_resource_consumption_metering', None)
    ops.enable_private_ipv6_access = \
        getattr(args, 'enable_private_ipv6_access', None)
    ops.max_surge_upgrade = getattr(args, 'max_surge_upgrade', None)
    ops.max_unavailable_upgrade = getattr(args, 'max_unavailable_upgrade', None)
    ops.linux_sysctls = getattr(args, 'linux_sysctls', None)
    ops.enable_l4_ilb_subsetting = \
        getattr(args, 'enable_l4_ilb_subsetting', None)
    ops.disable_default_snat = getattr(args, 'disable_default_snat', None)
    ops.system_config_from_file = getattr(args, 'system_config_from_file', None)
    ops.enable_cost_management = getattr(args, 'enable_cost_management', None)
    ops.enable_logging_monitoring_system_only = \
        getattr(args, 'enable_logging_monitoring_system_only', None)
    ops.datapath_provider = getattr(args, 'datapath_provider', None)
    ops.dataplane_v2 = getattr(args, 'enable_dataplane_v2', None)
    ops.enable_master_global_access = \
        getattr(args, 'enable_master_global_access', None)
    ops.enable_gvnic = getattr(args, 'enable_gvnic', None)
    ops.enable_master_metrics = getattr(args, 'enable_master_metrics', None)
    ops.master_logs = getattr(args, 'master_logs', None)
    ops.notification_config = getattr(args, 'notification_config', None)
    ops.private_ipv6_google_access_type = getattr(
        args, 'private_ipv6_google_access_type', None)
    ops.enable_confidential_nodes = \
        getattr(args, 'enable_confidential_nodes', None)
    ops.cluster_dns = getattr(args, 'cluster_dns', None)
    ops.cluster_dns_scope = getattr(args, 'cluster_dns_scope', None)
    ops.cluster_dns_domain = getattr(args, 'cluster_dns_domain', None)
    return ops
