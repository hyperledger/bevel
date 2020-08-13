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
"""Functions for reading the skaffold events stream."""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import contextlib
import datetime
import json
import os
import threading

from googlecloudsdk.core import log
from googlecloudsdk.core.console import console_attr
import six


class StopThreadError(BaseException):
  """The thread has been stopped by a ThreadEvent."""


class PrintUrlThreadContext(object):
  """Context manager that starts a thread that prints outs local urls.

  When entering the context, start a thread that watches the skaffold events
  stream api, find the portForward events, and prints out the local urls
  for a service. This will continue until the context is exited.
  """

  def __init__(self, service_name, events_port):
    """Initialize PrintUrlThreadContext.

    Args:
      service_name: Name of the service.
      events_port: Port number of the skaffold events stream api.
    """
    self._stop = threading.Event()
    self._thread = threading.Thread(
        target=_PrintUrl, args=(service_name, events_port, self._stop))

  def __enter__(self):
    self._thread.start()

  def __exit__(self, *args):
    self._stop.set()


def _PrintUrl(service_name, events_port, stop):
  """Read the local url of a service from the event stream and print it.

  Read the event stream api and find the portForward events. Print the local
  url as determined from the portFoward events. This function will continuously
  listen to the event stream and print out all local urls until eitherthe event
  stream connection closes or the stop event is set.

  Args:
    service_name: Name of the service.
    events_port: Port number of the skaffold events stream api.
    stop: threading.Event event.
  """
  try:
    with contextlib.closing(_OpenEventStreamRetry(events_port,
                                                  stop)) as response:
      for port in GetServiceLocalPort(response, service_name):
        # If the thread has been signaled to stop, don't print out the url
        if stop.is_set():
          return
        con = console_attr.GetConsoleAttr()
        msg = 'Service available at {bold}{url}{normal}'.format(
            bold=con.GetFontCode(bold=True),
            url='http://localhost:%s/' % port,
            normal=con.GetFontCode())
        # Sleep for a second to make sure the URL is printed below the start
        # up logs printed by skaffold.'
        stop.wait(1)
        log.status.Print(con.Colorize(msg, color='blue'))
  except StopThreadError:
    return


def OpenEventsStream(events_port):
  """Open a connection to the skaffold events api output."""
  return six.moves.urllib.request.urlopen(_GetEventsUrl(events_port))


def GetServiceLocalPort(response, service_name):
  """Get the local port for a service.

  This function yields the new local port every time a new port forwarding
  connection is created.

  Args:
    response: urlopen response.
    service_name: Name of the service.

  Yields:
    Local port number.
  """
  for event in ReadEventStream(response):
    if _IsPortEventForService(event, service_name):
      yield event['portEvent']['localPort']


def ReadEventStream(response):
  """Read the events from the skaffold event stream.

  Args:
    response: urlopen response.

  Yields:
    Events from the JSON payloads.
  """
  for line in _ReadStreamingLines(response):
    try:
      payload = json.loads(line)
    except ValueError:
      # Some of the output will not be json. We don't care about those
      # lines. Ignore the line if the line is invalid json.
      continue
    if not isinstance(payload, dict):
      continue
    event = payload['result']['event']
    yield event


def _OpenEventStreamRetry(events_port,
                          stop_event,
                          retry_interval=datetime.timedelta(seconds=1)):
  """Open a connection to the skaffold events api output.

  This function retries opening the connection until opening is succesful or
  stop_event is set.

  Args:
    events_port: Port of the events api.
    stop_event: A threading.Event object.
    retry_interval: Interval for which to sleep between tries.

  Returns:
    urlopen response.
  Raises:
    StopThreadError: The stop_event was set before a connection was established.
  """
  while not stop_event.is_set():
    try:
      return OpenEventsStream(events_port)
    except six.moves.urllib.error.URLError:
      stop_event.wait(retry_interval.total_seconds())
  raise StopThreadError()


def _GetEventsUrl(events_port):
  return 'http://localhost:{events_port}/v1/events'.format(
      events_port=six.text_type(events_port))


def _IsPortEventForService(event, service_name):
  return event.get('portEvent', {}).get('resourceName') == service_name


def _ReadStreamingLines(response, chunk_size_bytes=50):
  """Read lines from a urlopen response.

  The standard http response readline waits until either the buffer is full
  or the connection closes. The connection to read the event stream
  stays open forever until the client closes it. As a result, we can get
  into a state where http readline() never returns because the buffer
  is not full but the server is waiting for the test to do something
  to generate more events.
  This function will not block a buffer not being full. os.read() will
  return data of any size if a response is received. This allows the test
  to make progress.

  Args:
    response: urlopen response.
    chunk_size_bytes: Size of the chunk to read.

  Yields:
    Lines as read from the response.
  """
  pending = None

  while True:
    chunk = six.ensure_text(os.read(response.fp.fileno(), chunk_size_bytes))
    if not chunk:
      break

    if pending is not None:
      chunk = pending + chunk
      pending = None

    lines = chunk.split('\n')
    if lines and lines[-1]:
      pending = lines.pop()

    for line in lines:
      yield line

  if pending:
    yield pending
