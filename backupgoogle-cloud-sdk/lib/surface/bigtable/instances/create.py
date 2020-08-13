# -*- coding: utf-8 -*- #
# Copyright 2016 Google LLC. All Rights Reserved.
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
"""bigtable instances create command."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

import textwrap

from googlecloudsdk.api_lib.bigtable import util
from googlecloudsdk.calliope import base
from googlecloudsdk.command_lib.bigtable import arguments
from googlecloudsdk.core import log
from googlecloudsdk.core import resources


@base.ReleaseTracks(base.ReleaseTrack.GA, base.ReleaseTrack.BETA)
class CreateInstance(base.CreateCommand):
  """Create a new Bigtable instance."""

  detailed_help = {
      'EXAMPLES':
          textwrap.dedent("""\
          To create an instance with id `my-instance-id` with a cluster located
          in `us-east1-c`, run:

            $ {command} my-instance-id --display-name="My Instance" --cluster=my-cluster-id --cluster-zone=us-east1-c

          To create a `DEVELOPMENT` instance, run:

            $ {command} my-dev-instance --display-name="Dev Instance" --instance-type=DEVELOPMENT --cluster=my-cluster-id --cluster-zone=us-east1-c

          To create an instance with `HDD` storage and `10` nodes, run:

            $ {command} my-hdd-instance --display-name="HDD Instance" --cluster-storage-type=HDD --cluster-num-nodes=10 --cluster=my-cluster-id --cluster-zone=us-east1-c

          """),
  }

  @staticmethod
  def Args(parser):
    """Register flags for this command."""
    (arguments.ArgAdder(parser)
     .AddInstanceDisplayName(required=True)
     .AddCluster().AddClusterNodes(in_instance=True)
     .AddClusterStorage().AddClusterZone(in_instance=True)
     .AddAsync().AddInstanceType(
         default='PRODUCTION', help_text='The type of instance to create.'))
    arguments.AddInstanceResourceArg(parser, 'to create', positional=True)
    parser.display_info.AddCacheUpdater(arguments.InstanceCompleter)

  def Run(self, args):
    """This is what gets called when the user runs this command.

    Args:
      args: an argparse namespace. All the arguments that were provided to this
        command invocation.

    Returns:
      Some value that we want to have printed later.
    """
    cli = util.GetAdminClient()
    ref = args.CONCEPTS.instance.Parse()
    # TODO(b/153576330): This is a workaround for inconsistent collection names.
    parent_ref = resources.REGISTRY.Create(
        'bigtableadmin.projects', projectId=ref.projectsId)
    cluster = self._Cluster(args)
    msgs = util.GetAdminMessages()
    instance_type = msgs.Instance.TypeValueValuesEnum(args.instance_type)
    msg = msgs.CreateInstanceRequest(
        instanceId=ref.Name(),
        parent=parent_ref.RelativeName(),
        instance=msgs.Instance(
            displayName=args.display_name,
            type=instance_type),
        clusters=msgs.CreateInstanceRequest.ClustersValue(additionalProperties=[
            msgs.CreateInstanceRequest.ClustersValue.AdditionalProperty(
                key=args.cluster, value=cluster)
        ]))
    result = cli.projects_instances.Create(msg)
    operation_ref = util.GetOperationRef(result)

    if args.async_:
      log.CreatedResource(
          operation_ref.RelativeName(),
          kind='bigtable instance {0}'.format(ref.Name()),
          is_async=True)
      return result

    return util.AwaitInstance(
        operation_ref, 'Creating bigtable instance {0}'.format(ref.Name()))

  def _Cluster(self, args):
    msgs = util.GetAdminMessages()
    num_nodes = arguments.ProcessInstanceTypeAndNodes(args)
    storage_type = msgs.Cluster.DefaultStorageTypeValueValuesEnum(
        args.cluster_storage_type.upper())
    return msgs.Cluster(
        serveNodes=num_nodes,
        defaultStorageType=storage_type,
        # TODO(b/36049938): switch location to resource
        # when b/29566669 is fixed on API
        location=util.LocationUrl(args.cluster_zone))


@base.ReleaseTracks(base.ReleaseTrack.ALPHA)
class CreateInstanceAlpha(CreateInstance):
  """Create a new Bigtable instance."""

  @staticmethod
  def Args(parser):
    """Register flags for this command."""
    CreateInstance.Args(parser)
    arguments.AddKmsKeyResourceArg(parser, 'cluster')

  def _Cluster(self, args):
    msgs = util.GetAdminMessages()
    num_nodes = arguments.ProcessInstanceTypeAndNodes(args)
    storage_type = msgs.Cluster.DefaultStorageTypeValueValuesEnum(
        args.cluster_storage_type.upper())
    cluster = msgs.Cluster(
        serveNodes=num_nodes,
        defaultStorageType=storage_type,
        # TODO(b/36049938): switch location to resource
        # when b/29566669 is fixed on API
        location=util.LocationUrl(args.cluster_zone))
    kms_key = arguments.GetAndValidateKmsKeyName(args)
    if kms_key:
      cluster.encryptionConfig = msgs.EncryptionConfig(
          kmsKeyName=kms_key)
    return cluster
