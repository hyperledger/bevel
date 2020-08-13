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
"""Anthos command library functions and utilities for the anthoscli binary."""
from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

import base64
import copy
import json
import os

from googlecloudsdk.command_lib.anthos.common import file_parsers
from googlecloudsdk.command_lib.anthos.common import messages
from googlecloudsdk.command_lib.util.anthos import binary_operations
from googlecloudsdk.core import exceptions as c_except
from googlecloudsdk.core import log
from googlecloudsdk.core.console import console_io
from googlecloudsdk.core.credentials import store as c_store
from googlecloudsdk.core.util import files
from googlecloudsdk.core.util import platforms

import six

DEFAULT_ENV_ARGS = {'COBRA_SILENCE_USAGE': 'true'}

DEFAULT_LOGIN_CONFIG_PATH = {
    platforms.OperatingSystem.LINUX.id:
        '~/.config/google/anthos/kubectl-anthos-config.yaml',
    platforms.OperatingSystem.MACOSX.id:
        '~/Library/Preferences/google/anthos/kubectl-anthos-config.yaml',
    platforms.OperatingSystem.WINDOWS.id: os.path.join(
        '%APPDATA%', 'google', 'anthos', 'kubectl-anthos-config.yaml')
}


def GetEnvArgsForCommand(extra_vars=None, exclude_vars=None):
  """Return an env dict to be passed on command invocation."""
  env = copy.deepcopy(os.environ)
  env.update(DEFAULT_ENV_ARGS)
  if extra_vars:
    env.update(extra_vars)
  if exclude_vars:
    for k in exclude_vars:
      env.pop(k)
  return  env


class AnthosAuthException(c_except.Error):
  """Base Exception for auth issues raised by gcloud anthos surface."""


def RelativePkgPathFromFullPath(path):
  """Splits full path into relative(basename) path and parent dir."""
  normpath = os.path.normpath(path)
  rel_path = os.path.basename(normpath)
  parent_dir = os.path.dirname(normpath) or rel_path
  return  rel_path, parent_dir


class AnthosCliWrapper(binary_operations.StreamingBinaryBackedOperation):
  """Binary operation wrapper for anthoscli commands."""

  def __init__(self, **kwargs):
    custom_errors = {
        'MISSING_EXEC': messages.MISSING_BINARY.format(binary='anthoscli')
    }
    super(AnthosCliWrapper, self).__init__(binary='anthoscli',
                                           custom_errors=custom_errors,
                                           **kwargs)

  def _ParseGetArgs(self, repo_uri, local_dest, file_pattern=None, **kwargs):
    del kwargs  # Not Used Here
    exec_args = ['get', repo_uri, local_dest]

    if file_pattern:
      exec_args.extend(['--pattern', file_pattern])

    return exec_args

  def _ParseUpdateArgs(self, local_dir, repo_uri=None, strategy=None,
                       dry_run=False, verbose=False, **kwargs):
    del kwargs  # Not Used here

    exec_args = ['update', local_dir]
    if repo_uri:
      exec_args.extend(['--repo', repo_uri])

    if dry_run:
      exec_args.append('--dry-run')

    if strategy:
      exec_args.extend(['--strategy', strategy])

    if verbose:
      exec_args.append('--verbose')

    return  exec_args

  def _ParseDescribeArgs(self, local_dir, **kwargs):
    del kwargs  # Not Used here
    return  ['desc', local_dir]

  def _ParseTags(self, tags):
    return ','.join(['{}={}'.format(x, y) for x, y in six.iteritems(tags)])

  def _ParseInitArgs(self, local_dir, description=None, name=None,
                     tags=None, info_url=None, **kwargs):
    del kwargs  # Not Used here
    package_path = local_dir

    if not package_path.endswith('/'):
      package_path += '/'
    exec_args = ['init', package_path]

    if description:
      exec_args.extend(['--description', description])
    if name:
      exec_args.extend(['--name', name])
    if tags:
      exec_args.extend(['--tag', self._ParseTags(tags)])

    if info_url:
      exec_args.extend(['--url', info_url])

    return  exec_args

  def _ParseApplyArgs(self, apply_dir, project, **kwargs):
    del kwargs  # Not Used Here
    exec_args = ['apply', '-f', apply_dir, '--project', project]

    return exec_args

  def _ParseExportArgs(self, cluster, project, location, output_dir, **kwargs):
    del kwargs  # Not Used here

    exec_args = ['export', '-c', cluster, '--project', project]
    if location:
      exec_args.extend(['--location', location])

    if output_dir:
      exec_args.extend(['--output-directory', output_dir])

    return exec_args

  def _ParseArgsForCommand(self, command, **kwargs):
    if command == 'get':
      return self._ParseGetArgs(**kwargs)
    if command == 'update':
      return self._ParseUpdateArgs(**kwargs)
    if command == 'desc':
      return self._ParseDescribeArgs(**kwargs)
    if command == 'init':
      return self._ParseInitArgs(**kwargs)
    if command == 'apply':
      return self._ParseApplyArgs(**kwargs)
    if command == 'export':
      return self._ParseExportArgs(**kwargs)

    raise binary_operations.InvalidOperationForBinary(
        'Invalid Operation [{}] for anthoscli'.format(command))


