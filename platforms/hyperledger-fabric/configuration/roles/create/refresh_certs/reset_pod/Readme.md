[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/refresh_certs/reset_pod
This role performs the function of resetting a pod

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

#### 1. Delete release file pod
This task delete the previously created pod release file
##### Input Variables
    *path: Provides the path of the file to delete

#### 2. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"

#### 3. Delete the previous pod HelmRelease
This task delete the previously created pod HelmRelease
##### Input Variables
    *kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *namespace: The namespace of the component.
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
