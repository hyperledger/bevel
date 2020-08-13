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
"""Library for generating the files for local development environment."""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import subprocess

from googlecloudsdk.command_lib.code import run_subprocess
from googlecloudsdk.core import exceptions
import six

DEFAULT_CLUSTER_NAME = 'gcloud-local-dev'


class _KubeCluster(object):
  """A kubernetes cluster.

  Attributes:
    context_name: Kubernetes context name.
    env_vars: Docker env vars.
    shared_docker: Whether the kubernetes cluster shares a docker instance with
      the developer's machine.
  """

  def __init__(self, context_name, shared_docker):
    """Initializes KindCluster with cluster name.

    Args:
      context_name: Kubernetes context.
      shared_docker: Whether the kubernetes cluster shares a docker instance
        with the developer's machine.
    """
    self.context_name = context_name
    self.shared_docker = shared_docker

  @property
  def env_vars(self):
    return {}


class KindCluster(_KubeCluster):
  """A cluster on kind.

  Attributes:
    context_name: Kubernetes context name.
    env_vars: Docker env vars.
    shared_docker: Whether the kubernetes cluster shares a docker instance with
      the developer's machine.
  """

  def __init__(self, cluster_name):
    """Initializes KindCluster with cluster name.

    Args:
      cluster_name: Name of cluster.
    """
    super(KindCluster, self).__init__('kind-' + cluster_name, False)


class KindClusterContext(object):
  """Context Manager for running Kind."""

  def __init__(self, cluster_name, delete_cluster=True):
    """Initialize KindContextManager.

    Args:
      cluster_name: Name of the kind cluster.
      delete_cluster: Delete the cluster when the context is exited.
    """
    self._cluster_name = cluster_name
    self._delete_cluster = delete_cluster

  def __enter__(self):
    _StartKindCluster(self._cluster_name)
    return KindCluster(self._cluster_name)

  def __exit__(self, exc_type, exc_value, tb):
    if self._delete_cluster:
      _DeleteKindCluster(self._cluster_name)


def DeleteKindClusterIfExists(cluster_name):
  """Delete a kind cluster if it is up."""
  if _IsKindClusterUp(cluster_name):
    _DeleteKindCluster(cluster_name)


def _StartKindCluster(cluster_name):
  """Starts a kind kubernetes cluster.

  Starts a cluster if a cluster with that name isn't already running.

  Args:
    cluster_name: Name of the kind cluster.
  """
  if not _IsKindClusterUp(cluster_name):
    cmd = [_FindKind(), 'create', 'cluster', '--name', cluster_name]
    print("Creating local development environment '%s' ..." % cluster_name)
    run_subprocess.Run(cmd, timeout_sec=150, show_output=True)
    print('Development environment created.')


def _IsKindClusterUp(cluster_name):
  """Checks if a cluster is running.

  Args:
    cluster_name: Name of the cluster

  Returns:
    True if a cluster with the given name is running.
  """
  cmd = [_FindKind(), 'get', 'clusters']
  clusters = run_subprocess.GetOutputLines(
      cmd, timeout_sec=20, show_stderr=False, strip_output=True)
  return cluster_name in clusters


def _DeleteKindCluster(cluster_name):
  """Deletes a kind kubernetes cluster.

  Args:
    cluster_name: Name of the cluster.
  """
  cmd = [_FindKind(), 'delete', 'cluster', '--name', cluster_name]
  print("Deleting development environment '%s' ..." % cluster_name)
  run_subprocess.Run(cmd, timeout_sec=150, show_output=False)
  print('Development environment deleted.')


def _FindKind():
  """Finds a path to kind."""
  return run_subprocess.GetGcloudPreferredExecutable('kind')


class MinikubeCluster(_KubeCluster):
  """A cluster on minikube.

  Attributes:
    context_name: Kubernetes context name.
    env_vars: Docker environment variables.
    shared_docker: Whether the kubernetes cluster shares a docker instance with
      the developer's machine.
  """

  @property
  def env_vars(self):
    return _GetMinikubeDockerEnvs(self.context_name)


class Minikube(object):
  """Starts and stops a minikube cluster."""

  def __init__(self,
               cluster_name,
               stop_cluster=True,
               vm_driver=None,
               debug=False):
    self._cluster_name = cluster_name
    self._stop_cluster = stop_cluster
    self._vm_driver = vm_driver
    self._debug = debug

  def __enter__(self):
    _StartMinikubeCluster(self._cluster_name, self._vm_driver, self._debug)
    return MinikubeCluster(self._cluster_name, self._vm_driver == 'docker')

  def __exit__(self, exc_type, exc_value, tb):
    if self._stop_cluster:
      _StopMinikube(self._cluster_name, self._debug)


def _FindMinikube():
  return run_subprocess.GetGcloudPreferredExecutable('minikube')


class MinikubeStartError(exceptions.Error):
  """Error if minikube fails to start."""


