[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: ca-tools
This role creates helm release value file for the deployment of CA Tools CLI and generate crypto materials.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check CA-server is available
This tasks checks if CA server is available or not and waits for the CA server to be available.
##### Input Variables


    kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *namespace: The namespace of the component.
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables
    get_ca: This variable stores the output of ca server check query.
    
  **until**: This condition checks until *get_ca.resources* exists
  **retries**: No of retries
  **delay**: Specifies the delay between every retry

#### 2. Check that orderer-certificate File exists
 This tasks Ensure orderer-certificate file is present.
##### Input Variables
    *orderer.certificate: The certificate file path for the orderer.
**loop_control**: Specify conditions for controlling the loop.                
    loop_var: loop variable used for iterating the loop.

**failed_when**: This task fails when add_new_org is true and the file(s) does not exist. For adding a new org the orderer certificate is mandatory.

#### 3. Check if Orderer certs already created
This tasks Check if Orderer certs exists in vault. If yes, get the certificate
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of the resource.

##### Output Variables
    orderer_certs_result: Stores the result of Orderer cert check query.
**environment** : It includes the list of environment variables.

**shell** : This command get certificates from vault.

**vault** : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml)

**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 4. Save Orderer certs if already created
 This tasks Ensure orderer-tls directory is present in build.
##### Input Variables
    *orderer.org_name: The org name of the orderer.
**local_action**:  A shorthand syntax that you can use on a per-task basis
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.
**when**: It runs Only when *orderer_certs_result.results[0]* is true.

#### 5. Create the certs directory if it does not exist
This task create the certs directory if it is not present 
##### Input Variables
    path: The path where to check is specified here.
    state: Type i.e. directory.
**when**: It runs Only when item.priority* is standard.

#### 6. Copy the tls orderers certs to the chart catools directory
This task copies orderers certs from the path provided in network.yaml to ca-tools chart directory
##### Input Variables
    *orderer.name: The orderer name.
    *orderer.certificate: The certificate file path for the orderer.
**loop_control**: Specify conditions for controlling the loop.                
    loop_var: loop variable used for iterating the loop.
**when**: It runs Only when *item.priority* is standard.

#### 7. Count new peers
This task stores in a list the new peers to add in an existing network
##### Input Variables
    *peer.name: The peer name.
**loop_control**: Specify conditions for controlling the loop.                
    loop_var: loop variable used for iterating the loop.
**when**: It runs Only when *item.services.peers* is defined, its length is greater than zero, *peer.peerstatus* is defined and *peer.peerstatus is new, *add_peer* is defined and *add_peer* is true.

#### 8. Delete release file CA-Tools
This task delete the previously created ca-tools release file
##### Input Variables
    *values_dir: Directory where the file is stored.
    *name: "Namespace of org , Format: {{ item.name |lower }}-net"
    *component_name: The namespace
**when**: It runs Only when *item.services.peers* is defined, its length is greater than zero, *add_peer* is defined and *add_peer* is true.

#### 9. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
**when**: It runs Only when *item.services.peers* is defined, its length is greater than zero, *add_peer* is defined and *add_peer* is true.

#### 10. Delete the previous CA-Tools HelmRelease
This task delete the previously created ca-tools HelmRelease
##### Input Variables
    *component_name: "Namespace of org , Format: {{ item.name |lower }}-net"
    *kubernetes: "{{ item.k8s }}"
**when**: It runs Only when *item.services.peers* is defined, its length is greater than zero, *add_peer* is defined and *add_peer* is true.
        
