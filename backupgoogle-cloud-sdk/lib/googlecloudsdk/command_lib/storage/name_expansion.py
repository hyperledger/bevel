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
"""Name expansion iterator."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

from googlecloudsdk.command_lib.storage import wildcard_iterator


class NameExpansionIterator:
  """Expand all urls passed as arguments, and yield each expanded url."""

  def __init__(self, url_strs):
    """Instantiate NameExpansionIterator.

    Args:
      url_strs (List[str]): list of urls to expand.
    """
    self._url_strs = url_strs

  def __iter__(self):
    """Iterate over each URL in self._url_strs and yield each matching resource.

    Yields:
      resource_reference.Resource
    """
    for url_str in self._url_strs:
      # TODO(b/160593328) Add support for file scheme
      wildcard_expanded_urls = wildcard_iterator.CloudWildcardIterator(url_str)
      for url in wildcard_expanded_urls:
        yield url
