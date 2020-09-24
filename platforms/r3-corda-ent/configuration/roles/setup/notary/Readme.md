## ROLE: setup/notary
This role creates deployments file for notary and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)

#### 1. 'Create notary db deployment file'
This tasks creates deployment files for notary db by calling helm_componet role.
##### Input Variables

    *component_name:  specifies the name of resource
    *component_ns: specifies the namespace
    type: specifies the type of node
    *values_dir: path to the folder where generated value are getting pushed
    *name: organization  name
    *charts_dir: directory where charts are stored
    *git_url: 
    *git_branch: branch where values file will be pushed.
    *node_name: notary name
    *image_pull_secret: 
    storageclass: storage class that will be used for creating pvcs.
    *container_name:
    *networkmap_url: url of nms, fetched from network.yaml

#### 2. 'Create notary  deployment file'
This tasks creates deployment files for notary db by calling helm_componet role.
##### Input Variables

    *component_name:  specifies the name of resource
    *component_ns: specifies the namespace
    type: specifies the type of node
    *values_dir: path to the folder where generated value are getting pushed
    *name: organization  name
    *charts_dir: directory where charts are stored
    *git_url: 
    *git_branch: branch where values file will be pushed.
    *node_name: notary name
    *image_pull_secret: 
    storageclass: storage class that will be used for creating pvcs.
    *container_name:
    *networkmap_url: url of nms, fetched from network.yaml


#### 3. "Push the created deployment files to repository"
This tasks push the created value files into repository by calling git_push role from shared.
##### Input Variables

    *GIT_DIR: GIT directory path
    *GIT_REPO: Gitops ssh url for flux value files
    *GIT_USERNAME:  Git Service user who has rights to check-in in all branches
    *GIT_PASSWORD: Git Server user password
    *GIT_EMAIL: Email for git config
    *GIT_BRANCH: Git branch where release is being made
    GIT_RESET_PATH: path to specific folder to ignore when pushing files
    msg: commit message
