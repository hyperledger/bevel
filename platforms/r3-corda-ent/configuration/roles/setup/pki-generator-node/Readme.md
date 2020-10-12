## ROLE: setup/pki-generator-node
This role creates deployment file for node-pki chart and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)
#### 1. "Checking if pki-generator job is already completed for the node"
This tasks checks if the pki-generator job is already ran for the node or not
##### Input Variables

    *job_title*: Name of the job
    *component_name*: Name of the component

#### 2. "Create value file for pki generator for the node"
This task creates value file for the chart by consuming the tpl file
#### Input Variables

    *type*: This field is consumed by the helm_component and helm_lint roles for fetching the corresponding tpl and chart for templatizing and linting
    *values_dir*: The directory where the value file is created
    *name*: Name of the peer
    *component_name*: Name of the component
    *charts_dir*: Path to the charts directory

**when**: This task runs when generate-pki has not run

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
