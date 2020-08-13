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

"""File and Cloud URL representation classes."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

import abc

from googlecloudsdk.api_lib.storage import cloud_api
from googlecloudsdk.core import exceptions as core_exceptions
import six


VALID_CLOUD_SCHEMES = frozenset({
    provider.value for provider in cloud_api.ProviderPrefix})


class InvalidUrlError(core_exceptions.Error):
  """Error raised when the url string is not in the expected format."""


class StorageUrl(six.with_metaclass(abc.ABCMeta)):
  """Abstract base class for file and Cloud Storage URLs."""

  def __eq__(self, other):
    return isinstance(other, StorageUrl) and self.url_string == other.url_string

  def __hash__(self):
    return hash(self.url_string)


class CloudUrl(StorageUrl):
  """Cloud URL class providing parsing and convenience methods.

    This class assists with usage and manipulation of an
    (optionally wildcarded) cloud URL string.  Depending on the string
    contents, this class represents a provider, bucket(s), or object(s).

    This class operates only on strings.  No cloud storage API calls are
    made from this class.
  """
  CLOUD_URL_DELIM = '/'

  def __init__(self, scheme, bucket_name=None, object_name=None,
               generation=None):
    self.scheme = scheme if scheme else None
    self.bucket_name = bucket_name if bucket_name else None
    self.object_name = object_name if object_name else None
    self.generation = generation if generation else None
    self._validate_scheme()
    self._validate_object_name()

  @classmethod
  def from_url_string(cls, url_string):
    """Parse the url string and return the storage url object.

    Args:
      url_string (str): Cloud storage url of the form gs://bucket/object

    Returns:
      CloudUrl object

    Raises:
      InvalidUrlError: Raised if the url_string is not a valid cloud url.
    """
    scheme = _get_scheme_from_url_string(url_string)

    # gs://a/b/c/d#num => a/b/c/d#num
    url_string = url_string[len(scheme + '://'):]

    # a/b/c/d#num => a, b/c/d#num
    bucket_name, _, object_name = url_string.partition(cls.CLOUD_URL_DELIM)

    # b/c/d#num => b/c/d, num
    object_name, _, generation = object_name.partition('#')

    return cls(scheme, bucket_name, object_name, generation)

  def _validate_scheme(self):
    if self.scheme not in VALID_CLOUD_SCHEMES:
      raise InvalidUrlError('Unrecognized scheme "%s"' % self.scheme)

  def _validate_object_name(self):
    if self.object_name == '.' or self.object_name == '..':
      raise InvalidUrlError('%s is an invalid root-level object name' %
                            self.object_name)

  @property
  def url_string(self):
    url_str = self.versionless_url_string
    if self.generation:
      url_str += '#%s' % self.generation
    return url_str

  @property
  def versionless_url_string(self):
    if self.is_provider():
      return '%s://' % self.scheme
    elif self.is_bucket():
      return '%s://%s' % (self.scheme, self.bucket_name)
    return '%s://%s/%s' % (self.scheme, self.bucket_name, self.object_name)

  def is_bucket(self):
    return bool(self.bucket_name and not self.object_name)

  def is_object(self):
    return bool(self.bucket_name and self.object_name)

  def is_provider(self):
    return bool(self.scheme and not self.bucket_name)

  def __str__(self):
    return self.url_string


def _get_scheme_from_url_string(url_str):
  """Returns scheme component of a URL string."""
  end_scheme_idx = url_str.find('://')
  if end_scheme_idx == -1:
    # File is the default scheme.
    return 'file'
  else:
    return url_str[0:end_scheme_idx].lower()


def storage_url_from_string(url_str):
  """Static factory function for creating a StorageUrl from a string.

  Args:
    url_str (str): Cloud url or local filepath.

  Returns:
     StorageUrl object.

  Raises:
    InvalidUrlError if url string is invalid.
  """

  scheme = _get_scheme_from_url_string(url_str)
  if scheme == 'file':
    # TODO(b/160593328) Add support for file scheme
    return None
  return CloudUrl.from_url_string(url_str)
