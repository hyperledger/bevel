# -*- coding: utf-8 -*- #
# Copyright 2015 Google LLC. All Rights Reserved.
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

"""Cloud SDK markdown document HTML renderer."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

import re

from googlecloudsdk.core.document_renderers import devsite_scripts
from googlecloudsdk.core.document_renderers import html_renderer


class DevSiteRenderer(html_renderer.HTMLRenderer):
  """Renders markdown to DevSiteHTML.

  Devsite-Specific Attributes:
  _opentag: True if <code> tag on Example command is not closed, False otherwise
  """

  def __init__(self, *args, **kwargs):
    super(DevSiteRenderer, self).__init__(*args, **kwargs)
    self._opentag = False

  def _Title(self):
    """Renders an HTML document title."""
    self._out.write(
        '<html devsite="">\n'
        '<head>\n')
    if self._title:
      self._out.write(
          '<title>' + self._title + '</title>\n')
    self._out.write(
        '<meta http-equiv="Content-Type" content="text/html; '
        'charset=UTF-8">\n'
        '<meta name="project_path" value="/sdk/docs/_project.yaml">\n'
        '<meta name="book_path" value="/sdk/_book.yaml">\n')
    for comment, script in devsite_scripts.SCRIPTS:
      self._out.write('<!-- {comment} -->\n{script}\n'.format(comment=comment,
                                                              script=script))

  def _Heading(self, unused_level, heading):
    """Renders a DevSite heading.

    Args:
      unused_level: The heading level counting from 1.
      heading: The heading text.
    """
    self._heading = '</dd>\n</section>\n'
    self._out.write('\n<section id="{document_id}">\n'
                    '<dt>{heading}</dt>\n<dd class="sectionbody">\n'.format(
                        document_id=self.GetDocumentID(heading),
                        heading=heading))

  def _Flush(self):
    """Flushes the current collection of Fill() lines."""
    if self._example and self._lang is not None:
      self._out.write('\n')
      return
    self._paragraph = False
    if self._fill:
      self._section = False
      if self._example:
        self._example = False
        self._out.write('</pre>\n')
      self._fill = 0
      self._out.write('\n')
      self._blank = False

  def Example(self, line):
    """Displays line as an indented example.

    Args:
      line: The example line.
    """
    self._blank = True
    if not self._example:
      self._example = True
      self._fill = 2
      if not self._lang:
        self._out.write('<pre class="prettyprint lang-sh">\n')
      elif self._lang in ('pretty', 'yaml'):
        self._out.write('<pre class="prettyprint lang-sh">\n')
      else:
        self._out.write('<pre class="prettyprint lang-{lang}">\n'.format(
            lang=self._lang))
    indent = len(line)
    line = line.lstrip()
    indent -= len(line)
    terminal_pattern = re.compile(r'\A\$\s+')
    last_char = line[-1:]
    last_char_is_backslash = last_char == '\\'
    if last_char_is_backslash:  # get backslashes out of multiline commands
      line = line[:-1]
    if terminal_pattern.match(line):  # if start of command in line open tag
      self._out.write('<code class="devsite-terminal">')
      self._opentag = True
      self._out.write(terminal_pattern.sub('', line))
    else:
      if not self._opentag:
        self._out.write(' ' * (self._fill + indent))  # indent non-commands
      self._out.write(line)
    if not last_char_is_backslash:  # if end of command in line close tag
      if self._opentag:
        self._out.write('</code>')
        self._opentag = False
      self._out.write('\n')  # if last char is backslash don't newline

  def Link(self, target, text):
    """Renders an anchor.

    Args:
      target: The link target URL.
      text: The text to be displayed instead of the link.

    Returns:
      The rendered link anchor and text.
    """
    if target != self.command[0] and (
        '/' not in target or ':' in target or '#' in target or
        target.startswith('www.') or target.endswith('/..')):
      return '<a href="{target}">{text}</a>'.format(target=target,
                                                    text=text or target)

    # Massage the target href to match the DevSite layout.
    target_parts = target.split('/')
    if target_parts[-1] == 'help':
      target_parts.pop()
    if len(target_parts) > 1 and target_parts[1] == 'meta':
      return target + ' --help'
    return '<a href="/sdk/{head}/{tail}">{text}</a>'.format(
        head=target_parts[0], tail='/'.join(['reference'] + target_parts[1:]),
        text=text or target)

  def LinkGlobalFlags(self, line):
    """Add global flags links to line if any.

    Args:
      line: The text line.

    Returns:
      line with annoted global flag links.
    """
    return re.sub(
        r'(--[-a-z]+)',
        r'<a href="/sdk/{}/reference/#\1">\1</a>'.format(self.command[0]),
        line)
