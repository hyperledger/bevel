[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## create/serviceaccount/by_identities
This role create a value files for service accounts and cluster role bindings by identity name.

## Tasks:
### 1. Check if service account for {{ component_name }} exists
This task checks if current service account exists in Kubernetes cluster.

#### Variables:
 - component_name: A name of service account.
 - component_namespace: A name of organization's namespace.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.

#### Output Variables:
 - serviceaccount_state: A values, in which is stored status of service account existence.

### 2. Create service account for {{ component_name }}
This task creates a value file of ServiceAccount.
It calls role *create/k8_component*
The value file is created, when a Service Account doesn't exist in Kubernetes cluster.

#### Variables:
 - component_name: A name of Service Account.

#### Input Variables:
 - component_type: A type of Kubernetes components. It is set up to *service-account*
 - component_type_name: A type for grouping by name. It uses a variable *component_name*
 
### 3. Check cluster role binding for {{ component_name }}
This task checks if current ClusterRoleBinding exists in Kubernetes cluster.

#### Variables:
 - component_name: A name of ClusterRoleBinding.
 - component_namespace: A name of organization's namespace.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.

#### Output Variables:
 - clusterrolebinding_state: A values, in which is stored status of ClusterRoleBinding existence.

### 4. Get component_name to var
This task save component name into variable for checking in last task.

#### Variables:
 - component_name: A name of component.

#### Output Variables:
 - component_name_var: Stored component name.

### 5. Get organization and admin string to var
This task create name joining organization name with admin-vault-auth for comparing in last task.

#### Variables:
 - organization: An organization name.
 
#### Output Variables:
 - organization_admin_var: Stored a new name of component.

### 6. Create cluster role binding for {{ component_name }}
This task creates a value file of ClusterRoleBinding.
It calls role *create/k8_component*
The value file is created, when a ClusterRoleBinding doesn't exist in Kubernetes cluster.

#### Variables:
 - component_name: A name of ClusterRoleBinding.

#### Input Variables:
 - component_type: A type of Kubernetes components. It is set up to *cluster-role-binding*
 - component_type_name: A type for grouping by name. It uses a variable *component_name*

### 7. Create admin cluster role binding for {{ component_name }}
This task create ClusterRoleBinding for admin ServiceAccount per organization, no per identity.
This task starts only when variables *organization_admin_var* and *component_name_var* have the same value (name of components).
It calls role *create/k8_component*

#### Input Variables:
 - component_type: A type of Kubernetes components. It is set up to *admin-cluster-role-binding*
 - component_type_name: A type for grouping by name. It uses a variable *component_name*