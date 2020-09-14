## ROLE: setup/notary
This role creates deployments file for notary and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)

#### 1.Check if nodekeystore already created
This task checks if the nodekeystore already created for node by checking in the Vault.
##### Input Variables

    *org.services.notary.name:  Name of the component which is also tha Vault secret path
    *VAULT_ADDR: url of Vault server
    *VAULT_TOKEN: Token with read access to the Vault server
##### Output Variables

    nodekeystore_result: Result of the call.
    
ignore_errors is true because when first setting up of network, this call will fail.   

#### 2. 'Create notary initial-registration job file'
This tasks creates deployment files for job for notary by calling create/node_component role.
##### Input Variables

    type: specifies the type of node
    *component_name:  specifies the name of resource
    *idman_name: url of doorman, fetched from network.yaml
    *networkmap_url: url of nms, fetched from network.yaml
    *release_dir: path to the folder where generated value are getting pushed

This task is called only when nodekeystore_result is failed i.e. only when first time set-up of network.

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
