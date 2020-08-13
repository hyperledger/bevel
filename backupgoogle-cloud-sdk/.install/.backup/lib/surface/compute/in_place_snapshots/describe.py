# -*- coding: utf-8 -*- #
# Copyright 2019 Google LLC. All Rights Reserved.
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
"""Command for describing in-place snapshot."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

from googlecloudsdk.api_lib.compute import base_classes
from googlecloudsdk.calliope import base
from googlecloudsdk.command_lib.compute.in_place_snapshots import flags as ips_flags


def _CommonArgs(parser):
  Describe.ips_arg.AddArgument(parser, operation_type='describe')


@base.ReleaseTracks(base.ReleaseTrack.ALPHA)
class Describe(base.DescribeCommand):
  """Describe a Google Compute Engine in-place snapshot."""

  @staticmethod
  def Args(parser):
    Describe.ips_arg = ips_flags.MakeInPlaceSnapshotArg(plural=False)
    _CommonArgs(parser)

  def Run(self, args):
    holder = base_classes.ComputeApiHolder(self.ReleaseTrack())
    client = holder.client
    messages = client.messages

    ips_ref = Describe.ips_arg.ResolveAsResource(args, holder.resources)

    if ips_ref.Collection() == 'compute.zoneInPlaceSnapshots':
      service = client.apitools_client.zoneInPlaceSnapshots
      request_type = messages.ComputeZoneInPlaceSnapshotsGetRequest
    elif ips_ref.Collection() == 'compute.regionInPlaceSnapshots':
      service = client.apitools_client.regionInPlaceSnapshots
      request_type = messages.ComputeRegionInPlaceSnapshotsGetRequest

    return client.MakeRequests([(service, 'Get',
                                 request_type(**ips_ref.AsDict()))])


Describe.detailed_help = {
    'brief':
        'Describe a Google Compute Engine in-place snapshot',
    'DESCRIPTION':
        """\
        *{command}* displays all data associated with a Google Compute
        Engine in-place snapshot in a project.
        """,
    'EXAMPLES':
        """\
        To describe the in-place snapshot 'ips-1' in zone 'us-east1-a', run:

            $ {command} ips-1 --zone=us-east1-a
        """,
}
