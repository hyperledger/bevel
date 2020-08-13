# -*- coding: utf-8 -*- #
# Copyright 2020 Google LLC. All Rights Reserved.
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
"""Command for deleting a service."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

from googlecloudsdk.api_lib.events import iam_util
from googlecloudsdk.api_lib.services import services_util
from googlecloudsdk.api_lib.services import serviceusage
from googlecloudsdk.calliope import base
from googlecloudsdk.command_lib.events import eventflow_operations
from googlecloudsdk.command_lib.events import exceptions
from googlecloudsdk.command_lib.events import flags
from googlecloudsdk.command_lib.iam import iam_util as core_iam_util
from googlecloudsdk.command_lib.run import connection_context
from googlecloudsdk.command_lib.run import flags as serverless_flags
from googlecloudsdk.core import log
from googlecloudsdk.core import properties
from googlecloudsdk.core import resources
from googlecloudsdk.core.console import console_io


_CONTROL_PLANE_SECRET_NAME = 'google-cloud-key'
# This is the superset of roles needed across the available source types.
_CONTROL_PLANE_REQUIRED_ROLES = [
    'roles/cloudscheduler.admin',
    'roles/logging.configWriter',
    'roles/logging.privateLogViewer',
    'roles/pubsub.admin',
    'roles/storage.admin',
]
_CONTROL_PLANE_NAMESPACE = 'cloud-run-events'
_CONTROL_PLANE_REQUIRED_SERVICES = [
    # cloudresourcemanager isn't required for eventing itself, but is required
    # for this command to perform the IAM bindings necessary.
    'cloudresourcemanager.googleapis.com',
    'cloudscheduler.googleapis.com',
    'logging.googleapis.com',
    'pubsub.googleapis.com',
    'stackdriver.googleapis.com',
    'storage-api.googleapis.com',
    'storage-component.googleapis.com',
]


class Init(base.Command):
  """Initialize a cluster for eventing."""

  detailed_help = {
      'DESCRIPTION': """
          {description}
          Enables necessary services for the project, adds necessary IAM policy
          bindings to the provided service account, and creates a new key for
          the provided service account.
          This command is only available with Cloud Run for Anthos.
          """,
      'EXAMPLES': """
          To initialize a cluster:

              $ {command}
          """,
  }

  @staticmethod
  def CommonArgs(parser):
    """Defines arguments common to all release tracks."""
    flags.AddServiceAccountFlag(parser)

  @staticmethod
  def Args(parser):
    Init.CommonArgs(parser)

  def Run(self, args):
    """Executes when the user runs the delete command."""
    if serverless_flags.GetPlatform() == serverless_flags.PLATFORM_MANAGED:
      raise exceptions.UnsupportedArgumentError(
          'This command is only available with Cloud Run for Anthos.')

    project = properties.VALUES.core.project.Get(required=True)
    conn_context = connection_context.GetConnectionContext(
        args, serverless_flags.Product.EVENTS, self.ReleaseTrack())

    _EnableMissingServices(project)
    if not args.IsSpecified('service_account'):
      sa_email = iam_util.GetOrCreateEventingServiceAccountWithPrompt()
    else:
      sa_email = args.service_account

    service_account_ref = resources.REGISTRY.Parse(
        sa_email,
        params={'projectsId': '-'},
        collection=core_iam_util.SERVICE_ACCOUNTS_COLLECTION)
    secret_ref = resources.REGISTRY.Parse(
        _CONTROL_PLANE_SECRET_NAME,
        params={'namespacesId': _CONTROL_PLANE_NAMESPACE},
        collection='run.api.v1.namespaces.secrets',
        api_version='v1')

    with eventflow_operations.Connect(conn_context) as client:
      iam_util.BindMissingRolesWithPrompt(
          service_account_ref, _CONTROL_PLANE_REQUIRED_ROLES)
      _PromptIfCanPrompt(
          '\nThis will create a new key for the service account [{}].'
          .format(sa_email))
      _, key_ref = client.CreateOrReplaceServiceAccountSecret(
          secret_ref, service_account_ref)

    command_string = 'gcloud '
    if self.ReleaseTrack() != base.ReleaseTrack.GA:
      command_string += self.ReleaseTrack().prefix + ' '
    command_string += 'events brokers create'
    log.status.Print('Initialized cluster [{}] for Cloud Run eventing with '
                     'key [{}] for service account [{}]. '
                     'Next, create a broker in the namespace(s) you plan to '
                     'use via `{}`.'.format(
                         args.CONCEPTS.cluster.Parse().Name(),
                         key_ref.Name(),
                         service_account_ref.Name(),
                         command_string))


def _EnableMissingServices(project):
  """Enables any required services for the project."""
  enabled_services = set(
      service.config.name for service in
      serviceusage.ListServices(project, True, 100, None))
  missing_services = list(sorted(
      set(_CONTROL_PLANE_REQUIRED_SERVICES) - enabled_services))
  if not missing_services:
    return

  formatted_services = '\n'.join(
      ['- {}'.format(s) for s in missing_services])
  _PromptIfCanPrompt('\nThis will enable the following services:\n'
                     '{}'.format(formatted_services))
  if len(missing_services) == 1:
    op = serviceusage.EnableApiCall(project, missing_services[0])
  else:
    op = serviceusage.BatchEnableApiCall(project, missing_services)
  if not op.done:
    op = services_util.WaitOperation(op.name, serviceusage.GetOperation)
  log.status.Print('Services successfully enabled.')


def _PromptIfCanPrompt(message):
  if console_io.CanPrompt():
    console_io.PromptContinue(message=message, cancel_on_no=True)
