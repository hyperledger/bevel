## ROLE: setup/nmap
This role creates deployment file for nmap and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)
#### 1. Check if the networkmap certs are already created
This tasks checks if the networkmap certificates are already created and stored in the vault
##### Input Variables

    VAULT_ADDR: The vault address
    VAULT_TOKEN: Vault root/custom token which has the access to the path
##### Output Variables:

    nmap_certs: Stores the status of the certificates in the vault
ignore_errors is yes because certificates are not created for a fresh network deployment and this command will fail.

#### 2. "waiting for pki-generator job to get complete"
This tasks waits for pki-generator job to be completed calling shared/configuration/roles/check/helm_component role.
##### Input Variables

    component_type: Contains hardcoded value 'Job' for resource type
    namespace: The namespace which has to be checked
    *component_name: Contains name of resource, fetched from network.yaml
    kubernetes: The kubernetes connection files

**when**: It runs when **nmap_certs.failed** variable is true

#### 3. "Create networkmap ambassador certificates"
This tasks creates the Ambassador certificates by calling create/certificates/cenm role.
##### Input Variables

    tlscert_path: Path where the certs will be created
    service_name: Name of the service
    dest_path: Path where the public certs will be stored, fetched from network.yaml

#### 4. Check if the notary-registration is already completed
This tasks checks if the notary files are already created and stored in the vault
##### Input Variables

    VAULT_ADDR: The vault address
    VAULT_TOKEN: Vault root/custom token which has the access to the path
##### Output Variables:

    notary_certs: Stores the status of the certificates in the vault
ignore_errors is yes because certificates are not created for a fresh network deployment and this command will fail.

#### 5. "Create value file for notary registration job"
This tasks creates the notary registration job by calling setup/notary-initial-registration role.

**when**: It runs when **notary_certs.failed** variable is true

#### 6. "waiting for notary initial registration job to complete"
This tasks waits for notary-initial-registration job to be completed calling shared/configuration/roles/check/helm_component role.
##### Input Variables

    component_type: Contains hardcoded value 'Job' for resource type
    namespace: The namespace which has to be checked
    *component_name: Contains name of resource, fetched from network.yaml
    kubernetes: The kubernetes connection files

**when**: It runs when **notary_certs.failed** variable is true

#### 7. "create nmap value files"
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

#### 8. "Push the created deployment files to repository"
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
