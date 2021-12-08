[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## setup/pool_genesis
This role generates Helm releases of Kubernetes Config Maps, which contain of generated pool genesis.

## Tasks:
### 1. Create pool genesis
This task creates Helm releases of kubernetes Config Maps, which contain of generated pool genesis.
This task calls role from *create/helm_component/pool_genesis*
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default value *pool_genesis*.
 - chartName: Name of Chart, which will be used. Default value *pool_genesis*
### 2. Push the created deployment files to repository
This task pushes generated Helm releases into remote branch.
This task calls role from: *{{ playbook_dir }}/../../shared/configuration/roles/git_push*
#### Input Variables:
 - GIT_DIR: A path of git directory. By default "{{ playbook_dir }}/../../../"
 - GIT_RESET_PATH: A path of git directory, which is reseted for committing. Default value is *platforms/hyperledger-indy/configuration*
 - gitops: *item.gitops* from network.yaml
 - msg: A message for git commit
### 3. Wait until pool genesis configmap are created
This task is waiting for creation of all Config Maps for each organizations.
This task calls role *check/k8_component*
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default value *ConfigMap*.
 - kubernetes: A object, which contains kubernetes configurations form network.yaml. it uses a variable *{{ organizationItem.k8s }}*
 - component_name: A name of Config Maps, which may be checked. It uses a variable *{{ organizationItem.name }}-ptg*
 - component_ns: A name of Namespace, in which are located Config Maps. It uses a variable *{{ organizationItem.name | lower }}-ns*