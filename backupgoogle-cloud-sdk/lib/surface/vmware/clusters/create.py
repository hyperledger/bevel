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
"""'vmware cluster create' command."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

from googlecloudsdk.api_lib.vmware.clusters import ClustersClient
from googlecloudsdk.calliope import base
from googlecloudsdk.command_lib.util.args import labels_util
from googlecloudsdk.command_lib.vmware import flags
from googlecloudsdk.core import properties

DETAILED_HELP = {
    'DESCRIPTION':
        """
          Create a Vmware cluster.
        """,
    'EXAMPLES':
        """
      To create a cluster called my-cluster in example-privatecloud, location us-central1, with a specified zone (in which nodes are created):

      $ {command} /projects/my-project/locations/us-central1/privateclouds/example-privatecloud/clusters/my-cluster -zone=us-central1-a --node-count=3

    Or:

      $ {command} my-cluster --privatecloud=example-privatecloud --location=us-central1 --project=my-project -zone=us-central1-a --node-count=3

    Or:

      $ {command} my-cluster --privatecloud=example-privatecloud -zone=us-central1-a --node-count=3


    In the third example, the project and location are taken from gcloud properties core/project and vmware/location.
    """,
}


@base.ReleaseTracks(base.ReleaseTrack.ALPHA)
class Create(base.CreateCommand):
  """Create a Cloud VMware cluster."""

  @staticmethod
  def Args(parser):
    """Register flags for this command."""
    flags.AddClusterArgToParser(parser)
    parser.add_argument(
        '--node-count',
        required=True,
        type=int,
        help="""\
        Initial number of nodes in the cluster
        """)
    parser.add_argument(
        '--zone',
        required=True,
        help="""\
        Zone in which to create nodes in the cluster
        """)
    labels_util.AddCreateLabelsFlags(parser)

  def Run(self, args):
    cluster = args.CONCEPTS.cluster.Parse()
    client = ClustersClient()
    node_type = properties.VALUES.vmware.node_type.Get()
    node_count = args.node_count
    zone = args.zone
    operation = client.Create(cluster, node_count, node_type, zone, args.labels)
    return client.WaitForOperation(
        operation, 'waiting for cluster [{}] to be created'.format(cluster))


Create.detailed_help = DETAILED_HELP
