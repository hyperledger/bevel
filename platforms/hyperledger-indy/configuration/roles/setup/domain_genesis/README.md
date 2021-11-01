[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## setup/domain_genesis
This role generates Helm releases of Kubernetes Config Maps, which contain of generated domain genesis.

## Tasks:
### 1. Create domain genesis
This task creates Helm releases of kubernetes Config Maps, which contain of generated domain genesis.
This task calls role from *create/helm_component/domain_genesis*
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default value *domain_genesis*.
 - chartName: Name of Chart, which will be used. Default value *domain_genesis*
### 2. Push the created deployment files to repository
This task pushes generated Helm releases into remote branch.
This task calls role from: *{{ playbook_dir }}/../../shared/configuration/roles/git_push*
#### Input Variables:
 - GIT_DIR: A path of git directory. By default "{{ playbook_dir }}/../../../"
 - GIT_RESET_PATH: A path of git directory, which is reseted for committing. Default value is *platforms/hyperledger-indy/configuration*
 - gitops: *item.gitops* from network.yaml
 - msg: A message for git commit
### 3. Wait until domain genesis configmap are created
This task is waiting for creation of all Config Maps for each organizations.
This task calls role *check/k8_component*
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default value *ConfigMap*.
 - kubernetes: A object, which contains kubernetes configurations form network.yaml. it uses a variable *{{ organizationItem.k8s }}*
 - component_name: A name of Config Maps, which may be checked. It uses a variable *{{ organizationItem.name }}-dtg*
 - component_ns: A name of Namespace, in which are located Config Maps. It uses a variable *{{ organizationItem.name | lower }}-ns*
