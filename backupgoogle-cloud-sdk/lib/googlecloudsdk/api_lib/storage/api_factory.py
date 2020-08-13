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
"""Returns correct API client instance for user command."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

import threading

from googlecloudsdk.api_lib.storage import cloud_api
from googlecloudsdk.api_lib.storage import gcs_api


# Module variable for holding one API instance per thread per provider.
_cloud_api_thread_local_storage = threading.local()


def get_api(provider):
  """Returns thread local API instance for cloud provider.

  Uses thread local storage to make sure only one instance of an API exists
  per thread per provider.

  Args:
    provider (ProviderPrefix): Cloud provider prefix.

  Returns:
    API for cloud provider or None if unrecognized provider.

  Raises:
    ValueError: Invalid API provider.
  """
  if getattr(_cloud_api_thread_local_storage, provider.value, None) is None:
    if provider == cloud_api.ProviderPrefix.GCS:
      # TODO(b/159164504): Update with implemented GCS API.
      _cloud_api_thread_local_storage.gs = gcs_api.GcsApi()
    elif provider == cloud_api.ProviderPrefix.S3:
      # TODO(b/159164385): Update with implemented S3 API.
      _cloud_api_thread_local_storage.s3 = None
    else:
      raise ValueError('Provider API value must be "gs" or "s3".')
  return getattr(_cloud_api_thread_local_storage, provider.value)
