## delete/gitops_files
This role deletes all the gitops release files

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Delete release files
This task deletes all the files from the release directory
##### Input Variables
    *release_dir: The release directory path
    state: absent ( This deletes any found result)

#### 2. Git Push
This task pushes the current state to git repo after deleting value files from *release_dir* calling git_push role from shared.
##### Input Variables
    *GIT_DIR: "The path of directory which needs to be pushed"
    *GIT_REPO: "The name of GIT REPO"
    *GIT_USERNAME: "Username of Repo"
    *GIT_PASSWORD: "Password for Repo"
    *GIT_EMAIL: "Email for git config"
    *GIT_BRANCH: "Branch Name"
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    msg: "Message for git commit"
These variables are fetched through network.yaml using *item.gitops*
