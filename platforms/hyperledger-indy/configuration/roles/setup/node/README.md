[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## setup/node
This role generates Helm releases of Kubernetes StatefulSet for nodes of Stewards.

## Tasks:
### 1. Wait for namespace creation for stewards
This task checking if namespaces for stewards of organizations are created.
This task calls role from *check/k8_component*
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default a value *Namespace*.
 - component_name: Name of component, which it may check. It use a variable {{ component_ns }}
### 2. Create image pull secret for stewards
This task create pull secret of each stewards of organization.
This task calls role from *create/imagepullsecret*
### 3. Create steward deployment file
This task creates Helm releases of Kubernetes StatefulSet for nodes of Stewards.
This task calls role from *create/helm_component/node*
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default value *node*.
 - component_name: Name of Helm release. Default value is {{ organization }}-{{ stewardItem.name }}-node
 - indy_version: Version of Hyperledger Indy Node. Default value is indy-{{ network.version }}
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
### 4. Push the created deployment files to repository
This task pushes generated Helm releases into remote branch.
This task calls role from: *{{ playbook_dir }}/../../shared/configuration/roles/git_push*
#### Input Variables:
 - GIT_DIR: A path of git directory. By default "{{ playbook_dir }}/../../../"
 - GIT_RESET_PATH: A path of git directory, which is reseted for committing. Default value is *platforms/hyperledger-indy/configuration*
 - gitops: *item.gitops* from network.yaml
 - msg: A message for git commit
### 5. Wait until steward pods are running
This task is waiting for creation of all Config Maps for each organizations.
This task calls role *check/k8_component*
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default value *Pod*.
 - component_name: A name of component, which may be checked. It uses a variable *{{ organization }}-{{ stewardItem.name }}-node*