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

#### 2. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
