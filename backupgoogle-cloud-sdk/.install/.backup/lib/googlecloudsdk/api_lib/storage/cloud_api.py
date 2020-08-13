# -*- coding: utf-8 -*- #
# Copyright 2020 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""API interface for interacting with cloud storage providers."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

import enum


class DownloadStrategy(enum.Enum):
  """Enum class for specifying download strategy."""
  ONE_SHOT = 'oneshot'
  RESUMABLE = 'resumable'


class FieldsScope(enum.Enum):
  """Values used to determine fields and projection values for API calls."""
  FULL = 1
  NO_ACL = 2
  SHORT = 3


class ProviderPrefix(enum.Enum):
  """Prefix strings for cloud storage provider URLs."""
  GCS = 'gs'
  S3 = 's3'


NUM_ITEMS_PER_LIST_PAGE = 1000


class RequestConfig(object):
  """Arguments object for parameters shared between cloud providers.

  Attributes:
      predefined_acl_string (str): ACL to be set on the object.
  """

  def __init__(self, predefined_acl_string=None):
    self.predefined_acl_string = predefined_acl_string


class CloudApi(object):
  """Abstract base class for interacting with cloud storage providers.

  Implementations of the Cloud API are not guaranteed to be thread-safe.
  Behavior when calling a Cloud API instance simultaneously across
  threads is undefined and doing so will likely cause errors. Therefore,
  a separate instance of the Cloud API should be instantiated per-thread.
  """

  def GetBucket(self, bucket_name, fields_scope=None):
    """Gets Bucket metadata.

    Args:
      bucket_name (str): Name of the bucket.
      fields_scope (FieldsScope): Determines the fields and projection
          parameters of API call.

    Return:
      Apitools messages bucket object.

    Raises:
      NotImplementedError: This function was not implemented by a class using
          this interface.
      ValueError: Invalid fields_scope.
    """
    raise NotImplementedError('GetBucket must be overridden.')

  def ListBuckets(self, fields_scope=None):
    """Lists bucket metadata for the given project.

    Args:
      fields_scope (FieldsScope): Determines the fields and projection
          parameters of API call.

    Yields:
      Iterator over resource_reference.BucketResource objects

    Raises:
      NotImplementedError: This function was not implemented by a class using
          this interface.
      ValueError: Invalid fields_scope.
    """
    raise NotImplementedError('ListBuckets must be overridden.')

  def ListObjects(self,
                  bucket_name,
                  prefix=None,
                  delimiter=None,
                  all_versions=None,
                  fields_scope=None):
    """Lists objects (with metadata) and prefixes in a bucket.

    Args:
      bucket_name (str): Bucket containing the objects.
      prefix (str): Prefix for directory-like behavior.
      delimiter (str): Delimiter for directory-like behavior.
      all_versions (boolean): If true, list all object versions.
      fields_scope (FieldsScope): Determines the fields and projection
          parameters of API call.

    Yields:
      Iterator over CsObjectOrPrefix wrapper class.

    Raises:
      NotImplementedError: This function was not implemented by a class using
          this interface.
      ValueError: Invalid fields_scope.
    """
    raise NotImplementedError('ListObjects must be overridden.')

  def GetObjectMetadata(self,
                        bucket_name,
                        object_name,
                        generation=None,
                        fields_scope=None):
    """Gets object metadata.

    If decryption is supported by the implementing class, this function will
    read decryption keys from configuration and appropriately retry requests to
    encrypted objects with the correct key.

    Args:
      bucket_name (str): Bucket containing the object.
      object_name (str): Object name.
      generation (long): Generation of the object to retrieve.
      fields_scope (FieldsScope): Determines the fields and projection
          parameters of API call.

    Returns:
      Apitools messages object.

    Raises:
      NotImplementedError: This function was not implemented by a class using
          this interface.
      ValueError: Invalid fields_scope.
    """
    raise NotImplementedError('GetObjectMetadata must be overridden.')

  def PatchObjectMetadata(self,
                          bucket_name,
                          object_name,
                          metadata,
                          fields_scope=None,
                          generation=None,
                          request_config=None):
    """Updates object metadata with patch semantics.

    Args:
      bucket_name (str): Bucket containing the object.
      object_name (str): Object name.
      metadata (apitools.messages.Object): Object defining metadata to be
          updated.
      fields_scope (FieldsScope): Determines the fields and projection
          parameters of API call.
      generation (long): Generation (or version) of the object to update.
      request_config (RequestConfig): Object containing general API function
          arguments. Subclasses for specific cloud providers are available.

    Returns:
      Apitools messages Object containing updated metadata.

    Raises:
      NotImplementedError: This function was not implemented by a class using
          this interface.
      ValueError: Invalid fields_scope.
    """
    raise NotImplementedError('PatchObjectMetadata must be overridden.')

  def CopyObject(self,
                 source_object_metadata,
                 destination_object_metadata,
                 source_object_generation=None,
                 progress_callback=None,
                 request_config=None):
    """Copies an object within the cloud of one provider.

    Args:
      source_object_metadata (apitools.messages.Object): Object metadata for
          source object. Must include bucket name, object name, and etag.
      destination_object_metadata (apitools.messages.Object): Object metadata
          for new object. Must include bucket and object name.
      source_object_generation (long): Generation of the source object to copy.
      progress_callback (function): Optional callback function for progress
          notifications. Receives calls with arguments (bytes_transferred,
          total_size).
      request_config (RequestConfig): Object containing general API function
          arguments. Subclasses for specific cloud providers are available.

    Returns:
      Apitools messages object for newly created destination object.

    Raises:
      NotImplementedError: This function was not implemented by a class using
          this interface.
    """
    raise NotImplementedError('CopyObject must be overridden')

  def DownloadObject(self,
                     bucket_name,
                     object_name,
                     download_stream,
                     compressed_encoding=False,
                     decryption_wrapper=None,
                     digesters=None,
                     download_strategy=DownloadStrategy.ONE_SHOT,
                     generation=None,
                     object_size=None,
                     progress_callback=None,
                     serialization_data=None,
                     start_byte=0,
                     end_byte=None):
    """Gets object data.

    Args:
      bucket_name (str): Bucket containing the object.
      object_name (str): Object name.
      download_stream (stream): Stream to send the object data to.
      compressed_encoding (bool): If true, object is stored with a compressed
          encoding.
      decryption_wrapper (CryptoKeyWrapper):
          utils.encryption_helper.CryptoKeyWrapper that can optionally be added
          to decrypt an encrypted object.
      digesters (dict): Dict of {string : digester}, where string is the name of
          a hash algorithm, and digester is a validation digester object that
          update(bytes) and digest() using that algorithm. Implementation can
          set the digester value to None to indicate supports bytes were not
          successfully digested on-the-fly.
      download_strategy (DownloadStrategy): Cloud API download strategy to use
          for download.
      generation (long): Generation of the object to retrieve.
      object_size (int): Total size of the object being downloaded.
      progress_callback (function): Optional callback function for progress
          notifications. Receives calls with arguments
          (bytes_transferred, total_size).
      serialization_data (str): Implementation-specific JSON string of a dict
          containing serialization information for the download.
      start_byte (int): Starting point for download (for resumable downloads and
          range requests). Can be set to negative to request a range of bytes
          (python equivalent of [:-3]).
      end_byte (int): Ending byte number, inclusive, for download (for range
          requests). If None, download the rest of the object.

    Returns:
      Content-encoding string if it was detected that the server sent an encoded
      object during transfer. Otherwise, None.

    Raises:
      NotImplementedError: This function was not implemented by a class using
          this interface.
    """
    raise NotImplementedError('UploadObject must be overridden.')

  def UploadObject(self,
                   upload_stream,
                   object_metadata,
                   progress_callback=None,
                   request_config=None):
    """Uploads object data and metadata.

    Args:
      upload_stream (stream): Seekable stream of object data.
      object_metadata (apitools.messages.Object): Object containing the correct
          metadata to upload. Exact class depends on API being used.
      progress_callback (function): Callback function for progress
          notifications. Receives calls with arguments (bytes_transferred,
          total_size).
      request_config (RequestConfig): Object containing general API function
          arguments. Subclasses for specific cloud providers are available.

    Returns:
      Apitools messages object for newly created destination object.

    Raises:
      NotImplementedError: This function was not implemented by a class using
          this interface.
    """
    raise NotImplementedError('UploadObject must be overridden.')
