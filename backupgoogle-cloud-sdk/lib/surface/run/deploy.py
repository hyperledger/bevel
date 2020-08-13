# -*- coding: utf-8 -*- #
# Copyright 2018 Google LLC. All Rights Reserved.
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
"""Deploy a container to Cloud Run."""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import uuid

from googlecloudsdk.api_lib.cloudbuild import cloudbuild_util
from googlecloudsdk.api_lib.run import traffic
from googlecloudsdk.calliope import base
from googlecloudsdk.command_lib.builds import flags as build_flags
from googlecloudsdk.command_lib.builds import submit_util
from googlecloudsdk.command_lib.run import config_changes as config_changes_mod
from googlecloudsdk.command_lib.run import connection_context
from googlecloudsdk.command_lib.run import flags
from googlecloudsdk.command_lib.run import messages_util
from googlecloudsdk.command_lib.run import pretty_print
from googlecloudsdk.command_lib.run import resource_args
from googlecloudsdk.command_lib.run import serverless_operations
from googlecloudsdk.command_lib.run import stages
from googlecloudsdk.command_lib.util.concepts import concept_parsers
from googlecloudsdk.command_lib.util.concepts import presentation_specs
from googlecloudsdk.core import properties
from googlecloudsdk.core import resources
from googlecloudsdk.core.console import progress_tracker


def GetAllowUnauth(args, operations, service_ref, service_exists):
  """Returns allow_unauth value for a service change.

  Args:
    args: argparse.Namespace, Command line arguments
    operations: serverless_operations.ServerlessOperations, Serverless client.
    service_ref: protorpc.messages.Message, A resource reference object for the
      service See googlecloudsdk.core.resources.Registry.ParseResourceId for
      details.
    service_exists: True if the service being changed already exists.

  Returns:
    allow_unauth value where
     True means to enable unauthenticated acess for the service.
     False means to disable unauthenticated access for the service.
     None means to retain the current value for the service.
  """
  allow_unauth = None
  if flags.GetPlatform() == flags.PLATFORM_MANAGED:
    allow_unauth = flags.GetAllowUnauthenticated(args, operations, service_ref,
                                                 not service_exists)
    # Avoid failure removing a policy binding for a service that
    # doesn't exist.
    if not service_exists and not allow_unauth:
      allow_unauth = None
  return allow_unauth


