# -*- coding: utf-8 -*- # Lint as: python3
# Copyright 2020 Google Inc. All Rights Reserved.
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
"""Command to undeploy an Apigee API proxy from an environment."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

from googlecloudsdk.api_lib import apigee
from googlecloudsdk.calliope import base
from googlecloudsdk.command_lib.apigee import defaults
from googlecloudsdk.command_lib.apigee import resource_args


class Undeploy(base.SilentCommand):
  """Undeploy an Apigee API proxy from an environment."""

  detailed_help = {
      "DESCRIPTION": "Undeploy an Apigee API proxy from an environment.",
      "EXAMPLES": """\
  To undeploy an API proxy called ``my-api'' from the ``test'' environment of
  the active Cloud Platform project, run:

    $ {command} --environment=test --api=my-api

  To undeploy revision 3 of an `my-api` from the `test` environment of Apigee
  organization ``test-org'', run:

    $ {command} --organization=test-org --environment=test --api=my-api 3
  """}

  @staticmethod
  def Args(parser):
    help_text = {
        "api": "The API proxy to be undeployed.",
        "environment": "The environment from which to undeploy the API proxy.",
        "organization": "The organization of the proxy and environment."
    }
    fallthroughs = [defaults.GCPProductOrganizationFallthrough(),
                    defaults.StaticFallthrough("revision", "auto")]
    resource_args.AddSingleResourceArgument(
        parser, "organization.environment.api.revision",
        "The API proxy revision to be undeployed, and the environment from "
        "which it should be removed. The revision defaults to `auto`, which "
        "will undeploy whichever revision is currently deployed, unless there "
        "is more than one such revision.",
        fallthroughs=fallthroughs, help_texts=help_text)

  def Run(self, args):
    """Run the undeploy command."""
    identifiers = args.CONCEPTS.revision.Parse().AsDict()
    if identifiers["revisionsId"] == "auto":
      del identifiers["revisionsId"]
      defaults.FallBackToDeployedProxyRevision(identifiers)

    return apigee.APIsClient.Undeploy(identifiers)
