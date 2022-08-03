[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## setup/auth_job
This role generates Helm releases of kubernetes jobs, which create Auth Methods into HashiCorp Vault for getting Vault token by Kubernetes Service Accounts

## Tasks:
### 1. Wait for namespace creation for stewards
This task checking if namespaces for stewards of organizations are created.
This task calls role from *check/k8_component*
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default a value *Namespace*.
 - component_name: Name of component, which it may check. It use a variable {{ component_ns }}
### 2. Create auth_job of stewards, trustee and endorser
This task creates Helm releases of kubernetes jobs, which create Auth Methods for stewards, trustee and endorser in Vault
This task calls role from *create/helm_component/auth_job*
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default value *auth_job*.
 - component_name: Name of component, which it may check. It use a variable {{ organization }}
 - chartName: Name of Chart, which will be used. Default value *indy-auth-job* 
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
### 3. Push the created deployment files to repository
This task pushes generated Helm releases into remote branch.
This task calls role from: *{{ playbook_dir }}/../../shared/configuration/roles/git_push*
#### Input Variables:
 - GIT_DIR: A path of git directory. By default "{{ playbook_dir }}/../../../"
 - GIT_RESET_PATH: A path of git directory, which is reseted for committing. Default value is *platforms/hyperledger-indy/configuration*
 - gitops: *item.gitops* from network.yaml
 - msg: A message for git commit
### 4. Check if auth job finished correctly
This task checks for creating Auth Methods in Vault.
This task calls role *check/auth_job*
#### Input Variables:
This task doesn't use input variables on this place, please check role *check/auth_job*, which input variables are used. 
