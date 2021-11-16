[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## setup/trustees
This role creates the deployment files for trustees and pushes them to repository.

## Tasks:
### 1. Wait for namespace creation
This task checking if namespaces for identities of organizations are created.
This task calls role from *check/k8_component*
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default a value *Namespace*.
 - component_name: Name of component, which it may check. It use a variable {{ component_ns }}
### 2. Create image pull secret for identities
This task create pull secret of each identity of organization.
This task calls role from *create/imagepullsecret*
### 3. Create Deployment files for Identities
This task creates Helm releases Indy Ledger Transaction Job for trustee Identities.
It calls a nested_main.yaml task.
#### Input Variables:
 - component_type: Set, which type of k8s component may be created. Default value *node*.
 - component_name: Name of Helm release. Default value is {{ organization }}-{{ stewardItem.name }}-node
 - indy_version: Version of Hyperledger Indy Node. Default value is indy-{{ network.version }}
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
 - newIdentity: A list of trustees in current organization.
 - component_ns: A name of organizatio's namespace.
 - org_vault_url: Vault URL of organization
### 4. Wait until identities are creating
This task is waiting until identity transaction is done.
#### Input Variables:
 - component_name: A name of current organization.
 - trustees: A list of trustees of current organization.

---------------------------------------------------------------------------------------
nested_main.yaml

### 1. Select Admin Identity for Organisation {{ component_name }}
This task selects the admin identity for a particular organization.

### 2. Inserting file into Variable
This task inserts a file of admin identity into variable.
#### Input Variables.
 - admin.yaml: A file of admin identity.
#### Output Variables:
 - admin_var: A variable consists of admin identity file.

### 3. Calling Helm Release Development Role...
It calls the helm release development role for for creation of deployment file.
#### Input Variables:
 - component_type: "Set, which type of k8s component may be created."
-  component_name: "Name of the component"
-  indy_version: "Network version of indy"
-  release_dir: "Release directory in which the deployment file is saved"
- component_ns: "Namespace of the component"
-  newIdentityName: "Name of identity trustee to be added"
-  newIdentityRole: "Role of the trustee"
-  adminIdentityName: "Name of admin identity"
-  admin_component_name: "Name of admin Identity's Organization"
-  admin_org_vault_url: "Admin Org's Vault URL"
-  new_org_vault_url: "New Identity's vault URL"
-  new_component_name: "Name of New Identity's Organization"
- admin_type: "Type of Admin Identity"
- identity_type: "Type of identity to be added"

### 4. Delete file
This task deletes admin identity file.
#### Input Variables:
 - admin.yaml: A file of admin identity.

### 4. Push the created deployment files to repository
This task pushes generated Helm releases into remote branch.
This task calls role from: *{{ playbook_dir }}/../../shared/configuration/roles/git_push*
#### Input Variables:
 - GIT_DIR: A path of git directory. By default "{{ playbook_dir }}/../../../"
 - GIT_RESET_PATH: A path of git directory, which is reseted for committing. Default value is *platforms/hyperledger-indy/configuration*
 - gitops: *item.gitops* from network.yaml
 - msg: A message for git commit
