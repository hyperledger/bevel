## ROLE: nms
This role creates namespace, vault-auth, vault-reviewer, ClusterRoleBinding, certificates, deployments file for networkmap service and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)
#### 1. Creates namespace for nms
This tasks creates namespace for nms by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'Namespace' for resource type
    *component_name: Contains component name fetched network.yaml

#### 2. Creates vault-auth for nms
This tasks creates vault-auth for nms by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ServiceAccount' for resource type
    component_name: Contains hardcoded value 'vault-auth'

#### 3. Creates vault-reviewer for nms
This tasks creates vault-reviewer for nms by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ServiceAccount' for resource type
    component_name: Contains hardcoded value 'vault-reviewer'

#### 4. Creates clusterrolebinding for nms
This tasks creates clusterrolebinding for nms by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ClusterRoleBinding' for resource type
    *component_name: Contains name of resource, fetched from network.yaml

#### 5. Creates vault access policies for nms
This tasks creates valut access policies for nms by calling setup/vault_kubernetes role.
##### Input Variables

    *component_name: name of resource, fetched from network.yaml
    *component_path: path of resource, fetched from network.yaml
    *component_auth: auth of resource, fetched from network.yaml

#### 6. Creates image pull secrets
This tasks used to pull the valut secret for nms image by calling create/imagepullsecret role.

#### 7. Certificate generation for nms
This tasks creates certificate for nms by calling create/certificates/nms role.
##### Input Variables

    *root_subject: legalName of the organization, fetched from network.yaml
    *cert_subject: legalName of the organization, fetched from network.yaml
    *nms:  legalName of nms organization, fetched from network.yaml
    *nms: legalName of nms organization, fetched from network.yaml

#### 8. Create deployment file for nms mongodb node
This tasks creates deployment file for nms mongodb node by calling create/k8_component role.
##### Input Variables

    component_name: name of the component
    component_type: type of the component. In this case value is "mongodb".
    helm_lint:  flag value to check/uncheck syntax for helm value files
    *nodename: organization name for nms
    *charts_dir: path to nms charts
    *component_auth: name of the component
    *org: variable contains entire nms component which is being used in role
    *release_dir: path where value files are stored inside repository

#### 9. Create deployment file for nms node
This tasks creates deployment file for nms node by calling create/k8_component role.
##### Input Variables

    component_name: name of the component
    component_type: type of the component. In this case value is "nms".
    helm_lint:  flag value to check/uncheck syntax for helm value files
    *nodename: organization name for nms
    *charts_dir: path to nms charts
    *component_auth: name of the component
    *org: variable contains entire nms component which is being used in role
    *release_dir: path where value files are stored inside repository

#### 10. Push the nms deployment files to repository
This tasks push the created value files into repository by calling git_push from shared.
##### Input Variables

    *GIT_DIR: GIT directory path
    *GIT_REPO: Gitops ssh url for flux value files
    *GIT_USERNAME:  Git Service user who has rights to check-in in all branches
    *GIT_PASSWORD: Git Server user password
    *GIT_BRANCH: Git branch where release is being made
    GIT_RESET_PATH: path to specific folder to ignore when pushing files
    msg: commit message

    