[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/storageclass
This role creates the storageclass value file for nodes

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if storageclass exists
This task check if the storageclass exists.
##### Input Variables

    kind: StorageClass
    *name: storageclass name
    *kubeconfig: The kubernetes config file
    *context: The kubernetes current context

##### Output Variables

    storageclass_state: This variable stores the output of check if storageclass exists.

#### 2. Create storageclass
This task creates value file for storageclass by calling create/k8_component role.
##### Input Variables

    *component_name: The storageclass name.
    *component_type: It specifies the type of deployment to be created. In this case it is "<cloudprovider>-storageclass"
    helm_lint: This is a flag to run helm_list module. "false" in this case because storageclass is not a helm chart.
    *release_dir: absolute path for release git directory

**when**:  It runs when *storageclass_state.resources|length* == 0, i.e. storageclass doen not exists .

#### 3. Push the created deployment files to repository
This task pushes the generated value file to gitops repository by calling shared/configuration/roles/git_push role.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"

#### 4. Wait for Storageclass creation for {{ component_name }}
This task checks storageclass is created or not by calling role check/k8_component role. 
##### Input Variables

    component_type: The storageclass name.
    *component_name: The storageclass resource name.
    *kubeconfig: The kubernetes config file.
    *context: The kubernetes current context.

**when**:  It runs when *storageclass_state.resources|length* == 0, i.e. storageclass did not exists before.
