[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## setup/crypto
This role generates Helm release of crypto generator, push it into git and check if crypto is inserted into HashiCorp Vault

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
#### Input Variables:
This task doesn't use input variables on this place, please check role *create/imagepullsecret*, which input variables are used.
### 3. Create crypto of stewards, trustee and endorser
This task creates Helm releases of generator cryptos for stewards, trustee and endorser
This task calls role from *create/helm_component/crypto*
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default value *crypto*.
 - component_name: Name of component, which it may check. It use a variable {{ organization }}
 - chartName: Name of Chart, which will be used. Default value *indy-key-mgmt* 
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
### 4. Push the created deployment files to repository
This task pushes generated Helm releases into remote branch.
This task calls role from: *{{ playbook_dir }}/../../shared/configuration/roles/git_push*
#### Input Variables:
 - GIT_DIR: A path of git directory. By default "{{ playbook_dir }}/../../../"
 - GIT_RESET_PATH: A path of git directory, which is reseted for committing. Default value is *platforms/hyperledger-indy/configuration*
 - gitops: *item.gitops* from network.yaml
 - msg: A message for git commit
### 5. Check Vault for Indy crypto
This task checks for fill Vault of crypto data.
This task calls role *check/crypto*
#### Input Variables:
This task doesn't use input variables on this place, please check role *check/crypto*, which input variables are used. 
