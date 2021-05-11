## ROLE: crypto/peer
This role generates crypto material for organisations.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if CA-tools are running
This task checks if CA-tools pod are running.
##### Input Variables

    kind: This defines the kind of Kubernetes resource
    *namespace: Namespace of the component 
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
    label_selectors:
      - name = ca-tools
    field_selectors:
      - status.phase=Running    
##### Output Variables

    ca_tools: This variable stores the output of query.
	
  **until**: This condition checks until *ca_tools.resources* variable exists

  **retries**: No of retries

  **delay**: Specifies the delay between every retry

#### 2. Ensure ca directory exists
This task ensures that ca directory is present in build.
##### Input Variables
    path: The path where to check is specified here.
    recurse: Yes/No to recursively check inside the path specified. 
    state: Type i.e. directory.


#### 3. Check if ca certs already created
This task check if CA certs exists in vault, if not this should fail. If yes, get the certificate.
##### Input Variables
    *component_name: The name of the component
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**environment** : It includes the list of environment variables.

**shell** : This command check if CA certs exists in vault, if yes, it moves the certificate to the specified directory.

**vault** : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 

#### 4. Check if ca key already created
This task check if CA key exists in vault, if not this should fail. If yes, get the certificate.
##### Input Variables
    *component_name: The name of the component
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**environment** : It includes the list of environment variables.

**shell** : This command check if CA key exists in vault, if yes, it moves the key to the specified directory.

**vault** : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 

#### 5. Call peercheck.yaml for each peer
 This task calls peercheck.yaml file for each peer. 
 ##### Input Variables
    *services.peers: The peer data from network.yaml
**include_tasks**: This task file checks Vault and gets MSP files if already created.

**loop_control**: Specify conditions for controlling the loop.                
    loop_var: loop variable used for iterating the loop.

#### 6. Call common.yaml for each peer
 This task calls common.yaml file for each peer
 ##### Input Variables
    *services.peers: The peer data from network.yaml
**include_tasks**: This task file checks and creates all necessary file paths for crypto generation.

#### 7. Call peer.yaml for each peer
 This task calls peer.yaml file for each peer
 ##### Input Variables
    *services.peers: The peer data from network.yaml
**include_tasks**: This task file writes all crypto to Vault and also generates proxy certificates.

**loop_control**: Specify conditions for controlling the loop.                
    loop_var: loop variable used for iterating the loop.
    
#### 8. Create the MSP config.yaml file for orgs
This task creates the MSP config.yaml file for organizations
##### Input Variables
    *component_name: The name of the resource
    
**shell** : The specified command creates the MSP config.yaml file for organizations

#### 9. Check that orderer-certificate File exists
 This tasks Ensure orderer-certificate file is present.
##### Input Variables
    *orderer.certificate: The certificate file path for the orderer.
**loop_control**: Specify conditions for controlling the loop.                
    loop_var: loop variable used for iterating the loop.

**failed_when**: This task fails when add_new_org is true and the file(s) does not exist. For adding a new org the orderer certificate is mandatory.

#### 10. Ensure orderer-cert directory exists
This tasks ensures that the orderer-cert directory exists
##### Input Variables
    *orderer.org_name: The org name of the orderer.
    path: The path where to check is specified here.
    recurse: Yes/No to recursively check inside the path specified. 
    state: Type i.e. directory.
**loop_control**: Specify conditions for controlling the loop.                
    loop_var: loop variable used for iterating the loop.

#### 11. Create the orderer certificate directory if it does not exist
This task create the orderer certificate directories if it is not present 
##### Input Variables
    *orderer.certificate: The orderer certificate path.
    path: The path where to check is specified here.
    recurse: Yes/No to recursively check inside the path specified. 
    state: Type i.e. directory.
**loop_control**: Specify conditions for controlling the loop.                
    loop_var: loop variable used for iterating the loop.

#### 12. Create the ca.crt for orderers if it is not present
This task generate the ca.crt file if it is not present
##### Input Variables
    *orderer.certificate: The orderer certificate path.
    path: The path where to check is specified here.
    state: Type i.e. touch.
**loop_control**: Specify conditions for controlling the loop.                
    loop_var: loop variable used for iterating the loop.

#### 13. Copy ca.crt from auto-generated path to given path
 This tasks copies the auto-generated ca.crt of orderer to given path
##### Input Variables
    *orderer.org_name: The org name of the orderer.
    *orderer.certificate: The certificate file path for the orderer.
**loop_control**: Specify conditions for controlling the loop.                
    loop_var: loop variable used for iterating the loop.

**when**: This task is executed when add_new_org is false i.e. this is executed when network is deployed first time.

#### 14. Check if Orderer certs already created
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

#### 15. Save Orderer certs if already created
 This tasks Ensure orderer-tls directory is present in build.
##### Input Variables
    *orderer.org_name: The org name of the orderer.
**local_action**:  A shorthand syntax that you can use on a per-task basis
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.
**when**: It runs Only when *orderer_certs_result.results[0]* is true.

#### 16. Copy organization level certificates for orderers
This task copies the organisation level certificates for orderer.
##### Input Variables
    *component_name: The name of the component
    *orderers: Orderer data patch from Network yaml
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**environment** : It includes the list of environment variables.

**shell** : This command loops in through the orderer list and writes the certificates to vault.

**vault** : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml)

**when**: It runs Only when *orderer_certs_result.results[0]* is true.

#### 17. Check if admin msp already created
This tasks Check if admin msp already created.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
##### Output Variables
    vault_admin_result: This variable stores the output of admin msp check query.
**shell** : This command checks if msp credentials are present in the vault.

**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 16. Copy organization level certificates for orgs
This task copies the organisation level certificates for organisations.
##### Input Variables
    *component_name: The name of the component
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**environment** : It includes the list of environment variables.

