[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## create/k8_component
this role create value file for kubernetes component by inserted type.

## Tasks:
### 1. Ensures {{ component_type_name }} dir exists
This task check if value file of kubernetes component exists in release directory.

#### Variables:
 - component_type_name: A variable for grouping data by type, name or organization.
 - release_dir: Release directory, where are stored generated files for gitops.

### 2. create {{ component_type }} file for {{ component_type_name }}
This task create a value file of kubernetes component.
Type of Kubernetes component is selected by variable *type* and then it is find in templates.

#### Variables:
 - component_type: A type of kubernetes component.
 - component_type_name: A variable for grouping data by type, name or organization.
 - release_dir: Release directory, where are stored generated files for gitops.
 
#### Input Variables:
 - values_file: Path for output value file. It uses *{{ release_dir }}/{{ component_type_name }}/{{ component_type }}.yaml*
 - type: A type of kubernetes component.
 
## Templates:
 - admin_cluster_role_binding.tpl: A template for create an admin ClusterRoleBinding component.
 - aws_storageclass.tpl: A template for create a StorageClass when provider is AWS
 - cluster_role_binding.tpl: A template for create a ClusterRoleBinding component.
 - default.tpl: A default template.
 - eks_storageclass.tpl: A template for create a StorageClass when provider is EKS.
 - mini_storageclass.tpl: A template for create a StorageClass when provider is MiniKube.
 - namespace_component.tpl: A template for create Namespace Kubernetes component.
 - serviceaccount.tpl: A template for create ServiceAccount Kubernetes component.

## Vars
 - namespace: namespace_component.tpl
 - service-account: serviceaccount.tpl
 - cluster-role-binding: cluster_role_binding.tpl
 - admin-cluster-role-binding: admin_cluster_role_binding.tpl
 - aws-baremetal-storageclass: aws_storageclass.tpl
 - aws-storageclass: eks_storageclass.tpl
 - minikube-storageclass: mini_storageclass.tpl
