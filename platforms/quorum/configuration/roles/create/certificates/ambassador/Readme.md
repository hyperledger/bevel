[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/certificates/ambassador
This role generates certificates for ambassador and places them in vault. Certificates are created using openssl.This also creates the Kubernetes secrets

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Call nested_main for each node in an organisation
This task calls nested_main
##### Input Variables
    *node_name: Name of the node
**include_tasks**: It includes the name of intermediary task which is required for creating the ambassador certificates.
**loop**: loops over all the node in an organisation
**loop_control**: Specifies the condition for controlling the loop.

    loop_var: loop variable used for iterating over the loop.

---------------

### nested_main.yaml
This task initaiates the nested_main role for each node in the organisation
### Tasks
#### 1. Ensure rootca dir exists
This task check for the Root CA dir alreasy created or not, if not then creates one.
##### Input variables
    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.

#### 2. Ensure ambassador tls dir exists
This tasks checks if the ambassador tls dir already created or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.

#### 2. Create ambassador certs helmrelease file
This task creates ambassador certs helmrelease file by calling the create/helm_component role
##### Input Variables

    *component_name: "The name of the component"
    *name: "{{ node_name }}"
    *type: "certs-ambassador-quorum"

**include_role**: It includes the name of intermediatory role which is required for creating the helm value file, here create/helm_component

#### 3. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    msg: "Message for git commit"
**include_role**: It includes the name of intermediatory role which is required for pushing  the value file to git repository.

#### 4. Create the Ambassador credentials
This task creates the Ambassador TLS credentials
##### Input Variables
    *namespace: "Namespace of org , Format: {{ organizationItem.name | lower }}"
    *vault: "Vault Details"
    *kubernetes: "{{ organizationItem.k8s }}"
**include_role**: It includes the name of intermediatory role which is required for creating the secrets, here `k8s_secrets`.

#### Note: 
vars folder has environment variable for ambassador role.
