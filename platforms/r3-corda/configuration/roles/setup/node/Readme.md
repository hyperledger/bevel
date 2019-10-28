## ROLE: node
This role creates namespace, vault-auth, vault-reviewer, ClusterRoleBinding, certificates, deployments file for node and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)
#### 1. Creates namespace for node
This tasks creates namespace for node by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'Namespace' for resource type
    *component_name: Contains component name fetched network.yaml

#### 2. Creates vault-auth for node
This tasks creates vault-auth for node by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ServiceAccount' for resource type
    component_name: Contains hardcoded value 'vault-auth'

#### 3. Creates vault-reviewer for node
This tasks creates vault-reviewer for node by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ServiceAccount' for resource type
    component_name: Contains hardcoded value 'vault-reviewer'

#### 4. Creates clusterrolebinding for node
This tasks creates clusterrolebinding for node by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ClusterRoleBinding' for resource type
    *component_name: Contains name of resource, fetched from network.yaml

#### 5. Creates vault access policies for node
This tasks creates valut access policies for node by calling setup/vault_kubernetes role.
##### Input Variables

    *component_name: name of resource, fetched from network.yaml
    *component_path: path of resource, fetched from network.yaml
    *component_auth: auth of resource, fetched from network.yaml

#### 6. Creates image pull secrets
This tasks used to pull the valut secret for node image by calling create/imagepullsecret role.

#### 7. Generate certificates for nodes
This tasks creates certificates required for nodes by calling create/certificates/node role

     *nms_url: ambassador nms uri, fetched from network.yaml
     *nms_cert_file: path contains the certificate of the nms
     *doorman_cert_file: path contains the certificate of the doorman
     *component_name: name of the resource
     *cert_subject: legalName of the node organization

#### 8. create deployment files for h2 for node
This tasks creates deployment files for h2 database for node by calling create/node_component role.
##### Input Variables

    node_type: specifies the type of node
    component_type: specifies the type of resource
    *component_name:  specifies the name of resource
    *release_dir: path to the folder where generated value are getting pushed

#### 9a. Check if the initial-registration files are already created
This task checks if the nodekeystore already created for node by checking in the Vault.
##### Input Variables

    *node.name:  Name of the component which is also tha Vault secret path
    *VAULT_ADDR: url of Vault server
    *VAULT_TOKEN: Token with read access to the Vault server
##### Output Variables

    nodekeystore_result: Result of the call.
    
ignore_errors is true because when first setting up of network, this call will fail.    
    

#### 9. create deployment files for job for node
This tasks creates deployment files for job for node by calling create/node_component role.
##### Input Variables

    node_type: specifies the type of node
    component_type: specifies the type of resource
    *component_name:  specifies the name of resource
    *nms_url: url of nms, fetched from network.yaml
    *doorman_url: url of doorman, fetched from network.yaml
    *release_dir: path to the folder where generated value are getting pushed

This task is called only when nodekeystore_result is failed i.e. only when first time set-up of network.

#### 10. Push the node deployment files to repository
This tasks push the created value files into repository by calling git_push role from shared.
##### Input Variables

    *GIT_DIR: GIT directory path
    *GIT_REPO: Gitops ssh url for flux value files
    *GIT_USERNAME:  Git Service user who has rights to check-in in all branches
    *GIT_PASSWORD: Git Server user password
    *GIT_BRANCH: Git branch where release is being made
    GIT_RESET_PATH: path to specific folder to ignore when pushing files
    msg: commit message

#### 11. checks and creates pod for node db
This tasks checks and creates pod for node db by calling check/node_component role.
##### Input Variables

    component_type: Contains hardcoded value 'POD' for resource type
    *component_name: Contains component name fetched network.yaml

#### 12. checks and creates job for node
This tasks checks and creates job for node by calling check/node_component role.
##### Input Variables

    component_type: Contains hardcoded value 'Job' for resource type
    *component_name: Contains component name fetched network.yaml

This task is called only when nodekeystore_result is failed i.e. only when first time set-up of network.

#### 13. create deployment file for node
This tasks create deployment file for node by calling create/node_component role.
##### Input Variables

    node_type: specifies the type of node
    component_type: specifies the type of resource
    *component_name:  specifies the name of resource
    *nms_url: url of nms, fetched from network.yaml
    *doorman_url: url of doorman, fetched from network.yaml
    *release_dir: path to the folder where generated value are getting pushed

#### 14. push the deployment files for h2, job and node to repository
This tasks push the deployment files for h2, job and node to repository by calling git_push role.
##### Input Variables

    *GIT_DIR: GIT directory path
    *GIT_REPO: Gitops ssh url for flux value files
    *GIT_USERNAME:  Git Service user who has rights to check-in in all branches
    *GIT_PASSWORD: Git Server user password
    *GIT_BRANCH: Git branch where release is being made
    GIT_RESET_PATH: path to specific folder to ignore when pushing files
    msg: commit message
    