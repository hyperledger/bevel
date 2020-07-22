## ROLE: setup/nmap
This role creates deployment file for nmap and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)
#### 1. "create nmap"
This tasks creates deployment file for nmap node by calling helm_component role.
##### Input Variables

    *component_name: name of the component, fetched from network.yaml
    component_type: type of the component. In this case value is "nmap".
    helm_lint:  flag value to check/uncheck syntax for helm value files
    *nodename: organization name for nmap
    *charts_dir: path to nmap charts, fetched from network.yaml
    *component_auth: name of the component, fetched from network.yaml
    *org: variable contains entire nmap component which is being used in role,fetched from network.yaml
    *release_dir: path where value files are stored inside repository, fetched from network.yaml

#### 2. "Push the created deployment files to repository"
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
