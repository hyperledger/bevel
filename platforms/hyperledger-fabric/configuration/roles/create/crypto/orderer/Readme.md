## ROLE: crypto/orderer
This role generates crypto material for orderers.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if CA-tools is running
This task checks if CA-tools pod is running.
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

#### 4. Check if orderer msp already created
This task Check orderer msp already created.
##### Input Variables
    *component_name: The name of the component
    *orderer: Orderer Name
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    
##### Output Variables
    vault_msp_result: This variable stores the output of orderer msp query.
    
**environment** : It includes the list of environment variables.
**shell** : This command check if orderer msp exists in vault.
**vault* : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 5. Get MSP info
This task gets MSP info.
##### Input Variables
    *vault_output: "Result of vault msp check query"
    type: "orderer"
    *msp_path: "Path for MSP"
**include_role** : It includes the name of intermediatory role which is required for getting MSP info.
**when**: Condition is specified here, runs only when *vault_msp_result.failed* is FALSE i.e. MSP is found.

#### 6. Create directory path on CA Tools
This task creates directory path on CA Tools CLI.
##### Input Variables
    *name: dos2unix
**shell** : This command creates CA TOOLS CLI.
**when**: Condition is specified here, runs only when *vault_msp_result.failed*  is true i.e. not found.

#### 7. Install dos2unix to use unarchieve module of ansible
This task installs dos2unix.
##### Input Variables
    *component_name: The name of the component
    *KUBECONFIG: The config file of the custer.
**shell** : This command creates CA TOOLS CLI.
**when**: Condition is specified here, runs only when *vault_msp_result.failed*  is true i.e. not found.

#### 8. Convert the file to unix format
 This task converts the generate_crypto.sh file to unix format
**with_items**:this lookup returns a list of items given to it, if any of the top level items is also a list it will flatten it, but it will not recurse.
**shell** : Uses dos2unix module to convert to unix format.
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.
**when**: Condition is specified here, runs only when *vault_msp_result.failed*  is true i.e. not found.

#### 9. Copy the generate_crypto.sh file into the CA Tools 
This task copy the generate_crypto.sh and cert files in the respective CA Tools CLI.
##### Input Variables
    *component_name: The name of the resource
    *component_type: The type of the resource
    *org_name: The name of the organisation.
**shell** : The specified commands exports the CA TOOLS CLI and copys generate crypto.sh.
**when**: Condition is specified here, runs only when *vault_msp_result.failed*  is true i.e. not found.

#### 9. Generate crypto material for organization orderers
This task generates the crypto material by executing the generate_crypto.sh script file present in the Organizations CA Tools CLI
##### Input Variables
    *component_name: The name of the resource
    *component_type: The type of the resource
    *org_name: The name of the organisation.
**shell** : The specified commands generates the crypto material by executing the generate_crypto.sh script file present in the Organizations CA Tools CLI
**when**: Condition is specified here, runs only when *vault_msp_result.failed*  is true i.e. not found.

#### 10. Copy the crypto config folder from the ca tools
This task copies the generated crypto material from the respective CA Tools CLI to the Ansible container
##### Input Variables
    *component_name: The name of the resource
    *KUBECONFIG: The config file of kubernetes cluster.
    *org_name: The name of the organisation.
**shell** : The specified commands copies the generated crypto material from the respective CA Tools CLI.
**when**: Condition is specified here, runs only when *vault_msp_result.failed*  is true i.e. not found.

#### 10. Copy the crypto material for orderer
This task puts the above created crypto material in the vault
##### Input Variables
    *component_name: The name of the resource
    *orderer: The patch of the orderer (from network.yaml).
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**environment** : It includes the list of environment variables.
**shell** : The specified commands copies the generated crypto material from the respective CA Tools CLI.
**when**: Condition is specified here, runs only when *vault_msp_result.failed*  is true i.e. not found.