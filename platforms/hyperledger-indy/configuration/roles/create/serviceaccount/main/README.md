[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## create/serviceaccount/main
This role creates value files of all needed Service Accounts and ClusterRoleBindings of organization.

## Tasks:
### 1. Create service account for trustees [{{ organization }}]
This task creates a value file of ServiceAccount for trustees.
It calls role *create/serviceaccount/by_identities*.

#### Variables:
 - organization: A name of organization.

#### Input Variables:
 - component_namespace: A namespace of organization.
 - component_name: A name of ServiceAccount. By default it is *{{ organization }}-{{ trusteeItem.name }}-vault-auth*
 - release_dir: Release directory, where are stored generated files for gitops. By default is *{{ playbook_dir }}/../../../{{ gitops.release_dir }}/{{ organization }}*

### 2. Create service account for stewards [{{ organization }}]
This task creates a value file of ServiceAccount for stewards.
It calls role *create/serviceaccount/by_identities*.

#### Variables:
 - organization: A name of organization.

#### Input Variables:
 - component_namespace: A namespace of organization.
 - component_name: A name of ServiceAccount. By default it is *{{ organization }}-{{ stewardItem.name }}-vault-auth*
 - release_dir: Release directory, where are stored generated files for gitops. By default is *{{ playbook_dir }}/../../../{{ gitops.release_dir }}/{{ organization }}*

### 3. Create service account for endorsers [{{ organization }}]
This task creates a value file of ServiceAccount for endorsers.
It calls role *create/serviceaccount/by_identities*.

#### Variables:
 - organization: A name of organization.

#### Input Variables:
 - component_namespace: A namespace of organization.
 - component_name: A name of ServiceAccount. By default it is *{{ organization }}-{{ endorserItem.name }}-vault-auth*
 - release_dir: Release directory, where are stored generated files for gitops. By default is *{{ playbook_dir }}/../../../{{ gitops.release_dir }}/{{ organization }}*

### 4. Create service account for organization [{{ organization }}]
This task creates a value file of ServiceAccount for organization.
It calls role *create/serviceaccount/by_identities*.

#### Variables:
 - organization: A name of organization.

#### Input Variables:
 - component_namespace: A namespace of organization.
 - component_name: A name of ServiceAccount. By default it is *{{ organization }}-admin-vault-auth*
 - release_dir: Release directory, where are stored generated files for gitops. By default is *{{ playbook_dir }}/../../../{{ gitops.release_dir }}/{{ organization }}*

### 5. Create service account for read only public crypto [{{ organization }}]
This task creates a value file of read-only ServiceAccount for organization.
This ServiceAccount is used for reading public data from Indy Crypto saved in Vault.
It calls role *create/serviceaccount/by_identities*.

#### Variables:
 - organization: A name of organization.

#### Input Variables:
 - component_namespace: A namespace of organization.
 - component_name: A name of ServiceAccount. By default it is *{{ organization }}-bevel-ac-vault-auth*
 - release_dir: Release directory, where are stored generated files for gitops. By default is *{{ playbook_dir }}/../../../{{ gitops.release_dir }}/{{ organization }}*

### 6. Push the created deployment files to repository
This task pushes generated Helm releases into remote branch.
This task calls role from: *{{ playbook_dir }}/../../shared/configuration/roles/git_push*
#### Input Variables:
 - GIT_DIR: A path of git directory. By default "{{ playbook_dir }}/../../../"
 - GIT_RESET_PATH: A path of git directory, which is reseted for committing. Default value is *platforms/hyperledger-indy/configuration*
 - gitops: *item.gitops* from network.yaml
 - msg: A message for git commit

### 7. Waiting for trustees accounts and cluster binding roles
This task is waiting for creating ServiceAccount and ClusterRoleBinding for trustees
It calls role *create/serviceaccount/waiting*.

#### Variables:
 - organization: A organization name.

#### Input Variables:
 - name: A name of ServiceAccount and ClusterRoleBinding. By default is *{{ organization }}-{{ trusteeItem.name }}*

### 8. Waiting for stewards accounts and cluster binding roles
This task is waiting for creating ServiceAccount and ClusterRoleBinding for stewards
It calls role *create/serviceaccount/waiting*.

#### Variables:
 - organization: A organization name.

#### Input Variables:
 - name: A name of ServiceAccount and ClusterRoleBinding. By default is *{{ organization }}-{{ stewardItem.name }}*

### 9. Waiting for endorsers accounts and cluster binding roles
This task is waiting for creating ServiceAccount and ClusterRoleBinding for endorsers
It calls role *create/serviceaccount/waiting*.

#### Variables:
 - organization: A organization name.

#### Input Variables:
 - name: A name of ServiceAccount and ClusterRoleBinding. By default is *{{ organization }}-{{ endorserItem.name }}*

### 10. Waiting for organization accounts and cluster binding roles
This task is waiting for creating ServiceAccount and ClusterRoleBinding for organization
It calls role *create/serviceaccount/waiting*.

#### Variables:
 - organization: A organization name.

#### Input Variables:
 - name: A name of ServiceAccount and ClusterRoleBinding. By default is *{{ organization }}-admin*

### 11. Waiting for organization read only account and cluster binding role
This task is waiting for creating read-only ServiceAccount and ClusterRoleBinding for organization
It calls role *create/serviceaccount/waiting*.

#### Variables:
 - organization: A organization name.

#### Input Variables:
 - name: A name of ServiceAccount and ClusterRoleBinding. By default is *{{ organization }}-bevel-ac*