def GetAuthToken(account, operation, impersonated=False):
  """Generate a JSON object containing the current gcloud auth token."""
  try:
    cred = c_store.LoadFreshCredential(account,
                                       allow_account_impersonation=impersonated)
    output = {
        'auth_token': cred.access_token,
    }
  except Exception as e:  # pylint: disable=broad-except
    raise AnthosAuthException(
        'Error retrieving auth credentials for {operation}: {error}. '.format(
            operation=operation, error=e))
  return json.dumps(output, sort_keys=True)


class AnthosAuthWrapper(binary_operations.StreamingBinaryBackedOperation):
  """Binary operation wrapper for anthoscli commands."""

  def __init__(self, **kwargs):
    custom_errors = {
        'MISSING_EXEC': messages.MISSING_AUTH_BINARY.format(
            binary='kubectl-anthos')
    }
    super(AnthosAuthWrapper, self).__init__(binary='kubectl-anthos',
                                            custom_errors=custom_errors,
                                            **kwargs)

  @property
  def default_config_path(self):
    return files.ExpandHomeAndVars(
        DEFAULT_LOGIN_CONFIG_PATH[platforms.OperatingSystem.Current().id])

  def _ParseLoginArgs(self,
                      cluster,
                      kube_config=None,
                      login_config=None,
                      login_config_cert=None,
                      user=None,
                      ldap_user=None,
                      ldap_pass=None,
                      dry_run=None,
                      **kwargs):
    del kwargs  # Not Used Here
    exec_args = ['login']
    if cluster:
      exec_args.extend(['--cluster', cluster])
    if kube_config:
      exec_args.extend(['--kubeconfig', kube_config])
    if login_config:
      exec_args.extend(['--login-config', login_config])
    if login_config_cert:
      exec_args.extend(['--login-config-cert', login_config_cert])
    if user:
      exec_args.extend(['--user', user])
    if dry_run:
      exec_args.extend(['--dry-run'])
    if ldap_pass and ldap_user:
      exec_args.extend(['--ldap-username', ldap_user,
                        '--ldap-password', ldap_pass])

    return exec_args

  def _ParseCreateLoginConfigArgs(self, kube_config, output_file=None,
                                  merge_from=None, **kwargs):
    del kwargs  # Not Used Here
    exec_args = ['create-login-config']
    exec_args.extend(['--kubeconfig', kube_config])
    if output_file:
      exec_args.extend(['--output', output_file])
    if merge_from:
      exec_args.extend(['--merge-from', merge_from])
    return exec_args

  def _ParseArgsForCommand(self, command, **kwargs):
    if command == 'login':
      return self._ParseLoginArgs(**kwargs)
    elif command == 'create-login-config':
      return self._ParseCreateLoginConfigArgs(**kwargs)
    elif command == 'version':
      return ['version']
    else:
      raise binary_operations.InvalidOperationForBinary(
          'Invalid Operation [{}] for kubectl-anthos'.format(command))


