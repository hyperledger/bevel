# Lint as: python3
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
"""Create a new root certificate authority."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

from googlecloudsdk.api_lib.privateca import base as privateca_base
from googlecloudsdk.api_lib.privateca import request_utils
from googlecloudsdk.calliope import base
from googlecloudsdk.calliope.concepts import deps
from googlecloudsdk.command_lib.kms import resource_args as kms_resource_args
from googlecloudsdk.command_lib.privateca import create_utils
from googlecloudsdk.command_lib.privateca import flags
from googlecloudsdk.command_lib.privateca import iam
from googlecloudsdk.command_lib.privateca import operations
from googlecloudsdk.command_lib.privateca import p4sa
from googlecloudsdk.command_lib.privateca import resource_args as privateca_resource_args
from googlecloudsdk.command_lib.privateca import storage
from googlecloudsdk.command_lib.util.args import labels_util
from googlecloudsdk.command_lib.util.concepts import concept_parsers
from googlecloudsdk.command_lib.util.concepts import presentation_specs
from googlecloudsdk.core import log


class Create(base.CreateCommand):
  r"""Create a new root certificate authority.

  ## EXAMPLES

  To create a root CA that supports one layer of subordinates:

      $ {command} prod-root \
        --kms-key-version \
        "projects/joonix-pki/locations/us-west1/keyRings/kr1/cryptoKeys/k1/cryptoKeyVersions/1"
        \
        --subject "CN=Joonix Production Root CA" \
        --max-chain-length 1

  To create a root CA and restrict what it can issue:

      $ {command} prod-root \
        --kms-key-version \
        "projects/joonix-pki/locations/us-west1/keyRings/kr1/cryptoKeys/k1/cryptoKeyVersions/1"
        \
        --subject "CN=Joonix Production Root CA" \
        --issuance-policy policy.yaml

  To create a root CA that doesn't publicly publish CA certificate and CRLs:

      $ {command} root-2 \
        --kms-key-version \
        "projects/joonix-pki/locations/us-west1/keyRings/kr1/cryptoKeys/k1/cryptoKeyVersions/1"
        \
        --subject "CN=Joonix Production Root CA" \
        --issuance-policy policy.yaml \
        --no-publish-ca-cert \
        --no-publish-crl

  To create a root CA that is based on an existing CA:

      $ {command} prod-root \
        --kms-key-version \
        "projects/joonix-pki/locations/us-west1/keyRings/kr1/cryptoKeys/k1/cryptoKeyVersions/1"
        \
        --from-ca source-root --from-ca-location us-central1
  """

  def __init__(self, *args, **kwargs):
    super(Create, self).__init__(*args, **kwargs)
    self.client = privateca_base.GetClientInstance()
    self.messages = privateca_base.GetMessagesModule()

  @staticmethod
  def Args(parser):
    reusable_config_group = parser.add_group(
        mutex=True,
        required=False,
        help='The X.509 configuration used for the CA certificate.')

    concept_parsers.ConceptParser([
        presentation_specs.ResourcePresentationSpec(
            'CERTIFICATE_AUTHORITY',
            privateca_resource_args.CreateCertificateAuthorityResourceSpec(
                'Certificate Authority'),
            'The name of the root CA to create.',
            required=True,
            # We'll get these from the KMS key resource.
            flag_name_overrides={
                'location': '',
                'project': '',
            }),
        presentation_specs.ResourcePresentationSpec(
            '--kms-key-version',
            kms_resource_args.GetKmsKeyVersionResourceSpec(),
            'The KMS key version backing this CA.',
            required=True),
        presentation_specs.ResourcePresentationSpec(
            '--reusable-config',
            privateca_resource_args.CreateReusableConfigResourceSpec(
                location_fallthrough=deps.Fallthrough(
                    function=lambda: '',
                    hint=('location will default to the same location as '
                          'the CA'),
                    active=False,
                    plural=False)),
            'The Reusable Config containing X.509 values for this CA.',
            flag_name_overrides={
                'location': '',
                'project': '',
            },
            group=reusable_config_group),
        presentation_specs.ResourcePresentationSpec(
            '--from-ca',
            privateca_resource_args.CreateCertificateAuthorityResourceSpec(
                'source CA'),
            'An existing CA from which to copy configuration values for the new CA. '
            'You can still override any of those values by explicitly providing '
            'the appropriate flags.',
            flag_name_overrides={'project': '--from-ca-project'},
            prefixes=True)
    ]).AddToParser(parser)
    flags.AddSubjectFlags(parser, subject_required=False)
    flags.AddPublishCaCertFlag(parser, use_update_help_text=False)
    flags.AddPublishCrlFlag(parser, use_update_help_text=False)
    flags.AddInlineReusableConfigFlags(reusable_config_group, is_ca=True)
    flags.AddValidityFlag(
        parser,
        resource_name='CA',
        default_value='P10Y',
        default_value_text='10 years')
    flags.AddCertificateAuthorityIssuancePolicyFlag(parser)
    labels_util.AddCreateLabelsFlags(parser)
    flags.AddBucketFlag(parser)

  def Run(self, args):
    new_ca, ca_ref, _ = create_utils.CreateCAFromArgs(
        args, is_subordinate=False)
    project_ref = ca_ref.Parent().Parent()
    kms_key_ref = args.CONCEPTS.kms_key_version.Parse().Parent()

    iam.CheckCreateCertificateAuthorityPermissions(project_ref, kms_key_ref)

    p4sa_email = p4sa.GetOrCreate(project_ref)
    if args.IsSpecified('bucket'):
      bucket_ref = storage.ValidateBucketForCertificateAuthority(args.bucket)
    else:
      bucket_ref = storage.CreateBucketForCertificateAuthority(ca_ref)
    p4sa.AddResourceRoleBindings(p4sa_email, kms_key_ref, bucket_ref)
    new_ca.gcsBucket = bucket_ref.bucket

    operation = self.client.projects_locations_certificateAuthorities.Create(
        self.messages
        .PrivatecaProjectsLocationsCertificateAuthoritiesCreateRequest(
            certificateAuthority=new_ca,
            certificateAuthorityId=ca_ref.Name(),
            parent=ca_ref.Parent().RelativeName(),
            requestId=request_utils.GenerateRequestId()))

    ca_response = operations.Await(operation, 'Creating Certificate Authority.')
    ca = operations.GetMessageFromResponse(ca_response,
                                           self.messages.CertificateAuthority)

    log.status.Print('Creating the initial Certificate Revocation List.')
    self.client.projects_locations_certificateAuthorities.PublishCrl(
        self.messages
        .PrivatecaProjectsLocationsCertificateAuthoritiesPublishCrlRequest(
            name=ca.name,
            publishCertificateRevocationListRequest=self.messages
            .PublishCertificateRevocationListRequest()))

    log.status.Print('Created Certificate Authority [{}].'.format(ca.name))
