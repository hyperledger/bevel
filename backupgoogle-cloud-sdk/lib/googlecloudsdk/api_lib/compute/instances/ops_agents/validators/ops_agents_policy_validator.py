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
"""Common validators for ops agents policy create and update commands."""

from __future__ import absolute_import
from __future__ import division
from __future__ import unicode_literals

import collections
import json
import re

from googlecloudsdk.api_lib.compute.instances.ops_agents import exceptions
from googlecloudsdk.api_lib.compute.instances.ops_agents import ops_agents_policy as agent_policy
from googlecloudsdk.core import log

_PINNED_MAJOR_VERSION_RE = re.compile(r'^\d+\.\*\.\*$')
_PINNED_LEGACY_VERSION_RE = re.compile(r'^5\.5\.2-\d+$')
_PINNED_VERSION_RE = re.compile(r'^\d+\.\d+\.\d+$')
_SUPPORTED_OS_SHORT_NAMES_AND_VERSIONS = {
    agent_policy.OpsAgentPolicy.Assignment.OsType.OsShortName.CENTOS: [
        '7', '8'
    ],
    agent_policy.OpsAgentPolicy.Assignment.OsType.OsShortName.DEBIAN: [
        '9', '10'
    ],
    agent_policy.OpsAgentPolicy.Assignment.OsType.OsShortName.RHEL: [
        '7', '8'
    ],
    agent_policy.OpsAgentPolicy.Assignment.OsType.OsShortName.SLES: [
        '12', '15'
    ],
    agent_policy.OpsAgentPolicy.Assignment.OsType.OsShortName.SLES_SAP: [
        '12', '15'
    ],
    agent_policy.OpsAgentPolicy.Assignment.OsType.OsShortName.UBUNTU: [
        '16.04', '18.04', '19.10', '20.04'
    ],
}
_OS_SHORT_NAMES_WITH_OS_AGENT_PREINSTALLED = (
    agent_policy.OpsAgentPolicy.Assignment.OsType.OsShortName.CENTOS,
    agent_policy.OpsAgentPolicy.Assignment.OsType.OsShortName.DEBIAN,
    agent_policy.OpsAgentPolicy.Assignment.OsType.OsShortName.RHEL,
)


class AgentTypesUniquenessError(exceptions.PolicyValidationError):
  """Raised when agent type is not unique."""

  def __init__(self, agent_type):
    super(AgentTypesUniquenessError, self).__init__(
        'At most one agent with type [{}] is allowed.'.format(agent_type))


class AgentVersionInvalidFormatError(exceptions.PolicyValidationError):
  """Raised when agent version format is invalid."""

  def __init__(self, version):
    super(AgentVersionInvalidFormatError, self).__init__(
        'The agent version [{}] is not allowed. Expected values: [latest], '
        '[current-major], or anything in the format of '
        '[MAJOR_VERSION.MINOR_VERSION.PATCH_VERSION] or '
        '[MAJOR_VERSION.*.*].'.format(version))


class AgentVersionAndEnableAutoupgradeConflictError(
    exceptions.PolicyValidationError):
  """Raised when agent version is pinned but autoupgrade is enabled."""

  def __init__(self, version):
    super(AgentVersionAndEnableAutoupgradeConflictError, self).__init__(
        'An agent can not be pinned to the specific version [{}] when '
        '[enable-autoupgrade] is set to true for that agent.'.format(version))


class OsTypesMoreThanOneError(exceptions.PolicyValidationError):
  """Raised when more than one OS types are specified."""

  def __init__(self):
    super(OsTypesMoreThanOneError, self).__init__(
        'Only one OS type is allowed in the instance filters.')


class OsTypeNotSupportedError(exceptions.PolicyValidationError):
  """Raised when the OS short name and version combination is not supported."""

  def __init__(self, short_name, version):
    super(OsTypeNotSupportedError, self).__init__(
        'The combination of short name [{}] and version [{}] is not supported. '
        'The supported versions are: {}.'.format(
            short_name, version, json.dumps(
                _SUPPORTED_OS_SHORT_NAMES_AND_VERSIONS)))