@base.ReleaseTracks(base.ReleaseTrack.GA)
class Deploy(base.Command):
  """Deploy a container to Cloud Run."""

  detailed_help = {
      'DESCRIPTION':
          """\
          Deploys container images to Google Cloud Run.
          """,
      'EXAMPLES':
          """\
          To deploy a container to the service `my-backend` on Cloud Run:

              $ {command} my-backend --image=gcr.io/my/image

          You may also omit the service name. Then a prompt will be displayed
          with a suggested default value:

              $ {command} --image=gcr.io/my/image

          To deploy to Cloud Run on Kubernetes Engine, you need to specify a cluster:

              $ {command} --image=gcr.io/my/image --cluster=my-cluster
          """,
  }

  @staticmethod
  def CommonArgs(parser):
    # Flags specific to managed CR
    managed_group = flags.GetManagedArgGroup(parser)
    flags.AddAllowUnauthenticatedFlag(managed_group)
    flags.AddCloudSQLFlags(managed_group)
    flags.AddRevisionSuffixArg(managed_group)
    flags.AddVpcConnectorArg(managed_group)

    # Flags specific to connecting to a cluster
    cluster_group = flags.GetClusterArgGroup(parser)
    flags.AddEndpointVisibilityEnum(cluster_group)
    flags.AddSecretsFlags(cluster_group)
    flags.AddConfigMapsFlags(cluster_group)
    flags.AddHttp2Flag(cluster_group)

    # Flags not specific to any platform
    service_presentation = presentation_specs.ResourcePresentationSpec(
        'SERVICE',
        resource_args.GetServiceResourceSpec(prompt=True),
        'Service to deploy to.',
        required=True,
        prefixes=False)
    flags.AddFunctionArg(parser)
    flags.AddMutexEnvVarsFlags(parser)
    flags.AddMemoryFlag(parser)
    flags.AddConcurrencyFlag(parser)
    flags.AddTimeoutFlag(parser)
    flags.AddAsyncFlag(parser)
    flags.AddLabelsFlags(parser)
    flags.AddMaxInstancesFlag(parser)
    flags.AddCommandFlag(parser)
    flags.AddArgsFlag(parser)
    flags.AddPortFlag(parser)
    flags.AddCpuFlag(parser)
    flags.AddNoTrafficFlag(parser)
    flags.AddServiceAccountFlag(parser)
    concept_parsers.ConceptParser([service_presentation]).AddToParser(parser)

  @staticmethod
  def Args(parser):
    Deploy.CommonArgs(parser)
    flags.AddImageArg(parser)

    # Flags only supported on GKE and Knative
    cluster_group = flags.GetClusterArgGroup(parser)
    flags.AddMinInstancesFlag(cluster_group)

  def Run(self, args):
    """Deploy a container to Cloud Run."""
    service_ref = flags.GetService(args)
    build_op_ref = None
    messages = None
    build_log_url = None
    image = args.image
    include_build = flags.FlagIsExplicitlySet(args, 'source')
    # Build an image from source if source specified.
    if include_build:
      # Create a tag for the image creation
      if (image is None and not args.IsSpecified('config') and
          not args.IsSpecified('pack')):
        image = 'gcr.io/{projectID}/cloud-run-source-deploy/{service}:{tag}'.format(
            projectID=properties.VALUES.core.project.Get(required=True),
            service=service_ref.servicesId,
            tag=uuid.uuid4().hex)

      messages = cloudbuild_util.GetMessagesModule()
      build_config = submit_util.CreateBuildConfigAlpha(
          image, args.no_cache, messages, args.substitutions, args.config,
          args.IsSpecified('source'), False, args.source,
          args.gcs_source_staging_dir, args.ignore_file, args.gcs_log_dir,
          args.machine_type, args.disk_size, args.pack)

      if args.IsSpecified('pack'):
        image = args.pack[0].get('image')

      build, build_op = submit_util.Build(messages, True, build_config, True)
      build_op_ref = resources.REGISTRY.ParseRelativeName(
          build_op.name, 'cloudbuild.operations')
      build_log_url = build.logUrl
    # Deploy a container with an image
    conn_context = connection_context.GetConnectionContext(
        args, flags.Product.RUN, self.ReleaseTrack())
    config_changes = flags.GetConfigurationChanges(args)

    with serverless_operations.Connect(conn_context) as operations:
      image_change = config_changes_mod.ImageChange(image)
      changes = [image_change]
      if config_changes:
        changes.extend(config_changes)
      service = operations.GetService(service_ref)
      allow_unauth = GetAllowUnauth(args, operations, service_ref, service)

      pretty_print.Info(
          messages_util.GetStartDeployMessage(conn_context, service_ref))
      has_latest = (
          service is None or
          traffic.LATEST_REVISION_KEY in service.spec_traffic)
      deployment_stages = stages.ServiceStages(
          include_iam_policy_set=allow_unauth is not None,
          include_route=has_latest,
          include_build=include_build)
      header = 'Deploying'
      if include_build:
        header += ' and building'
      if service is None:
        header += ' new service'
      header += '...'
      with progress_tracker.StagedProgressTracker(
          header,
          deployment_stages,
          failure_message='Deployment failed',
          suppress_output=args.async_) as tracker:
        operations.ReleaseService(
            service_ref,
            changes,
            tracker,
            asyn=args.async_,
            allow_unauthenticated=allow_unauth,
            prefetch=service,
            build_op_ref=build_op_ref,
            build_log_url=build_log_url)
      if args.async_:
        pretty_print.Success(
            'Service [{{bold}}{serv}{{reset}}] is deploying '
            'asynchronously.'.format(serv=service_ref.servicesId))
      else:
        pretty_print.Success(
            messages_util.GetSuccessMessageForSynchronousDeploy(
                operations, service_ref))


@base.ReleaseTracks(base.ReleaseTrack.BETA)
class BetaDeploy(Deploy):
  """Deploy a container to Cloud Run."""

  @staticmethod
  def Args(parser):
    Deploy.Args(parser)
    flags.AddDeployTagFlag(parser)


@base.ReleaseTracks(base.ReleaseTrack.ALPHA)
class AlphaDeploy(Deploy):
  """Deploy a container to Cloud Run."""

  @staticmethod
  def Args(parser):
    Deploy.CommonArgs(parser)

    # Flags specific to VPCAccess
    managed_group = flags.GetManagedArgGroup(parser)
    flags.AddEgressSettingsFlag(managed_group)

    # Flags not specific to any platform
    flags.AddMinInstancesFlag(parser)
    flags.AddDeployTagFlag(parser)

    # Flags inherited from gcloud builds submit
    flags.AddConfigFlags(parser)
    flags.AddSourceFlag(parser)
    flags.AddBuildTimeoutFlag(parser)
    build_flags.AddGcsSourceStagingDirFlag(parser, True)
    build_flags.AddGcsLogDirFlag(parser, True)
    build_flags.AddMachineTypeFlag(parser, True)
    build_flags.AddDiskSizeFlag(parser, True)
    build_flags.AddSubstitutionsFlag(parser, True)
    build_flags.AddNoCacheFlag(parser, True)
    build_flags.AddIgnoreFileFlag(parser, True)


AlphaDeploy.__doc__ = Deploy.__doc__
