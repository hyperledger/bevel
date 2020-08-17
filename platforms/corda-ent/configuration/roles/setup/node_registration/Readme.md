## ROLE: setup/node_registration
This role creates deployment file for node registration and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)
#### 1. "Waiting for the notary pod to come up"
This task waits until the notary is up
##### Input Variables

    namespace: Namespace of the notary
    component_name: Name of the notary
    kubernetes: Variable with k8s configurations

#### 2. "Create value file of db for node registration"
This tasks creates deployment file for node db by calling helm_component role.
##### Input Variables

    component_name: name of the component, fetched from network.yaml
    component_ns: namespace of the component
    values_dir: directory path were value file is created
    name: name of the organization
    charts_dir: chart directory path
    git_url: URL of the git repository
    git_branch: branch of the git repository
    node_name: name of the node
    container_name: image name of the db container
    tcp_port: tcp port of the node
    tcp_targetport: tcp targetport of the node
    web_port: web port of the peer
    web_targetport: web target port of the peer

#### 3. "Create value file for node registration"
This tasks creates deployment file for node registration by calling helm_component role.
##### Input Variables

    git_url: URL of the git repository
    git_branch: branch of the git repository
    charts_dir: chart directory path
    component_name: component name appended with registration
    component_ns: namespace of the component
    node_name: name of the node
    init_container_name: init container image
    values_dir: directory where value files are created
    name: name of the node
    vault_address: vault address
    vault_auth_path: auth path setup in the vault
    vault_cert_secret_prefix: path in the vault where the certificate is created
    vault_node_path: node path in vault
    legal_name: subject of the organization
    tls_cert_crl_issuer: signer subject
    networkmap_url: URL of the networkmap
    doorman_url: URL of the idman
    p2p_port: p2p port of the node
    p2p_address: p2p address of the node
    rpc_port: rpc port of the node
    rpc_admin_port: rpc admin port of the node
    user_name: username, in this case is the node name
    user_password: userpassword, in this case, it is the P appended to the username
    datasource_user: db username
    datasource_password: db password
    datasource_url: db url

#### 4. "Push the created deployment files to repository"
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
