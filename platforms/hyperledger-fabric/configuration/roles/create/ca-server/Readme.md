## ROLE: ca-server
This role generate initial CA certs and push them to vault. Also, it creates the helm release value file for Certificate Authority (CA)

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if ca certs already created
This tasks checks if the CA certificates are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
##### Output Variables

    vault_ca_result: This variable stores the output of ca certificates check query.

#### 2. Ensures crypto dir exists
This task creates the folder to store crypto material

##### Input Variables
    path: The path where to check/create is specified here.
    recurse: Yes/No to recursively check inside the path specified. 

#### 2.a Get ca certs and key
This tasks gets the existing CA certs and key from the Vault server.

#### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml

**when**: It runs when *vault_ca_result*.failed == False, i.e. CA certs are already present. 

#### 3. Generate the CA certificate
This task generates initial CA certificates.
##### Input Variables
    *component_name: The name of resource
    *component_type: The type of resource

**shell**: It goes to the specified directory and generates certificates using open ssl commands.
**when**: It runs when *vault_ca_result*.failed == True, i.e. CA certs are not present.

#### 4. Copy the crypto material to Vault
This task copy the CA certificates generated above, to the Vault.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
    *component_type: The type of resource
**shell**: It writes the generated certificates to the vault.
**when**:  It runs when *vault_ca_result*.failed == True, i.e. CA certs are not present. 

#### 5. Check if ca admin credentials are already created
This tasks checks if the CA admin credentials are already created or not.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
##### Output Variables
    vault_caadmin_result: This variable stores the output of ca admin credentials check query.

#### 6. Write the ca server admin credentials to Vault
This task writes the ca server admin credentials to Vault
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
    *component: The type of resource
**shell**: It writes the generated credentials to the vault.
**when**:  It runs when *vault_caadmin_result*.failed == True, i.e. CA admin credentials are not present. 

#### 7. Check Ambassador cred exists
This tasks check if the Check Ambassador credentials exists or not.
##### Input Variables

    kind: This defines the kind of Kubernetes resource
    namespace: The namespace of the component
    *name: Name of the component 
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    get_secret: This variable stores the output of Ambassador credentials check query.
    
#### 8. Create the Ambassador credentials
This task creates the Ambassador TLS credentials.
##### Input Variables
    *component_name: The name of resource
    *component_type: The type of resource
    *kubernetes.config_file: The config file of kubernetes cluster.

**shell**: The specified command creates ambassador credentials.
**when**: It runs when *get_secret.resources* are not found.

#### 9. Create CA server values for Orderer
This task creates the CA value file for Orderer
##### Input Variables
    *name: The name of resource
    type: "ca-orderer"
    *git_url: "The URL of git repo"
    *git_branch: "Git repo branch name"
    *charts_dir: "The path of chart files"
    
**include_role** : It includes the name of intermediatory role which is required for creating the CA value file for orderer.
**when**: Condition is specified here, runs only when *component_type* is orderer.

#### 10. Create CA server values for Organisations
This task creates the CA value file for organisations
##### Input Variables
    *name: The name of resource
    type: "ca-peer"
    *git_url: "The URL of git repo"
    *git_branch: "Git repo branch name"
    *charts_dir: "The path of chart files"

**include_role** : It includes the name of intermediatory role which is required for creating the CA value file for orderer.
**when**: Condition is specified here, runs only when *component_type* is peer.

#### 11. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