def ValidateOpsAgentsPolicy(policy):
  """Validates semantics of an Ops agents policy.

  This validation happens after the arg parsing stage. At this point, we can
  assume that the field is an OpsAgentPolicy object.

  Args:
    policy: ops_agents.OpsAgentPolicy. The policy that manages Ops agents.

  Raises:
    PolicyValidationMultiError that contains a list of validation
    errors from the following list.
    * AgentTypesUniquenessError:
      Multiple agents with the same type are specified.
    * AgentVersionInvalidFormatError:
      Agent version format is invalid.
    * AgentVersionAndEnableAutoupgradeConflictError:
      Agent version is pinned but autoupgrade is enabled.
    * OsTypesMoreThanOneError:
      More than one OS types are specified.
    * OsTypeNotSupportedError:
      The combination of the OS short name and version is not supported.
  """
  errors = (_ValidateAgentRules(policy.agent_rules) +
            _ValidateOsTypes(policy.assignment.os_types))
  if errors:
    raise exceptions.PolicyValidationMultiError(errors)
  log.debug('Ops Agents policy validation passed.')


def _ValidateAgentRules(agent_rules):
  """Validates semantics of the ops-agents-policy.agent-rules field.

  This validation happens after the arg parsing stage. At this point, we can
  assume that the field is a list of OpsAgentPolicy.AgentRule object.

  Args:
    agent_rules: list of OpsAgentPolicy.AgentRule. The list of agent rules to be
      managed by the Ops Agents policy.

  Returns:
    An empty list if the validation passes. A list of errors from the following
    list if the validation fails.
    * AgentTypesUniquenessError:
      Multiple agents with the same type are specified.
    * AgentVersionInvalidFormatError:
      Agent version format is invalid.
    * AgentVersionAndEnableAutoupgradeConflictError:
      Agent version is pinned but autoupgrade is enabled.
  """
  errors = _ValidateAgentTypesUniqueness(agent_rules)
  for agent_rule in agent_rules:
    errors.extend(_ValidateAgentRule(agent_rule))
  return errors


def _ValidateAgentTypesUniqueness(agent_rules):
  """Validates that each type of agent occurs at most once.

  This validation happens after the arg parsing stage. At this point, we can
  assume that the field is a list of OpsAgentPolicy.AgentRule object. Each
  OpsAgentPolicy object's 'type' field already complies with the allowed values.

  Args:
    agent_rules: list of OpsAgentPolicy.AgentRule. The list of agent rules to be
      managed by the Ops Agents policy.

  Returns:
    An empty list if the validation passes. A list that contains one or more
    errors below if the validation fails.
    * AgentTypesUniquenessError:
      Multiple agents with the same type are specified.
  """
  agent_types = collections.Counter(
      agent_rule.type for agent_rule in agent_rules)
  duplicate_types = [k for k, v in agent_types.items() if v > 1]
  return [AgentTypesUniquenessError(t) for t in sorted(duplicate_types)]


def _ValidateAgentRule(agent_rule):
  """Validates semantics of an individual OpsAgentPolicy.AgentRule.

  This validation happens after the arg parsing stage. At this point, we can
  assume that the field is an OpsAgentPolicy.AgentRule object.

  Args:
    agent_rule: OpsAgentPolicy.AgentRule. The agent rule to enforce by the Ops
      Agents policy.

  Returns:
    An empty list if the validation passes. A list of errors from the following
    list if the validation fails.
    * AgentVersionInvalidFormatError:
      Agent version format is invalid.
    * AgentVersionAndEnableAutoupgradeConflictError:
      Agent version is pinned but autoupgrade is enabled.
  """
  return (_ValidateAgentVersion(agent_rule.version) +
          _ValidateAgentVersionAndEnableAutoupgrade(
              agent_rule.version, agent_rule.enable_autoupgrade))


def _ValidateAgentVersion(version):
  """Validates agent version format.

  This validation happens after the arg parsing stage. At this point, we can
  assume that the field is a valid string.

  Args:
    version: str. The version of agent. Allowed values:
      * "latest"
      * "current-major"
      * "[MAJOR_VERSION].*.*"
      * "[MAJOR_VERSION].[MINOR_VERSION].[PATCH_VERSION]"

  Returns:
    An empty list if the validation passes. A singleton list with the following
    error if the validation fails.
    * AgentVersionInvalidFormatError:
      Agent version format is invalid.
  """
  version_enum = agent_policy.OpsAgentPolicy.AgentRule.Version
  if not (version in {version_enum.LATEST_OF_ALL,
                      version_enum.CURRENT_MAJOR} or
          _PINNED_MAJOR_VERSION_RE.search(version) or
          _PINNED_LEGACY_VERSION_RE.search(version) or
          _PINNED_VERSION_RE.search(version)):
    return [AgentVersionInvalidFormatError(version)]
  return []


