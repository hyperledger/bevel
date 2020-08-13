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
"""Utilities for handling Compute ZoneInPlaceSnapshotService and RegionInPlaceSnapshotService."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

import abc
from googlecloudsdk.core.exceptions import Error
import six


class UnknownResourceError(Error):
  """Raised when a in-place snapshot resource argument is neither regional nor zonal."""


class _InPlaceSnapshot(six.with_metaclass(abc.ABCMeta, object)):
  """Common class for InPlaceSnapshot Service API client."""

  def GetService(self):
    return self._service

  def GetInPlaceSnapshotResource(self):
    request_msg = self.GetInPlaceSnapshotRequestMessage()
    return self._service.Get(request_msg)

  @abc.abstractmethod
  def GetInPlaceSnapshotRequestMessage(self):
    raise NotImplementedError

  @abc.abstractmethod
  def GetSetLabelsRequestMessage(self):
    raise NotImplementedError

  @abc.abstractmethod
  def GetSetInPlaceSnapshotLabelsRequestMessage(self):
    raise NotImplementedError


class _ZoneInPlaceSnapshot(_InPlaceSnapshot):
  """A wrapper for Compute Engine ZoneInPlaceSnapshotService API client."""

  def __init__(self, client, ips_ref, messages):
    self._ips_ref = ips_ref
    self._client = client
    self._service = client.zoneInPlaceSnapshots
    self._messages = messages

  @classmethod
  def GetOperationCollection(cls):
    return 'compute.zoneOperations'

  def GetInPlaceSnapshotRequestMessage(self):
    return self._messages.ComputeZoneInPlaceSnapshotsGetRequest(
        **self._ips_ref.AsDict())

  def GetSetLabelsRequestMessage(self):
    return self._messages.ZoneSetLabelsRequest

  def GetSetInPlaceSnapshotLabelsRequestMessage(self, ips, labels):
    req = self._messages.ComputeZoneInPlaceSnapshotsSetLabelsRequest
    return req(
        project=self._ips_ref.project,
        resource=self._ips_ref.inPlaceSnapshot,
        zone=self._ips_ref.zone,
        zoneSetLabelsRequest=self._messages.ZoneSetLabelsRequest(
            labelFingerprint=ips.labelFingerprint, labels=labels))


class _RegionInPlaceSnapshot(_InPlaceSnapshot):
  """A wrapper for Compute Engine RegionInPlaceSnapshotService API client."""

  def __init__(self, client, ips_ref, messages):
    self._ips_ref = ips_ref
    self._client = client
    self._service = client.regionInPlaceSnapshots
    self._messages = messages

  @classmethod
  def GetOperationCollection(cls):
    return 'compute.regionOperations'

  def GetInPlaceSnapshotRequestMessage(self):
    return self._messages.ComputeRegionInPlaceSnapshotsGetRequest(
        **self._ips_ref.AsDict())

  def GetSetLabelsRequestMessage(self):
    return self._messages.RegionSetLabelsRequest

  def GetSetInPlaceSnapshotLabelsRequestMessage(self, ips, labels):
    req = self._messages.ComputeRegionInPlaceSnapshotsSetLabelsRequest
    return req(
        project=self._ips_ref.project,
        resource=self._ips_ref.inPlaceSnapshot,
        region=self._ips_ref.region,
        regionSetLabelsRequest=self._messages.RegionSetLabelsRequest(
            labelFingerprint=ips.labelFingerprint, labels=labels))


def IsZonal(ips_ref):
  """Checks if a compute in-place snapshot is zonal or regional.

  Args:
    ips_ref: the in-place snapshot resource reference that is parsed from
      resource arguments to modify.

  Returns:
    Boolean, true when the compute in-place snapshot resource to modify is a
    zonal compute in-place snapshot resource, false when a regional compute
    in-place snapshot resource.

  Raises:
    UnknownResourceError: when the compute in-place snapshot resource is not in
    the
      correct format.
  """
  # There are 2 types of in-place snapshot services,
  # ZoneInPlaceSnapshotService (by zone) and
  # RegionInPlaceSnapshotService (by region).
  if ips_ref.Collection() == 'compute.zoneInPlaceSnapshots':
    return True
  elif ips_ref.Collection() == 'compute.regionInPlaceSnapshots':
    return False
  else:
    raise UnknownResourceError(
        'Unexpected in-place snapshot resource argument of {}'.format(
            ips_ref.Collection()))


def GetInPlaceSnapshotInfo(ips_ref, client, messages):
  """Gets the zonal or regional in-place snapshot api info.

  Args:
    ips_ref: the in-place snapshot resource reference that is parsed from
      resource arguments.
    client: the compute api_tools_client.
    messages: the compute message module.

  Returns:
    _ZoneInPlaceSnapshot or _RegionInPlaceSnapshot.
  """
  if IsZonal(ips_ref):
    return _ZoneInPlaceSnapshot(client, ips_ref, messages)
  else:
    return _RegionInPlaceSnapshot(client, ips_ref, messages)
