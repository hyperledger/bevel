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
"""Command to deploy an Apigee API proxy to an environment."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

from googlecloudsdk.api_lib import apigee
from googlecloudsdk.calliope import base
from googlecloudsdk.command_lib.apigee import defaults
from googlecloudsdk.command_lib.apigee import resource_args
from googlecloudsdk.core import log


class Deploy(base.DescribeCommand):
  """Deploys an Apigee API proxy."""

  detailed_help = {
      "DESCRIPTION": """\
  Deploy an Apigee API proxy to an environment.

  This command expects the API proxy's base path to not already be in use by a
  deployed proxy in the target environment. If it is in use, the deployment will
  fail by default. To instead undeploy the existing API proxy as part of the new
  deployment, use the `--override` command.

  Once a particular revision of an API proxy has been deployed, that revision
  can no longer be modified. Any updates to the API proxy must be saved as a new
  revision.
  """,
      "EXAMPLES": """\
  To deploy the latest revision of the API proxy named ``demo'' to the ``test''
  environment, given that the API proxy and environment's matching Cloud
  Platform project has been set in gcloud settings, run:

    $ {command} --environment=test --api=demo

  To deploy revision 3 of that proxy, owned by an organization named ``my-org'',
  run, and replace any conflicting deployment that might already exist, run:

    $ {command} 3 --organization=my-org --environment=test --api=demo --override
  """
  }

  @staticmethod
  def Args(parser):
    parser.add_argument(
        "--override", action="store_true",
        help=("Whether to force the deployment of the new revision over the " +
              "currently deployed revision by overriding conflict checks.\n\n" +
              "If an existing API proxy revision is deployed, set this flag " +
              "to ensure seamless deployment with zero downtime. In this " +
              "case, the existing revision remains deployed until the new " +
              "revision is fully deployed. If not set, you must undeploy " +
              "the currently deployed revision before deploying the new " +
              "revision."))

    help_text = {
        "api": "The API proxy to be deployed.",
        "environment": "The environment in which to deploy the API proxy.",
        "organization": "The Apigee organization of the proxy and environment."
    }
    fallthroughs = [defaults.GCPProductOrganizationFallthrough(),
                    defaults.StaticFallthrough("revision", "latest")]
    resource_args.AddSingleResourceArgument(
        parser, "organization.environment.api.revision",
        "The API proxy revision to be deployed, and the environment in which "
        "to deploy it. The revision defaults to `latest`, a special value "
        "which will use the latest revision of the API proxy.",
        fallthroughs=fallthroughs, help_texts=help_text)

    # The default "/" basepath is added on the server side.
    parser.add_argument("--basepath",
                        help=("Base path where the API proxy revision should "
                              "be deployed. Defaults to `/` if not provided."))

  def Run(self, args):
    """Run the deploy command."""
    identifiers = args.CONCEPTS.revision.Parse().AsDict()
    if identifiers["revisionsId"] == "latest":
      latest_revision = apigee.APIsClient.Describe(identifiers)["revision"][-1]
      log.status.Print("Using current latest revision `%s`"%latest_revision)
      identifiers["revisionsId"] = latest_revision

    result = apigee.APIsClient.Deploy(identifiers, args.override, args.basepath)
    return result