def _ValidateAgentVersionAndEnableAutoupgrade(version, enable_autoupgrade):
  """Validates that agent version is not pinned when autoupgrade is enabled.

  This validation happens after the arg parsing stage. At this point, we can
  assume that the fields are valid string and boolean.

  Args:
    version: str. The version of agent. Possible formats:
      * "latest"
      * "[MAJOR_VERSION].*.*"
      * "[MAJOR_VERSION].[MINOR_VERSION].[PATCH_VERSION]"
    enable_autoupgrade: bool. Whether autoupgrade is enabled.

  Returns:
    An empty list if the validation passes. A singleton list with the following
    error if the validation fails.
    * AgentVersionAndEnableAutoupgradeConflictError:
      Agent version is pinned but autoupgrade is enabled.
  """
  if _PINNED_VERSION_RE.search(version) and enable_autoupgrade:
    return [AgentVersionAndEnableAutoupgradeConflictError(version)]
  return []


def _ValidateOsTypes(os_types):
  """Validates semantics of the ops-agents-policy.os-types field.

  This validation happens after the arg parsing stage. At this point, we can
  assume that the field is a list of OpsAgentPolicy.Assignment.OsType objects.

  Args:
    os_types: list of OpsAgentPolicy.Assignment.OsType.
      The list of OS types as part of the instance filters that the Ops Agent
      policy applies to the Ops Agents policy.

  Returns:
    An empty list if the validation passes. A list of errors from the following
    list if the validation fails.
    * OsTypesMoreThanOneError:
      More than one OS types are specified.
    * OsTypeNotSupportedError:
      The combination of the OS short name and version is not supported.
  """
  errors = _ValidateOnlyOneOsTypeAllowed(os_types)
  for os_type in os_types:
    errors.extend(_ValidateSupportedOsType(os_type.short_name, os_type.version))
  return errors


def _ValidateOnlyOneOsTypeAllowed(os_types):
  """Validates that no more than one OS type is specified.

  This validation happens after the arg parsing stage. At this point, we can
  assume that the field is a list of OpsAgentPolicy.Assignment.OsType objects.

  Args:
    os_types: list of OpsAgentPolicy.Assignment.OsType.
      The list of OS types as part of the instance filters that the Ops Agent
      policy applies to the Ops Agents policy.

  Returns:
    An empty list if the validation passes. A singleton list with the following
    error if the validation fails.
    * OsTypesMoreThanOneError:
      More than one OS types are specified.
  """
  if len(os_types) > 1:
    return [OsTypesMoreThanOneError()]
  return []


def _ValidateSupportedOsType(short_name, version):
  """Validates the combination of the OS short name and version is supported.

  This validation happens after the arg parsing stage. At this point, we can
  assume that the field is an OpsAgentPolicy.Assignment.OsType object. Also the
  OS short name has been already validated at the arg parsing stage.

  Args:
    short_name: str. The OS short name to filter instances by.
    version: str. The OS version to filter instances by.

  Returns:
    An empty list if the validation passes. A singleton list with the following
    error if the validation fails.
    * OsTypeNotSupportedError:
      The combination of the OS short name and version is not supported.
  """
  if (short_name in _SUPPORTED_OS_SHORT_NAMES_AND_VERSIONS
      and short_name not in _OS_SHORT_NAMES_WITH_OS_AGENT_PREINSTALLED):
    log.warning(
        'For the policies to take effect on [{}] OS distro, please follow '
        'the instructions at '
        'https://cloud.google.com/compute/docs/manage-os#agent-install '
        'to install the OS Config Agent on your instances.'.format(
            short_name))
  supported_versions = _SUPPORTED_OS_SHORT_NAMES_AND_VERSIONS[short_name]
  if any(version.startswith(v) for v in supported_versions):
    # Validation passed.
    return []
  return [OsTypeNotSupportedError(short_name, version)]
