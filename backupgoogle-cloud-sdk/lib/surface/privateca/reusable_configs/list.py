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
"""List reusable configs in a location."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

from apitools.base.py import list_pager

from googlecloudsdk.api_lib.privateca import base as privateca_base
from googlecloudsdk.api_lib.privateca import constants
from googlecloudsdk.api_lib.privateca import locations
from googlecloudsdk.api_lib.util import common_args
from googlecloudsdk.calliope import base
from googlecloudsdk.command_lib.privateca import response_utils


def _GetLocation(args):
  if args.IsSpecified('location'):
    return args.location

  # During alpha, we replicate the same set of resources across all locations.
  return locations.GetSupportedLocations()[0]


class List(base.ListCommand):
  """List reusable configs in a location."""

  @staticmethod
  def Args(parser):
    base.Argument(
        '--location',
        help=('Location of the reusable configs. If this is not specified, it '
              'defaults to the first location supported by the service.'
             )).AddToParser(parser)
    base.PAGE_SIZE_FLAG.SetDefault(parser, 100)
    base.SORT_BY_FLAG.SetDefault(parser, 'name')

    parser.display_info.AddFormat("""
        table(
          name.scope("reusableConfigs"):label=NAME,
          description)
        """)

  def Run(self, args):
    """Runs the command."""

    client = privateca_base.GetClientInstance()
    messages = privateca_base.GetMessagesModule()

    project = constants.PREDEFINED_REUSABLE_CONFIG_PROJECT
    location = _GetLocation(args)
    parent_resource = 'projects/{}/locations/{}'.format(project, location)

    request = messages.PrivatecaProjectsLocationsReusableConfigsListRequest(
        parent=parent_resource,
        orderBy=common_args.ParseSortByArg(args.sort_by),
        pageSize=args.page_size,
        filter=args.filter)

    return list_pager.YieldFromList(
        client.projects_locations_reusableConfigs,
        request,
        field='reusableConfigs',
        limit=args.limit,
        batch_size_attribute='pageSize',
        get_field_func=response_utils.GetFieldAndLogUnreachable)