def _GetClusterConfig(all_configs, cluster):
  found_clusters = all_configs.FindMatchingItem(
      file_parsers.LoginConfigObject.CLUSTER_NAME_KEY, cluster)
  if len(found_clusters) != 1:
    raise AnthosAuthException(
        'Cluster [{}] not found for config path [{}]'.format(
            cluster, all_configs.file_path))
  return found_clusters.pop()


def _Base64EncodeLdap(username, passwd):
  """Base64 Encode Ldap username and password."""
  enc = lambda s: six.ensure_text(base64.b64encode(six.ensure_binary(s)))
  return enc(username), enc(passwd)


def _GetLdapUserAndPass(cluster_config, auth_name, cluster):
  """Prompt User for Ldap Username and Password."""
  ldap_user = None
  ldap_pass = None
  if not cluster_config.IsLdap():
    return None, None
  # do the prompting
  user_message = ('Please enter the ldap user for '
                  '[{}] on cluster [{}]: '.format(auth_name, cluster))
  pass_message = ('Please enter the ldap password for '
                  '[{}] on cluster [{}]: '.format(auth_name, cluster))
  ldap_user = console_io.PromptWithValidator(
      validator=lambda x: len(x) > 1,
      error_message='Error: Invalid username, please try again.',
      prompt_string=user_message)
  ldap_pass = console_io.PromptPassword(
      pass_message, validation_callable=lambda x: len(x) > 1)
  return _Base64EncodeLdap(ldap_user, ldap_pass)


def GetPreferredAuthForCluster(cluster, config_file, force_update=False):
  """Get preferredAuthentication value for cluster."""
  if not (cluster and config_file):
    return None, None, None
  configs = file_parsers.YamlConfigFile(config_file,
                                        file_parsers.LoginConfigObject)
  cluster_config = _GetClusterConfig(configs, cluster)

  try:
    auth_method = cluster_config.GetPreferredAuth()
  except KeyError:
    auth_method = None
  except file_parsers.YamlConfigObjectFieldError:
    # gracefully quit for config versions older than v2alpha1 that
    # do not support 'preferredAuthentication' field.
    return None, None, None
  if not auth_method or force_update:
    providers = cluster_config.GetAuthProviders()
    if not providers:
      raise AnthosAuthException(
          'No Authentication Providers found in [{}]'.format(config_file))
    if len(providers) == 1:
      auth_method = providers.pop()
    else:  # do the prompting
      prompt_message = ('Please select your preferred authentication option '
                        'for cluster [{}]'.format(cluster))
      override_warning = ('. Note: This will overwrite current preferred auth '
                          'method [{}] in config file.')
      if auth_method and force_update:
        prompt_message = prompt_message + override_warning.format(auth_method)
      index = console_io.PromptChoice(providers,
                                      message=prompt_message,
                                      cancel_option=True)
      auth_method = providers[index]

    log.status.Print(
        'Setting Preferred Authentication option to [{}]'.format(auth_method))
    cluster_config.SetPreferredAuth(auth_method)
    configs.WriteToDisk()

  ldap_user, ldap_pass = _GetLdapUserAndPass(cluster_config,
                                             auth_method,
                                             cluster)
  return auth_method, ldap_user, ldap_pass


def LoginResponseHandler(response, list_clusters_only=False):
  """Handle Login Responses."""
  if response.stdout:
    log.status.Print(response.stdout)

  if response.stderr:
    log.status.Print(response.stderr)

  if response.failed:
    log.error(messages.LOGIN_CONFIG_FAILED_MESSAGE.format(response.stderr))
    return None
  if not list_clusters_only:
    log.status.Print(messages.LOGIN_CONFIG_SUCCESS_MESSAGE)
  return response.stdout
