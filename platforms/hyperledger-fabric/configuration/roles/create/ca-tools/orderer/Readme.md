[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: ca-tools/orderer
This role creates helm release value file for the deployment of CA Tools CLI and generate crypto for orderer.

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

#### 2. Create CA-tools Values file
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
    *orderers_list: "orderer's names"
    
**include_role** : It includes the name of intermediatory role which is required for creating the CA Tools value file.

#### 3. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"

#### 4. Check if crypto materials exists in vault.
This task Check if crypto materials exists in vault.
##### Input Variables
    *namespace: "Namespace of org , Format: {{ item.name |lower }}-net"
    *vault: "Vault Details"
    *component_type: "Type of org"
**include_role**: It includes the name of intermediatory role which is required for creating the secrets, here `crypto_materials`.

#### 5. Create the Ambassador credentials
This task creates the Ambassador TLS credentials
##### Input Variables
    *namespace: "Namespace of org , Format: {{ item.name |lower }}-net"
    *vault: "Vault Details"
    *kubernetes: "{{ item.k8s }}"
**include_role**: It includes the name of intermediatory role which is required for creating the secrets, here `k8s_secrets`.
**when**: Condition is specified here, runs only when *network.env.proxy* is ambassador

#### 6. Copy the msp admincerts from vault
This task copies the msp admincerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is not none.

#### 7. Copy the msp cacerts from vault
This task copies the msp cacerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is not none.

#### 8. Copy the msp tlscacerts from vault
This task copies the msp tlscacerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is not none.

#### 9. Copy the msp cacerts from vault
This task copies the msp cacerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is none.

#### 10. Copy the msp tlscacerts from vault
This task copies the msp tlscacerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is none.

#### 11. Copy the tls server.crt from vault
This task copies the tls server.crt from vault to the build directory
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**loop**: loops over orderers list fetched from *{{ item.services.orderers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 12. Create the certs directory if it does not exist
This task create the certs directory if it is not present 
##### Input Variables
    path: The path where to check is specified here.
    state: Type i.e. directory.
**loop**: loops over orderers list fetched from *{{  network.orderers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

**when**: It runs Only when *add_new_org* is false and *add_peer* is not defined.

#### 13. Copy the msp cacerts from vault
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