**shell** : These commands writes the respective tls and msp certificates to vault.

**vault** : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 

**when**: It runs Only when *vault_admin_result* is failed.

#### 18. Check if user msp already created
This tasks Check if user msp already created.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
##### Output Variables
    vault_user_result: This variable stores the output of admin msp check query.
**shell** : This command checks if user msp credentials are present in the vault.

**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 19. Copy user certificates for orgs
This task copies the user certificates for organisations.
##### Input Variables
    *component_name: The name of the component
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**environment** : It includes the list of environment variables.

**shell** : These commands writes the respective tls and msp certificates to vault.

**vault** : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 

**when**: It runs Only when *vault_user_result* is failed.

------------
### peercheck.yaml
This task checks the crypto in the vault

#### 1. Check if peer msp already created
This task check if peer msp certs exists in vault, if not this should create certificate. If yes, get the certificate.
##### Input Variables
    *component_name: The name of the component
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**environment** : It includes the list of environment variables.
**shell** : This command check if msp certs exists in vault..
**vault* : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 

#### 2. Get MSP info
 This task calls setup/get_crypto role. 
 ##### Input Variables
**include_tasks**: This module includes a task setup/get_crypto.

------------
### common.yaml
This task creates the organization specific crypto material for each organization

#### 1. Create directory path on CA Tools
This task creates directory path on CA Tools CLI.
**shell** : This command creates CA TOOLS CLI.
**when**: Condition is specified here, runs only when *vault_msp_result.failed*  is true i.e. not found.

#### 2. Copy generate-usercrypto.sh to destination directory
This task copy the generate-user-crypto.sh and cert files in the build folder

#### 3. Changing the permission of msp files
This task changes the permission of generate-crypto scripts.
**loop**: It loop over files
**when**: Condition is specified here, runs only when *vault_msp_result.failed*  is true i.e. not found.

#### 4. Copy the generate_crypto.sh file into the CA Tools 
This task copy the generate-user-crypto.sh and cert files in the respective CA Tools CLI
**shell** : This command copies the files into CA TOOLS CLI.
**when**: Condition is specified here, runs only when *vault_msp_result.failed*  is true i.e. not found.

#### 5. Generate crypto material for organization peers
This task generates the crypto material by executing the generate-user-crypto script file present in the Organizations CA Tools CLI
##### Input Variables
    *component_name: The name of the resource
    *component_type: The type of the resource
    *org_name: The name of the organisation.
**shell** : The specified commands generates the crypto material by executing the generate_crypto.sh script file present in the Organizations CA Tools CLI
**when**: Condition is specified here, runs only when *vault_msp_result.failed*  is true i.e. not found.

#### 6. Copy the crypto config folder from the ca tools
This task copies the generated crypto material from the respective CA Tools CLI to the Ansible container
##### Input Variables
    *component_name: The name of the resource
    *KUBECONFIG: The config file of kubernetes cluster.
    *org_name: The name of the organisation.
**shell** : The specified commands copies the generated crypto material from the respective CA Tools CLI.
**when**: Condition is specified here, runs only when *vault_msp_result.failed*  is true i.e. not found.


------------
### peer.yaml
This creates the crypto material for each of the peer

#### 1. Copy the crypto material for orgs
This task Copy the crypto material for orgs that are already created.
##### Input Variables
    *component_name: The name of the component
    *orderer: Orderer Name
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    
    
**environment** : It includes the list of environment variables.
**shell** : This command check if orderer msp exists in vault.
**vault* : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 

#### 2. Create the peer certificate directory if it does not exist
This task create the peer certificate directories if it is not present 
##### Input Variables
    *peer.certificate: The peer certificate path.
    path: The path where to check is specified here.
    recurse: Yes/No to recursively check inside the path specified. 
    state: Type i.e. directory.

#### 3. Create the ca.crt file if it is not present
This task generate the ca.crt file for peers if it is not present
##### Input Variables
    *peer.certificate: The peer certificate path.
    path: The path where to check is specified here.
    state: Type i.e. touch.

#### 4. Copy msp cacerts from auto-generated path to given path
 This task copy the peer certificate to the path provided in network.yaml
##### Input Variables
    *peer.certificate: The certificate file path for the orderer.

**when**: This task is executed when add_new_org is false i.e. this is executed when network is deployed first time.

#### 11. Check Ambassador cred exists
This task Checks if Ambassador cred exists
##### Input Variables
    kind: "Secret"
    *namespace: Namespace of entity
    name: Name of entity
    context: context name
#### Output variables
    *get_peer_secret: Stores the result of query.

#### 12. Check if peer ambassador secrets certs created
This task Check the existence of peer ambassador certs secret in the vault .
##### Input Variables
    kind: "Secret"
    *namespace: Namespace of entity
    name: Name of entity
    context: context name
#### Output variables
    *vault_peer_ambassador: Stores the result of query.

#### 13. Get peer ambassador info
It gets the ambassador info
##### Input Variables
    vault_output: "Output result"
    type: "orderer"
    peer_ambassador_path: "peer Ambassador Path"

#### 14. Generate the peer certificate
This task generates peer certificates.
**shell** : Runs command used for certificate generation.
**when** : *get_peer_secret.resources|length == 0 and vault_peer_ambassador.failed == True* Condition specified for this task to run.


#### 15. Create the Ambassador credentials
This task generates the ambassador credentials.
**shell** : Runs command used for certificate generation.
**when** : *get_peer_secret.resources|length == 0* Condition specified for this task to run.

#### 16. Copy the crypto material to Vault
This task copies crypto material to vault.
**shell** : Runs command used for copy crypto material to vault.
**when** : *vault_peer_ambassador.failed* Condition specified for this task to run.
