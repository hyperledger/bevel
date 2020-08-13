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
"""`gcloud domains registrations export` command."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

from googlecloudsdk.api_lib.domains import registrations
from googlecloudsdk.calliope import base
from googlecloudsdk.command_lib.domains import flags
from googlecloudsdk.command_lib.domains import resource_args
from googlecloudsdk.command_lib.domains import util
from googlecloudsdk.core import log
from googlecloudsdk.core.console import console_io


@base.ReleaseTracks(base.ReleaseTrack.ALPHA)
class Export(base.DeleteCommand):
  """Export a Cloud Domains registration.

  Export the domain to direct management by Google Domains. The domain remains
  valid until expiry. For information on how to access it in Google Domains
  after exporting, see https://support.google.com/domains/answer/6339340.

  ## EXAMPLES

  To export a registration for ``example.com'', run:

    $ {command} example.com
  """

  @staticmethod
  def Args(parser):
    resource_args.AddRegistrationResourceArg(parser, 'to export')
    flags.AddAsyncFlagToParser(parser)

  def Run(self, args):
    client = registrations.RegistrationsClient()
    args.registration = util.NormalizeResourceName(args.registration)
    registration_ref = args.CONCEPTS.registration.Parse()

    console_io.PromptContinue(
        'You are about to export registration \'{}\''.format(
            registration_ref.registrationsId),
        throw_if_unattended=True,
        cancel_on_no=True)

    response = client.Export(registration_ref)

    response = util.WaitForOperation(response, args.async_)
    log.ExportResource(
        registration_ref.Name(),
        'registration',
        is_async=args.async_,
        details=('Note:\nRegistration remains valid until expiry. See '
                 'https://support.google.com/domains/answer/6339340 for '
                 'information how to access it in Google Domains.'))
    return response
