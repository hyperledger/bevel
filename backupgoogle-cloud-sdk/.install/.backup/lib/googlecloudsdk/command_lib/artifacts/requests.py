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
"""Utility for making API calls."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

from googlecloudsdk.api_lib.artifacts import exceptions as ar_exceptions
from googlecloudsdk.api_lib.cloudkms import iam as kms_iam
from googlecloudsdk.api_lib.util import apis
from googlecloudsdk.core import resources

ARTIFACTREGISTRY_API_NAME = "artifactregistry"
ARTIFACTREGISTRY_API_VERSION = "v1beta1"

STORAGE_API_NAME = "storage"
STORAGE_API_VERSION = "v1"

_GCR_PERMISSION = "storage.objects.list"

CRYPTO_KEY_COLLECTION = "cloudkms.projects.locations.keyRings.cryptoKeys"


def GetStorageClient():
  return apis.GetClientInstance(STORAGE_API_NAME, STORAGE_API_VERSION)


def GetStorageMessages():
  return apis.GetMessagesModule(STORAGE_API_NAME, STORAGE_API_VERSION)


def GetClient():
  return apis.GetClientInstance(ARTIFACTREGISTRY_API_NAME,
                                ARTIFACTREGISTRY_API_VERSION)


def GetMessages():
  return apis.GetMessagesModule(ARTIFACTREGISTRY_API_NAME,
                                ARTIFACTREGISTRY_API_VERSION)


def DeleteTag(client, messages, tag):
  """Deletes a tag by its name."""
  delete_tag_req = messages.ArtifactregistryProjectsLocationsRepositoriesPackagesTagsDeleteRequest(
      name=tag)
  err = client.projects_locations_repositories_packages_tags.Delete(
      delete_tag_req)
  if not isinstance(err, messages.Empty):
    raise ar_exceptions.ArtifactRegistryError(
        "Failed to delete tag {}: {}".format(tag, err))


def CreateDockerTag(client, messages, docker_tag, docker_version):
  """Creates a tag associated with the given docker version."""
  tag = messages.Tag(
      name=docker_tag.GetTagName(), version=docker_version.GetVersionName())
  create_tag_req = messages.ArtifactregistryProjectsLocationsRepositoriesPackagesTagsCreateRequest(
      parent=docker_tag.GetPackageName(), tag=tag, tagId=docker_tag.tag)
  return client.projects_locations_repositories_packages_tags.Create(
      create_tag_req)


def GetTag(client, messages, tag):
  """Gets a tag by its name."""
  get_tag_req = messages.ArtifactregistryProjectsLocationsRepositoriesPackagesTagsGetRequest(
      name=tag)
  return client.projects_locations_repositories_packages_tags.Get(get_tag_req)


def DeleteVersion(client, messages, version):
  """Deletes a version by its name."""
  delete_ver_req = messages.ArtifactregistryProjectsLocationsRepositoriesPackagesVersionsDeleteRequest(
      name=version)
  return client.projects_locations_repositories_packages_versions.Delete(
      delete_ver_req)


def DeletePackage(client, messages, package):
  """Deletes a package by its name."""
  delete_pkg_req = messages.ArtifactregistryProjectsLocationsRepositoriesPackagesDeleteRequest(
      name=package)
  return client.projects_locations_repositories_packages.Delete(delete_pkg_req)


def GetVersionFromTag(client, messages, tag):
  """Gets a version name by a tag name."""
  get_tag_req = messages.ArtifactregistryProjectsLocationsRepositoriesPackagesTagsGetRequest(
      name=tag)
  get_tag_res = client.projects_locations_repositories_packages_tags.Get(
      get_tag_req)
  if not get_tag_res.version or len(get_tag_res.version.split("/")) != 10:
    raise ar_exceptions.ArtifactRegistryError(
        "Internal error. Corrupted tag: {}".format(tag))
  return get_tag_res.version.split("/")[-1]


def ListTags(client,
             messages,
             package,
             page_size=None,
             page_token=None,
             res=None):
  """Lists all tags under a package with the given package name."""
  if not res:
    res = []
  list_tags_req = messages.ArtifactregistryProjectsLocationsRepositoriesPackagesTagsListRequest(
      parent=package, pageSize=page_size, pageToken=page_token)
  list_tags_res = client.projects_locations_repositories_packages_tags.List(
      list_tags_req)
  res.extend(list_tags_res.tags)
  if list_tags_res.nextPageToken:
    ListTags(client, messages, package, page_size, list_tags_res.nextPageToken,
             res)
  return res


def ListVersionTags(client, messages, package, version):
  """Lists tags associated with the given version."""
  list_tags_req = messages.ArtifactregistryProjectsLocationsRepositoriesPackagesTagsListRequest(
      parent=package, filter="version=\"{}\"".format(version))
  list_tags_res = client.projects_locations_repositories_packages_tags.List(
      list_tags_req)
  return list_tags_res.tags


def ListPackages(client, messages, repo):
  """Lists all packages under a repository."""
  list_pkgs_req = messages.ArtifactregistryProjectsLocationsRepositoriesPackagesListRequest(
      parent=repo)
  list_pkgs_res = client.projects_locations_repositories_packages.List(
      list_pkgs_req)
  return list_pkgs_res.packages


def ListVersions(client,
                 messages,
                 pkg,
                 version_view,
                 page_size=None,
                 page_token=None,
                 res=None):
  """Lists all versions under a package."""
  if not res:
    res = []
  list_vers_req = messages.ArtifactregistryProjectsLocationsRepositoriesPackagesVersionsListRequest(
      parent=pkg, view=version_view, pageSize=page_size, pageToken=page_token)
  list_vers_res = client.projects_locations_repositories_packages_versions.List(
      list_vers_req)
  res.extend(list_vers_res.versions)
  if list_vers_res.nextPageToken:
    ListVersions(client, messages, pkg, version_view, page_size,
                 list_vers_res.nextPageToken, res)
  return res


def ListRepositories(project):
  """Lists all repositories under a project."""
  client = GetClient()
  messages = GetMessages()
  list_repos_req = messages.ArtifactregistryProjectsLocationsRepositoriesListRequest(
      parent=project)
  list_repos_res = client.projects_locations_repositories.List(list_repos_req)
  return list_repos_res.repositories


def GetRepository(repo):
  """Gets the repository given its name."""
  client = GetClient()
  messages = GetMessages()
  get_repo_req = messages.ArtifactregistryProjectsLocationsRepositoriesGetRequest(
      name=repo)
  get_repo_res = client.projects_locations_repositories.Get(get_repo_req)
  return get_repo_res


def ListLocations(project_id, page_size=None, page_token=None, res=None):
  """Lists all locations for a given project."""
  if not res:
    res = []
  client = GetClient()
  messages = GetMessages()
  list_locs_req = messages.ArtifactregistryProjectsLocationsListRequest(
      name="projects/" + project_id, pageSize=page_size, pageToken=page_token)
  list_locs_res = client.projects_locations.List(list_locs_req)
  res.extend(list_locs_res.locations)
  if list_locs_res.nextPageToken:
    ListLocations(project_id, page_size, list_locs_res.nextPageToken, res)
  return sorted([loc.locationId for loc in res])


def TestStorageIAMPermission(bucket, project):
  """Tests storage IAM permission for a given bucket for the user project."""
  client = GetStorageClient()
  messages = GetStorageMessages()
  test_req = messages.StorageBucketsTestIamPermissionsRequest(
      bucket=bucket, permissions=_GCR_PERMISSION, userProject=project)
  return client.buckets.TestIamPermissions(test_req)


def GetCryptoKeyPolicy(kms_key):
  """Gets the IAM policy for a given crypto key."""
  crypto_key_ref = resources.REGISTRY.ParseRelativeName(
      relative_name=kms_key, collection=CRYPTO_KEY_COLLECTION)
  return kms_iam.GetCryptoKeyIamPolicy(crypto_key_ref)


def AddCryptoKeyPermission(kms_key, service_account):
  """Adds Encrypter/Decrypter role to the given service account."""
  crypto_key_ref = resources.REGISTRY.ParseRelativeName(
      relative_name=kms_key, collection=CRYPTO_KEY_COLLECTION)
  return kms_iam.AddPolicyBindingToCryptoKey(
      crypto_key_ref, service_account,
      "roles/cloudkms.cryptoKeyEncrypterDecrypter")
