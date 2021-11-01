[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/operations_console
 This role creates helm value files for deploying Fabric Operations Console

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Create Value files for Operations Console
This task calls helm_component role to generate the helm value file from the templates
##### Input Variables
    *name: Name of the organization
    *type: "operations_console"
    *component_name: operations_console

#### 2. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
