## ROLE: setup/bridge
This role creates deployment file for bridge and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)
#### 1. "Waiting for the notary pod to come up"
This task waits until the notary is up
##### Input Variables

    namespace: Namespace of the notary
    component_name: Name of the notary
    kubernetes: Variable with k8s configurations

#### 2. "create value file for bridge"
This tasks creates deployment file for bridge node by calling helm_component role.
##### Input Variables

    component_name: name of the component, fetched from network.yaml
    name: name of the organization
    corda_service_version: bridge, used to find the float image from helm_component vars
    component_ns: namespace of the component
    git_url: url of the git repo
    git_branch: branch of the git repo
    charts_dir: charts directory
    values_dir: value file directory
    networkmap_name: name of the networkmap
    init_container_name: init container name
    firewall_image: firewall image
    image_pull_secret: image pull secret used to pull images from registry
    vault_addr: vault address
    vault_role: vault role configured
    auth_path: vault auth path
    vault_serviceaccountname: service account linked to the vault
    vault_cert_secret_prefix: path in the vault
    storageclass: name of the storage class
    float_address: address of the float component
    float_port: port of the float component
    float_subject: subject of the float component
    bridge_address: address of the bridge component
    bridge_port: port of the bridge component
    bridge_tunnel_port: tunnel port of the bridge component


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
