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
"""Implementation of Unix-like cp command for cloud storage providers."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

from googlecloudsdk.calliope import base
from googlecloudsdk.command_lib.storage import copying
from googlecloudsdk.command_lib.storage import paths
from googlecloudsdk.command_lib.storage import storage_parallel
from googlecloudsdk.core import log


class Cp(base.Command):
  """Upload, download, and copy Cloud Storage objects."""

  detailed_help = {
      'DESCRIPTION':
          """
      Copy data between your local file system and the cloud, copy data within
      the cloud, and copy data between cloud storage providers.
      """,
      'EXAMPLES':
          """

      To upload all text files from the local directory to a bucket:

        $ *{command}* *.txt gs://my-bucket

      Similarly, you can download text files from a bucket:

        $ *{command}* gs://my-bucket/*.txt .

      If you want to copy an entire directory tree you need to use the -r
      option. For example, to upload the directory tree "dir":

        $ *{command}* -r dir gs://my-bucket
      """,
      # TODO(b/160602071) Expand examples as features are added.
  }

  @staticmethod
  # TODO(b/160602071) Add arguments as features are added.
  def Args(parser):
    parser.add_argument('source', nargs='+', help='The source path(s) to copy.')
    parser.add_argument('destination', help='The destination path.')

  def Run(self, args):
    # TODO(b/160602071) Replace with new utils rather than legacy copy command.
    sources = [paths.Path(p) for p in args.source]
    dest = paths.Path(args.destination)
    copier = copying.CopyTaskGenerator()
    tasks = copier.GetCopyTasks(sources, dest, recursive=False)
    storage_parallel.ExecuteTasks(
        tasks, num_threads=1, progress_bar_label='Copying Files')
    log.status.write('Copied [{}] file{}.\n'.format(
        len(tasks), 's' if len(tasks) > 1 else ''))