def _StartMinikubeCluster(cluster_name, vm_driver, debug=False):
  """Starts a minikube cluster."""
  # pylint: disable=broad-except
  try:
    if not _IsMinikubeClusterUp(cluster_name):
      cmd = [
          _FindMinikube(),
          'start',
          '-p',
          cluster_name,
          '--keep-context',
          '--interactive=false',
          '--delete-on-failure',
          '--install-addons=false',
      ]
      if vm_driver:
        cmd.append('--vm-driver=' + vm_driver)
        if vm_driver == 'docker':
          cmd.append('--container-runtime=docker')
      if debug:
        cmd.extend(['--alsologtostderr', '-v8'])

      print("Starting development environment '%s' ..." % cluster_name)
      run_subprocess.Run(cmd, timeout_sec=150, show_output=debug)
      print('Development environment created.')
  except Exception as e:
    six.reraise(MinikubeStartError, e)


def _GetMinikubeDockerEnvs(cluster_name):
  """Get the docker environment settings for a given cluster."""
  cmd = [_FindMinikube(), 'docker-env', '-p', cluster_name, '--shell=none']
  lines = run_subprocess.GetOutputLines(cmd, timeout_sec=20)
  return dict(
      line.split('=', 1) for line in lines if line and not line.startswith('#'))


def _IsMinikubeClusterUp(cluster_name):
  """Checks if a minikube cluster is running."""
  cmd = [_FindMinikube(), 'status', '-p', cluster_name, '-o', 'json']
  try:
    status = run_subprocess.GetOutputJson(
        cmd, timeout_sec=20, show_stderr=False)
    return 'Host' in status and status['Host'].strip() == 'Running'
  except (ValueError, subprocess.CalledProcessError):
    return False


def _StopMinikube(cluster_name, debug=False):
  """Stop a minikube cluster."""
  cmd = [_FindMinikube(), 'stop', '-p', cluster_name]
  print("Stopping development environment '%s' ..." % cluster_name)
  run_subprocess.Run(cmd, timeout_sec=150, show_output=debug)
  print('Development environment stopped.')


def DeleteMinikube(cluster_name):
  """Delete a minikube cluster."""
  cmd = [_FindMinikube(), 'delete', '-p', cluster_name, '--purge']
  print("Deleting development environment '%s' ..." % cluster_name)
  run_subprocess.Run(cmd, timeout_sec=150, show_output=False)
  print('Development environment stopped.')


class ExternalCluster(_KubeCluster):
  """A external kubernetes cluster.

  Attributes:
    context_name: Kubernetes context name.
    env_vars: Docker environment variables.
    shared_docker: Whether the kubernetes cluster shares a docker instance with
      the developer's machine.
  """

  def __init__(self, cluster_name):
    """Initializes ExternalCluster with profile name.

    Args:
      cluster_name: Name of the cluster.
    """
    super(ExternalCluster, self).__init__(cluster_name, False)


class ExternalClusterContext(object):
  """Do nothing context manager for external clusters."""

  def __init__(self, kube_context):
    self._kube_context = kube_context

  def __enter__(self):
    return ExternalCluster(self._kube_context)

  def __exit__(self, exc_type, exc_value, tb):
    pass


def _FindKubectl():
  return run_subprocess.GetGcloudPreferredExecutable('kubectl')


def _NamespaceExists(namespace, context_name=None):
  cmd = [_FindKubectl()]
  if context_name:
    cmd += ['--context', context_name]
  cmd += ['get', 'namespaces', '-o', 'name']
  namespaces = run_subprocess.GetOutputLines(
      cmd, timeout_sec=20, show_stderr=False)
  return 'namespace/' + namespace in namespaces


def _CreateNamespace(namespace, context_name=None):
  cmd = [_FindKubectl()]
  if context_name:
    cmd += ['--context', context_name]
  cmd += ['create', 'namespace', namespace]
  run_subprocess.Run(cmd, timeout_sec=20, show_output=False)


def _DeleteNamespace(namespace, context_name=None):
  cmd = [_FindKubectl()]
  if context_name:
    cmd += ['--context', context_name]
  cmd += ['delete', 'namespace', namespace]
  run_subprocess.Run(cmd, timeout_sec=20, show_output=False)


class KubeNamespace(object):
  """Context to create and tear down kubernetes namespace."""

  def __init__(self, namespace, context_name=None):
    """Initialize KubeNamespace.

    Args:
      namespace: (str) Namespace name.
      context_name: (str) Kubernetes context name.
    """
    self._namespace = namespace
    self._context_name = context_name
    self._delete_namespace = False

  def __enter__(self):
    if not _NamespaceExists(self._namespace, self._context_name):
      _CreateNamespace(self._namespace, self._context_name)
      self._delete_namespace = True

  def __exit__(self, exc_type, exc_value, tb):
    if self._delete_namespace:
      _DeleteNamespace(self._namespace, self._context_name)
