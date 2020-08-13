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
"""'vmware cluster delete' command."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

from googlecloudsdk.api_lib.vmware.clusters import ClustersClient
from googlecloudsdk.calliope import base
from googlecloudsdk.command_lib.vmware import flags

DETAILED_HELP = {
    'DESCRIPTION':
        """
          Delete a VMware cluster.
        """,
    'EXAMPLES':
        """
    To delete a cluster called my-cluster in example-privatecloud, location us-central1, run:

      $ {command} /projects/my-project/locations/us-central1/privateclouds/example-privatecloud/clusters/my-cluster

    Or:

      $ {command} my-cluster --privatecloud=example-privatecloud --location=us-central1 --project=my-project

    Or:

      $ {command} my-cluster --privatecloud=example-privatecloud

    In the third example, the project and location are taken from gcloud properties core/project and vmware/location.
    """,
}


@base.ReleaseTracks(base.ReleaseTrack.ALPHA)
class Delete(base.DeleteCommand):
  """Delete a Cloud VMware cluster."""

  @staticmethod
  def Args(parser):
    """Register flags for this command."""
    flags.AddClusterArgToParser(parser)

  def Run(self, args):
    cluster = args.CONCEPTS.cluster.Parse()
    client = ClustersClient()
    operation = client.Delete(cluster)
    return client.WaitForOperation(
        operation,
        'waiting for cluster [{}] to be deleted'.format(cluster),
        is_delete=True)


Delete.detailed_help = DETAILED_HELP
