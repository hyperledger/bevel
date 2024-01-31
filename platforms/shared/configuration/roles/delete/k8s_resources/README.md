[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## clean/k8s_resources
The role deletes all running Kubernetes components and Helm releases of all organizations.

### Tasks:
#### 1. Remove all Helm releases of organization {{ organization }}
The task removes all deployed Helm releases of current organization.
##### Input Variables:
 - kubernetes.config_file: A path of kubernetes config file.
 - organization: A name of current organization.

#### 2. Remove an existing Namespace {{ organization_ns }}
The task removes a Namespace of current organization.
##### Input Variables:
 - organization_ns: A name of organization's namespace.

#### 3. Remove an existing Storage Class of {{ organization }}
The task remove all storage classes of current organization.
##### Variables:
 - provider: A name of provider where is solution running.
 - storageclass_name: A name of storage class.
 - component_name: Full name of storage class with current organization's name.
##### Input Variables:
 - organization: A name of current organization.
 - organizationItem.cloud_provider: A provider of current organization.