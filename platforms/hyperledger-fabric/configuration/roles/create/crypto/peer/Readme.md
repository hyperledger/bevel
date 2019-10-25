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
**vault* : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 

#### 4. Call peer.yaml for each peer
 This task calls peer.yaml file for each peer
 ##### Input Variables
    *services.peers: The peer data from network.yaml
**include_tasks**:Additional tasks are specified here which are required for this task.
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.
    
#### 5. Create the MSP config.yaml file for orgs
This task creates the MSP config.yaml file for organizations
##### Input Variables
    *component_name: The name of the resource
    
**shell** : The specified command creates the MSP config.yaml file for organizations


#### 6. Ensure ca directory exists
 This tasks Ensure orderer-tls directory is present in build.
##### Input Variables
    *orderer.org_name: The org name of the orderer.
    path: The path where to check is specified here.
    recurse: Yes/No to recursively check inside the path specified. 
    state: Type i.e. directory.
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.
#### 7. Check if Orderer certs already created
This tasks Check if Orderer certs exists in vault. If yes, get the certificate
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of the resource.

##### Output Variables
    orderer_certs_result: Stores the result of Orderer cert check query.
**environment** : It includes the list of environment variables.
**shell** : This command get certificates from vault.
**vault* : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 6. Save Orderer certs if already created
 This tasks Ensure orderer-tls directory is present in build.
##### Input Variables
    *orderer.org_name: The org name of the orderer.
**local_action**:  A shorthand syntax that you can use on a per-task basis
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.
**when**: It runs Only when *orderer_certs_result.results[0]* is true.

#### 7. Copy organization level certificates for orderers
This task copies the organisation level certificates for orderer.
##### Input Variables
    *component_name: The name of the component
    *orderers: Orderer data patch from Network yaml
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**environment** : It includes the list of environment variables.
**shell** : This command loops in through the orderer list and writes the certificates to vault.
**vault* : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 
**when**: It runs Only when *orderer_certs_result.results[0]* is true.

#### 8. Check if admin msp already created
This tasks Check if admin msp already created.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
##### Output Variables
    vault_admin_result: This variable stores the output of admin msp check query.
**shell** : This command checks if msp credentials are present in the vault.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 9. Copy organization level certificates for orgs
This task copies the organisation level certificates for organisations.
##### Input Variables
    *component_name: The name of the component
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**environment** : It includes the list of environment variables.
**shell** : These commands writes the respective tls and msp certificates to vault.
**vault* : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 
**when**: It runs Only when *vault_admin_result* is failed.

#### 10. Check if user msp already created
This tasks Check if user msp already created.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
##### Output Variables
    vault_user_result: This variable stores the output of admin msp check query.
**shell** : This command checks if user msp credentials are present in the vault.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 11. Copy user certificates for orgs
This task copies the user certificates for organisations.
##### Input Variables
    *component_name: The name of the component
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**environment** : It includes the list of environment variables.
**shell** : These commands writes the respective tls and msp certificates to vault.
**vault* : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 
**when**: It runs Only when *vault_user_result* is failed.