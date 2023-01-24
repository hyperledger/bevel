[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## create/serviceaccount/waiting
This role is waiting for create inserted ServiceAccounts or ClusterRoleBinding.

## Tasks:
### 1. Wait for creation for service account
This task is waiting for creation ServiceAccount
It calls role *check/k8_component*

#### Variables:
 - name: A name of component.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 
#### Input Variables:
 - component_type: A type of kubernetes component. Default is *ServiceAccount*.
 - component_name: A component name, where adds *-vault-auth* suffix to value of variable *name*.
 - kubeconfig: Kubernetes config file from network.yaml file.

### 2. Wait for creation for cluster role binding
This task is waiting for creation ClusterRoleBinding
It calls role *check/k8_component*

#### Variables:
 - name: A name of component.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 
#### Input Variables:
 - component_type: A type of kubernetes component. Default is *ClusterRoleBinding*.
 - component_name: A component name, where adds *-vault-auth-role-binding* suffix to value of variable *name*.
 - kubeconfig: Kubernetes config file from network.yaml file.
