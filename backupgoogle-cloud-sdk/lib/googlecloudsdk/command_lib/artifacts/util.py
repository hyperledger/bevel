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
"""Utility for forming Artifact Registry requests."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

# TODO(b/142489773) Required because of thread-safety issue with loading python
# modules in the presence of threads.
import encodings.idna  # pylint: disable=unused-import
import os
import re

from apitools.base.py import exceptions as api_exceptions
from googlecloudsdk.api_lib import artifacts
from googlecloudsdk.api_lib.artifacts import exceptions as ar_exceptions

from googlecloudsdk.command_lib.artifacts import requests as ar_requests
from googlecloudsdk.command_lib.projects import util as project_util
from googlecloudsdk.core import log
from googlecloudsdk.core import properties
from googlecloudsdk.core.console import console_io
from googlecloudsdk.core.util import parallel

_INVALID_REPO_NAME_ERROR = (
    "Names may only contain lowercase letters, numbers, and hyphens, and must "
    "begin with a letter and end with a letter or number.")

_GCR_BUCKETS = {
    "us": {
        "bucket": "us.artifacts.{}.appspot.com",
        "repository": "us.gcr.io",
        "location": "us"
    },
    "europe": {
        "bucket": "eu.artifacts.{}.appspot.com",
        "repository": "eu.gcr.io",
        "location": "europe"
    },
    "asia": {
        "bucket": "asia.artifacts.{}.appspot.com",
        "repository": "asia.gcr.io",
        "location": "asia"
    },
    "global": {
        "bucket": "artifacts.{}.appspot.com",
        "repository": "gcr.io",
        "location": "us"
    }
}

_REPO_REGEX = "^[a-z]([a-z0-9-]*[a-z0-9])?$"

_AR_SERVICE_ACCOUNT = "serviceAccount:service-{project_num}@gcp-sa-artifactregistry.iam.gserviceaccount.com"


def _GetMessagesForResource(resource_ref):
  return artifacts.Messages(resource_ref.GetCollectionInfo().api_version)


def _GetClientForResource(resource_ref):
  return artifacts.Client(resource_ref.GetCollectionInfo().api_version)


def _IsValidRepoName(repo_name):
  return re.match(_REPO_REGEX, repo_name) is not None


def GetProject(args):
  """Gets project resource from either argument flag or attribute."""
  return args.project or properties.VALUES.core.project.GetOrFail()


def GetRepo(args):
  """Gets repository resource from either argument flag or attribute."""
  return args.repository or properties.VALUES.artifacts.repository.GetOrFail()


def GetLocation(args):
  """Gets location resource from either argument flag or attribute."""
  return args.location or properties.VALUES.artifacts.location.GetOrFail()


def GetLocationList(args):
  return ar_requests.ListLocations(GetProject(args), args.page_size)


def AppendRepoDataToRequest(repo_ref, repo_args, request):
  """Adds repository data to CreateRepositoryRequest."""
  if not _IsValidRepoName(repo_ref.repositoriesId):
    raise ar_exceptions.InvalidInputValueError(_INVALID_REPO_NAME_ERROR)
  messages = _GetMessagesForResource(repo_ref)
  repo_format = messages.Repository.FormatValueValuesEnum(
      repo_args.repository_format.upper())
  if repo_format in [
      messages.Repository.FormatValueValuesEnum.MAVEN,
      messages.Repository.FormatValueValuesEnum.NPM,
  ]:
    log.status.Print("Note: Language package support is in Alpha.\n")
  if repo_format == messages.Repository.FormatValueValuesEnum.APT:
    log.status.Print("Note: APT package support is in Alpha.\n")

  repo = messages.Repository(
      name=repo_ref.RelativeName(),
      description=repo_args.description,
      format=repo_format,
      kmsKeyName=repo_args.kms_key)
  request.repository = repo
  request.repositoryId = repo_ref.repositoriesId
  return request


def CheckServiceAccountPermission(response, args):
  """Checks and grants key encrypt/decrypt permission for service account.

  Checks if Artifact Registry service account has encrypter/decrypter or owner
  role for the given key. If not, prompts users to grant key encrypter/decrypter
  permission to the service account. If users say no to the prompt, logs a
  message and points to the official documentation.

  Args:
    response: Create repository response.
    args: User input arguments.

  Returns:
    Create repository response.
  """
  if args.kms_key:
    project_num = project_util.GetProjectNumber(GetProject(args))
    service_account = _AR_SERVICE_ACCOUNT.format(project_num=project_num)

    policy = ar_requests.GetCryptoKeyPolicy(args.kms_key)
    has_permission = False
    for binding in policy.bindings:
      if service_account in binding.members and (
          binding.role == "roles/cloudkms.cryptoKeyEncrypterDecrypter" or
          binding.role == "roles/owner"):
        has_permission = True
        break
    if not has_permission:
      cont = console_io.PromptContinue(
          prompt_string=(
              "\nDo you want to grant the Artifact Registry Service Account "
              "permission to encrypt/decrypt with the selected key [{key_name}]"
              .format(key_name=args.kms_key)),
          cancel_on_no=False)
      if not cont:
        log.status.Print(
            "Note: You will need to grant the Artifact Registry Service "
            "Account permissions to encrypt/decrypt on the selected key.\n"
            "Learn more: https://cloud.google.com/artifact-registry/docs/cmek")
        return response
      ar_requests.AddCryptoKeyPermission(args.kms_key, service_account)
      log.status.Print(
          "Added Cloud KMS CryptoKey Encrypter/Decrypter Role to [{key_name}]"
          .format(key_name=args.kms_key))
  return response


def DeleteVersionTags(ver_ref, ver_args, request):
  """Deletes tags associate with the specified version."""
  if not ver_args.delete_tags:
    return request
  client = _GetClientForResource(ver_ref)
  messages = _GetMessagesForResource(ver_ref)
  tag_list = ar_requests.ListTags(client, messages,
                                  ver_ref.Parent().RelativeName())
  for tag in tag_list:
    if tag.version != ver_ref.RelativeName():
      continue
    ar_requests.DeleteTag(client, messages, tag.name)
  return request


def AppendTagDataToRequest(tag_ref, tag_args, request):
  """Adds tag data to CreateTagRequest."""
  parts = request.parent.split("/")
  pkg_path = "/".join(parts[:len(parts) - 2])
  request.parent = pkg_path
  messages = _GetMessagesForResource(tag_ref)
  tag = messages.Tag(
      name=tag_ref.RelativeName(),
      version=pkg_path + "/versions/" + tag_args.version)
  request.tag = tag
  request.tagId = tag_ref.tagsId
  return request


def SetTagUpdateMask(tag_ref, tag_args, request):
  """Sets update mask to UpdateTagRequest."""
  messages = _GetMessagesForResource(tag_ref)
  parts = request.name.split("/")
  pkg_path = "/".join(parts[:len(parts) - 2])
  tag = messages.Tag(
      name=tag_ref.RelativeName(),
      version=pkg_path + "/versions/" + tag_args.version)
  request.tag = tag
  request.updateMask = "version"
  return request


def SlashEscapePackageName(pkg_ref, unused_args, request):
  """Escapes slashes in package name for ListVersionsRequest."""
  request.parent = "{}/packages/{}".format(
      pkg_ref.Parent().RelativeName(), pkg_ref.packagesId.replace("/", "%2F"))
  return request


def SlashUnescapePackageName(response, unused_args):
  """Unescapes slashes in package name from ListPackagesResponse."""
  ret = []
  for ver in response:
    ver.name = os.path.basename(ver.name)
    ver.name = ver.name.replace("%2F", "/")
    ret.append(ver)
  return ret


def AppendParentInfoToListReposResponse(response, args):
  """Adds log to clarify parent resources for ListRepositoriesRequest."""
  log.status.Print("Listing items under project {}, location {}.\n".format(
      GetProject(args), GetLocation(args)))
  return response


def AppendParentInfoToListPackagesResponse(response, args):
  """Adds log to clarify parent resources for ListPackagesRequest."""
  log.status.Print(
      "Listing items under project {}, location {}, repository {}.\n".format(
          GetProject(args), GetLocation(args), GetRepo(args)))
  return response


def AppendParentInfoToListVersionsAndTagsResponse(response, args):
  """Adds log to clarify parent resources for ListVersions or ListTags."""
  log.status.Print(
      "Listing items under project {}, location {}, repository {}, "
      "package {}.\n".format(
          GetProject(args), GetLocation(args), GetRepo(args), args.package))
  return response


def GetGCRRepos(buckets, project):
  """Gets a list of GCR repositories given a list of GCR bucket names."""
  messages = ar_requests.GetMessages()
  repos = []

  project_id_for_bucket = project
  if ":" in project:
    domain, project_id = project.split(":")
    project_id_for_bucket = "{}.{}.a".format(project_id, domain)
  for bucket in buckets:
    try:
      ar_requests.TestStorageIAMPermission(
          bucket["bucket"].format(project_id_for_bucket), project)
      repo = messages.Repository(
          name="projects/{}/locations/{}/repositories/{}".format(
              project, bucket["location"], bucket["repository"]),
          format=messages.Repository.FormatValueValuesEnum.DOCKER)
      repos.append(repo)
    except api_exceptions.HttpNotFoundError:
      continue
  return repos


def ListRepositories(args):
  """Lists repositories in a given project.

  If no location value is specified, list repositories across all locations.

  Args:
    args: User input arguments.

  Returns:
    List of repositories.
  """
  project = GetProject(args)
  location = args.location or properties.VALUES.artifacts.location.Get()
  location_list = ar_requests.ListLocations(project)
  if location and location.lower() not in location_list and location != "all":
    raise ar_exceptions.UnsupportedLocationError(
        "{} is not a valid location. Valid locations are [{}].".format(
            location, ", ".join(location_list)))

  loc_paths = []
  if location and location != "all":
    log.status.Print("Listing items under project {}, location {}.\n".format(
        project, location))
    loc_paths.append("projects/{}/locations/{}".format(project, location))
    buckets = [_GCR_BUCKETS[location]] if location in _GCR_BUCKETS else []
  else:
    log.status.Print(
        "Listing items under project {}, across all locations.\n".format(
            project))
    loc_paths.extend([
        "projects/{}/locations/{}".format(project, loc) for loc in location_list
    ])
    buckets = _GCR_BUCKETS.values()

  pool_size = len(loc_paths) if loc_paths else 1
  pool = parallel.GetPool(pool_size)
  try:
    pool.Start()
    results = pool.Map(ar_requests.ListRepositories, loc_paths)
  except parallel.MultiError as e:
    error_set = set(err.content for err in e.errors)
    msg = "\n".join(error_set)
    raise ar_exceptions.ArtifactRegistryError(msg)
  finally:
    pool.Join()

  repos = []
  for sublist in results:
    repos.extend([repo for repo in sublist])
  repos.sort(key=lambda x: x.name.split("/")[-1])

  return repos, buckets, project


def ValidateLocation(location, project_id):
  location_list = ar_requests.ListLocations(project_id)
  if location.lower() not in location_list:
    raise ar_exceptions.UnsupportedLocationError(
        "{} is not a valid location. Valid locations are [{}].".format(
            location, ", ".join(location_list)))


def ValidateLocationHook(unused_ref, args, req):
  ValidateLocation(GetLocation(args), GetProject(args))
  return req


def AddEncryptionLogToRepositoryInfo(response, unused_args):
  """Adds encryption info log to repository info."""
  if response.kmsKeyName:
    log.status.Print("Encryption: Customer-managed key")
  else:
    log.status.Print("Encryption: Google-managed key")
  return response


def SlashUnescapePackageNameHook(ref, args, req):
  package = args.package if args.package else ref.packagesId
  if "@" in package:
    escaped_pkg_name = package.replace("/", "%2F")
    req.name = req.name.replace(package, escaped_pkg_name)
  return req
