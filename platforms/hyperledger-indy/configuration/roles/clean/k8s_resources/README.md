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
 
#### 2. Get all existing Cluster Role Bindings of organization {{ organization }}
The task returns all Cluster Role Bindings Kubernetes components of current organization.
##### Input Variables:
 - organization: A name of current organization.
##### Output Variables:
 - rolelist: A list of Cluster Role Bindings.

#### 3. Remove an existing Cluster Role Binding of {{ organization }}
The task removes all Cluster Role Bindings of organizations, which was founded in previous task.
##### Variables:
 - item: Current Cluster Role Binding item from a list.
##### Input Variables:
 - organization: A name of current organization.
 - rolelist.resources: Content of all Cluster Role Bindings of organization. 
 - item.metadata.name: A name of Cluster Role Binding.

#### 4. Remove an existing Namespace {{ organization_ns }}
The task removes a Namespace of current organization.
##### Input Variables:
 - organization_ns: A name of organization's namespace.

#### 5. Remove an existing Storage Class of {{ organization }}
The task remove all storage classes of current organization.
##### Variables:
 - provider: A name of provider where is solution running.
 - storageclass_name: A name of storage class.
 - component_name: Full name of storage class with current organization's name.
##### Input Variables:
 - organization: A name of current organization.
 - organizationItem.cloud_provider: A provider of current organization.