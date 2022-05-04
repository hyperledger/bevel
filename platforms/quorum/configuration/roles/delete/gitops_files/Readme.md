[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## delete/gitops_files
This role deletes all the gitops release files
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Delete release files
This task deletes all the files from the release directory
##### Input Variables
    *release_dir: The release directory path
    state: absent ( This deletes any found result)

#### 2. Delete release files
This task deletes all the files from the release directory
##### Input Variables
    *release_dir_ns: The release directory path with -quo suffix
    state: absent ( This deletes any found result)

#### 2. Git Push
This task pushes the current state to git repo after deleting value files from *release_dir* calling git_push role from shared.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
