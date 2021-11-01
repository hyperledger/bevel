[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/namespace_serviceaccount
This role creates the value files for namespaces, vault-auth, vault-reviewer and clusterrolebinding for each node.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if namespace exists
This task check if the namespace is already created or not.
##### Input Variables

    kind: The path to the directory is specified here.
    *component_ns: The organisation's namespace
    *kubeconfig: The kubernetes config file
    *context: The kubernetes current context

##### Output Variables

    get_namespace: This variable stores the output of check if namespace exists.

#### 2. Create namespace for {{ organisation }}
This task creates value file for namespace by calling create/k8_component role.
##### Input Variables

    component_type: It specifies the type of deployment to be    created. In this case it is "namespace".
    *component_name: The organisation's namespace.
    *release_dir: absolute path for release git directory 
    helm_lint: Either true or false, for linting.

**include_role**: It includes the name of intermediatory role which is required for creating the namespace.

**when**:  It runs when *get_namespace.resources|length* == 0, i.e. the namespace does not exist.

#### 3. Create vault auth service account for {{ organisation }}
This task creates vault auth service account file for organisation by calling create/k8_component role.
##### Input Variables
    
    organisation: Organisation name
    component_type: It specifies the type of deployment to be created. In this case it is "vault-reviewr".
    *component_name: The organisation's namespace.
    *release_dir: absolute path for release git directory.
    helm_lint: Either true or false, for linting.

#### 4. Create vault reviewer for {{ organisation }}
This task creates vault reviewer file for organisation by calling create/k8_component role.
##### Input Variables
    
    organisation: Organisation name
    component_type: It specifies the type of deployment to be created. In this case it is "vault-reviewr".
    *component_name: The organisation's namespace.
    *release_dir: absolute path for release git directory.
    helm_lint: Either true or false, for linting.

#### 5. Create clusterrolebinding for {{ organisation }}
This task creates value file for clusterrolebinding by calling create/k8_component role.
##### Input Variables
    
    organisation: Organisation name
    component_type: It specifies the type of deployment to be created. In this case it is "reviewer_rbac".
    *component_name: The organisation's namespace.
    *release_dir: absolute path for release git directory.
    helm_lint: Either true or false, for linting.

#### 6. Push the created deployment files to repository
This task pushes all the value files created to the git repo by calling git_push role in shared directory.
##### Input Variables    
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
