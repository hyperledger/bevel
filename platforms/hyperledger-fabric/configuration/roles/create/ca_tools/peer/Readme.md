[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: ca-tools/peer
This role creates helm release value file for the deployment of CA Tools CLI and generate crypto for peer.

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

#### 2. Reset ca-tools pod
This task reset ca-tools pod
##### Input Variables
    *pod_name: Provide the name of the pod
    *file_path: Provide the release file path
    *gitops_value: *item.gitops* from network.yaml
    *component_ns: Provide the namespace of the resource
    *kubernetes: *item.k8s* from network.yaml
    *hr_name: Provides the name of the helmrealse
**when**: It runs Only when *refresh_cert* is defined and *refresh_cert* is true.

#### 3. Call delete_old_certs for delete the previous certificates
This task delete the previous certificates
##### Input Variables
    *org_name: Provide the name of the organization
**when**: It runs Only when *add_peer* is defined and *add_peer* is true or *refresh_cert* is defined and *refresh_cert* is true.

#### 4. Get Orderer certificates
This tasks Ensure orderer-certificate file is present.
##### Input Variables
**include_tasks**: It includes the name of intermediatory task which is required for copy orderers certificate, here `nested_orderers.yaml`.
**loop**: loops over orderer list fetched from *{{ network.orderers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.                
    loop_var: loop variable used for iterating the loop.

#### 5. Create the certs directory if it does not exist
This task create the certs directory if it is not present 
##### Input Variables
    path: The path where to check is specified here.
    state: Type i.e. directory.

#### 6. Copy the tls orderers certs to the chart catools directory
This task copies orderers certs from the path provided in network.yaml to ca-tools chart directory
##### Input Variables
    *orderer.name: The orderer name.
    *orderer.certificate: The certificate file path for the orderer.
**loop_control**: Specify conditions for controlling the loop.                
    loop_var: loop variable used for iterating the loop.

#### 7. Create CA-tools Values file
This task creates the CA-tools value files for peer.
##### Input Variables
    *name: The name of resource
    *type: "ca-tools"
    *org_name: "Name of the organization"
    *component_type: "Type of the organization (orderer or peer)"
    *vault: "Vault Details"
    *external_url_suffix: "External url of the organization"
    *component_subject: "Subject of the organization"
    *cert_subject: Contains subject name Fetched from network.yaml
    *component_country: "Country of the organization"
    *component_state: "State of the organization"
    *component_location: "Location of the organization"
    *ca_url: "Ca url of the organization"
    *refresh_cert_value: "Indicates if it is necessary to refresh user certificates"
    *proxy: "The proxy/ingress provider"
    *git_url: "The URL of git repo"
    *git_branch: "Git repo branch name"
    *charts_dir: "The path of chart files"
    peers_list: "Provides the names and states of the peers"
    orderers_list: "orderer's names"
    peer_count: "total number of peers"
  
**include_role** : It includes the name of intermediatory role which is required for creating the CA Tools value file.

#### 8. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"

#### 9. Check if crypto materials exists in vault.
This task Check if crypto materials exists in vault.
##### Input Variables
    *namespace: "Namespace of org , Format: {{ item.name |lower }}-net"
    *vault: "Vault Details"
    *component_type: "Type of org"
**include_role**: It includes the name of intermediatory role which is required for creating the secrets, here `crypto_materials`.

#### 10. Create the Ambassador credentials
This task creates the Ambassador TLS credentials
##### Input Variables
    *namespace: "Namespace of org , Format: {{ item.name |lower }}-net"
    *vault: "Vault Details"
    *kubernetes: "{{ item.k8s }}"
**include_role**: It includes the name of intermediatory role which is required for creating the secrets, here `k8s_secrets`.
**when**: Condition is specified here, runs only when *network.env.proxy* is ambassador and *peer.peerstatus* is not defined or *peer.peerstatus* is new

#### 11. Copy msp cacerts to given path
This task copy the peer certificate to the path provided in network.yaml
##### Input Variables
    *org_name: Name of Item
    *approvers: {{ channel.endorsers }}
**include_tasks**: It includes the name of intermediatory task which is required for copy msp cacerts, here `nested_endorsers.yaml`.
**loop**: loops over channels list fetched from *{{ network.channels }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 12. Copy the msp admincerts from vault
This task copies the msp admincerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is not none.

#### 13. Copy the msp cacerts from vault
This task copies the msp cacerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is not none.

#### 14. Copy the msp tlscacerts from vault
This task copies the msp tlscacerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is not none.

#### 15. Copy the msp cacerts from vault
This task copies the msp cacerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is none.

#### 16. Copy the msp tlscacerts from vault
This task copies the msp tlscacerts from vault when proxy is none
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: It runs Only when *network.env.proxy* is none.

#### 17. Get msp config.yaml file
This task gets msp config.yaml file from vault
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.

### delete_old_certs.yaml
### Tasks
#### 1. Delete Crypto for peers
This task deletes crypto materials from vault
##### Input Variables
    *component_name: The name of the resource
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands delete crypto materials from vault.
**loop**: loops over peers list fetched from *{{ item.services.peers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.
**when**: It runs Only when *component_type* is peer.

### nested_orderers.yaml
### Tasks
#### 1. Check orderer-certificate file exists
This tasks Check orderer-certificate file exists
##### Input Variables
    *orderer.certificate: Path where the certificate is stored.

##### Output Variables
    orderer_file_result: Stores the result of Orderer file check query.

#### 2. Check if Orderer certs already created
This tasks Check if Orderer certs exists in vault. If yes, get the certificate
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of the resource.

#### 3. Save Orderer certs if already created
 This tasks Ensure orderer-tls directory is present in build.
##### Input Variables
    *orderer.org_name: The org name of the orderer.
**local_action**:  A shorthand syntax that you can use on a per-task basis
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.
**when**: It runs Only when *orderer_certs_result.results[0]* is true.
