[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: ca-server
This role generate initial CA certs and push them to vault. Also, it creates the helm release value file for Certificate Authority (CA)

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Ensures crypto dir exists
This task creates the folder to store crypto material

##### Input Variables
    path: The path where to check/create is specified here.
    recurse: Yes/No to recursively check inside the path specified. 

#### 2. Create ca-server secrets tokens
This task creates secrets for the root token and the reviewer token
##### Input Variables
    *namespace: "Namespace of org , Format: {{ item.name |lower }}-net"
    *vault: "Vault Details"
    *kubernetes: "{{ item.k8s }}"
**include_role**: It includes the name of intermediatory role which is required for creating the secrets, here `k8s_secret`.

#### 3. Create value file for generate-cacerts
This tasks generates cacerts helmrelease file.
##### Input Variables
    *name: "Name of the organisation"
    *type: "cacerts_job"
    *component_name: Name of the component, "{{ item.name | lower }}--cacerts-job"
    *component_ns: "Namespace of organisation , Format: {{ item.name | lower}}-net"
    *subject: "Subject of the services ca organization's, {{ ca.subject }}"
    *git_url: "Git SSH url"
    *git_branch: "Git Branch Name"
    *charts_dir: "Path of Charts Directory"
    *vault: "Vault Details"
    *values_dir: "Destination directory"
**include_role**: It includes the name of intermediatory role which is required for creating the helm value file, here `helm_component`.

#### 4. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GGIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"

#### 5. Create the Ambassador credentials
This task creates the Ambassador TLS credentials
##### Input Variables
    *namespace: "Namespace of org , Format: {{ item.name |lower }}-net"
    *vault: "Vault Details"
    *kubernetes: "{{ item.k8s }}"
**include_role**: It includes the name of intermediatory role which is required for creating the secrets, here `k8s_secret`.

#### 6. Create CA server values for Orderer
This task creates the CA value file for Orderer
##### Input Variables
    *name: The name of resource
    type: "ca-orderer"
    *git_url: "The URL of git repo"
    *git_branch: "Git repo branch name"
    *charts_dir: "The path of chart files"
    
**include_role** : It includes the name of intermediatory role which is required for creating the CA value file for orderer.
**when**: Condition is specified here, runs only when *network.env.proxy* is ambassador.

#### 7. Create CA server values for Organisations
This task creates the CA value file for organisations
##### Input Variables
    *name: The name of resource
    type: "ca-peer"
    *git_url: "The URL of git repo"
    *git_branch: "Git repo branch name"
    *charts_dir: "The path of chart files"

**include_role** : It includes the name of intermediatory role which is required for creating the CA value file for orderer.
**when**: Condition is specified here, runs only when *component_type* is peer.

#### 8. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
