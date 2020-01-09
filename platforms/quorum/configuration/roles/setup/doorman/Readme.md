## ROLE: doorman
This role creates namespace, vault-auth, vault-reviewer, ClusterRoleBinding, certificates, deployments file for doorman and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)
#### 1. Creates namespace for doorman
This tasks creates namespace for doorman by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'Namespace' for resource type
    *component_name: Contains component name fetched network.yaml

#### 2. Creates vault-auth for doorman
This tasks creates vault-auth for doorman by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ServiceAccount' for resource type
    component_name: Contains hardcoded value 'vault-auth'

#### 3. Creates vault-reviewer for doorman
This tasks creates vault-reviewer for doorman by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ServiceAccount' for resource type
    component_name: Contains hardcoded value 'vault-reviewer'

#### 4. Creates clusterrolebinding for doorman
This tasks creates clusterrolebinding for doorman by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ClusterRoleBinding' for resource type
    *component_name: Contains name of resource, fetched from network.yaml

#### 5. Creates vault access policies for doorman
This tasks creates valut access policies for doorman by calling setup/vault_kubernetes role.
##### Input Variables

    *component_name: name of resource, fetched from network.yaml
    *component_path: path of resource, fetched from network.yaml
    *component_auth: auth of resource, fetched from network.yaml

#### 6. Creates image pull secrets
This tasks used to pull the valut secret for doorman image by calling create/imagepullsecret role.

#### 7. certificate generation for doorman
This tasks creates certificate for doorman by calling create/certificates/doorman role.
##### Input Variables

    *root_subject: legalName of the organization, fetched from network.yaml
    *cert_subject: legalName of the organization, fetched from network.yaml
    *doorman_subject:  legalName of doorman organization, fetched from network.yaml
    *doorman_cert_subject: legalName of doorman organization, fetched from network.yaml

#### 8. Create deployment file for doorman mongodb node
This tasks creates deployment file for doorman mongodb node by calling create/k8_component role.
##### Input Variables

    component_name: name of the component
    component_type: type of the component. In this case value is "mongodb".
    helm_lint:  flag value to check/uncheck syntax for helm value files
    *nodename: organization name for doorman, fetched from network.yaml
    *charts_dir: path to doorman charts, fetched from network.yaml
    *component_auth: name of the component, fetched from network.yaml
    *org: variable contains entire doorman component which is being used in role
    *release_dir: path where value files are stored inside repository, fetched from network.yaml

#### 9. Create deployment file for doorman node
This tasks creates deployment file for doorman node by calling create/k8_component role.
##### Input Variables

    *component_name: name of the component, fetched from network.yaml
    component_type: type of the component. In this case value is "doorman".
    helm_lint:  flag value to check/uncheck syntax for helm value files
    *nodename: organization name for doorman
    *charts_dir: path to doorman charts, fetched from network.yaml
    *component_auth: name of the component, fetched from network.yaml
    *org: variable contains entire doorman component which is being used in role,fetched from network.yaml
    *release_dir: path where value files are stored inside repository, fetched from network.yaml

#### 10. Push the doorman deployment files to repository
This tasks push the created value files into repository by calling git_push role from shared.
##### Input Variables

    *GIT_DIR: GIT directory path
    *GIT_REPO: Gitops ssh url for flux value files
    *GIT_USERNAME:  Git Service user who has rights to check-in in all branches
    *GIT_PASSWORD: Git Server user password
    *GIT_BRANCH: Git branch where release is being made
    GIT_RESET_PATH: path to specific folder to ignore when pushing files
    msg: commit message

    