#### 11. Create CA-tools Values file
This task creates the CA-tools value files for orderer.
##### Input Variables
    *name: The name of resource
    *type: "ca-tools"
    *org_name: "Name of the organization in lowercase"
    *component_type: "Type of the organization (orderer or peer)"
    *vault: "Vault Details"
    *external_url_suffix: "External url of the organization"
    *component_subject: "Subject of the organization"
    *cert_subject: Contains subject name Fetched from network.yaml
    *component_country: "Country of the organization"
    *component_state: "State of the organization"
    *component_location: "Location of the organization"
    *ca_url: "Ca url of the organization"
    *proxy: "The proxy/ingress provider"
    *git_url: "The URL of git repo"
    *git_branch: "Git repo branch name"
    *charts_dir: "The path of chart files"
    *orderers_list: "Provides orderer's names"
    *peers_list: "Provides the names and states of the peers"
    *orderers_network_list: "Provides the name of the orderers and the name of their organization"
    *peer_count: "total number of peers"
    *new_peer_count: "total number of new peers"
    *add_peer_value: "Provides the value of add_peer"
    *priority: "Provides the priority of organization"
    
**include_role** : It includes the name of intermediatory role which is required for creating the CA Tools value file.

#### 12. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"

#### 13. Check if crypto materials exists in vault.
This task Check if crypto materials exists in vault.
##### Input Variables
    *namespace: "Namespace of org , Format: {{ item.name |lower }}-net"
    *vault: "Vault Details"
    *component_type: "Type of org"
**include_role**: It includes the name of intermediatory role which is required for creating the secrets, here `crypto_materials`.

#### 14. Create the Ambassador credentials for orderers
This task creates the Ambassador TLS credentials
##### Input Variables
    *namespace: "Namespace of org , Format: {{ item.name |lower }}-net"
    *vault: "Vault Details"
    *kubernetes: "{{ item.k8s }}"
**include_role**: It includes the name of intermediatory role which is required for creating the secrets, here `k8s_secrets`.
**when**: Condition is specified here, runs only when *network.env.proxy* is ambassador, *item.services.orderers* is defined and its length is greater than zero.

#### 15. Create the Ambassador credentials for peers
This task creates the Ambassador TLS credentials
##### Input Variables
    *namespace: "Namespace of org , Format: {{ item.name |lower }}-net"
    *vault: "Vault Details"
    *kubernetes: "{{ item.k8s }}"
**include_role**: It includes the name of intermediatory role which is required for creating the secrets, here `k8s_secrets`.
**when**: Condition is specified here, runs only when *network.env.proxy* is ambassador, *peer.peerstatus* is not defined or *peer.peerstatus* is new, *item.services.peers* is defined and its length is greater than zero 

#### 16. Copy the msp admincerts from vault
This task copies the msp admincerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is not none.

#### 17. Copy the msp cacerts from vault
This task copies the msp cacerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is not none.

#### 18. Copy the msp tlscacerts from vault
This task copies the msp tlscacerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is not none.

#### 19. Copy the msp cacerts from vault
This task copies the msp cacerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is none.

#### 20. Copy the msp tlscacerts from vault
This task copies the msp tlscacerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is none.

#### 21. Copy the tls server.crt from vault
This task copies the tls server.crt from vault to the build directory
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**loop**: loops over orderers list fetched from *{{ item.services.orderers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 22. Create the certs directory if it does not exist
This task create the certs directory if it is not present 
##### Input Variables
    path: The path where to check is specified here.
    state: Type i.e. directory.
**loop**: loops over orderers list fetched from *{{  network.orderers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

**when**: It runs Only when *add_new_org* is false and *add_peer* is not defined.

#### 23. Copy the msp cacerts from vault
This task copies the msp cacerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *orderer.name: "orderer's name"
    *orderer.certificate: The certificate file path for the orderer.
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**loop**: loops over orderers list fetched from *{{  network.orderers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

**when**: It runs Only when *add_new_org* is false and *add_peer* is not defined.

#### 24. Get msp config.yaml file
This task gets msp config.yaml file from vault
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.

#### 25. Create user crypto
This task create user crypto 
##### Input Variables
    *org_name: "Name of the organization"
    *subject: "Subject of the organization"
    *ca_url: "Ca url of the organization"
    *users: "Provides users"
    *proxy: "The proxy/ingress provider"
**include_role**: It includes the name of intermediatory role which is required for creating user crypto, here `create/users`.
**when**: It runs Only when *item.users* is defined.
