## ROLE: vault_kubernetes
This role setups communication between the vault and kubernetes cluster and install neccessary configurations.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if namespace is created
This tasks check if the namespace is already created or not.
##### Input Variables

    kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    get_namespace: This variable stores the output of namespace query.
  **until**: This condition checks until *get_namespace.resources* variable exists
  **retries**: No of retries
  **delay**: Specifies the delay between every retry

#### 2. Ensures build dir exists
This task creates the build temp directory.
##### Input Variables
    path: The path where to check is specified here.
    recurse: Yes/No to recursively check inside the path specified. 

#### 3. Check if Kubernetes-auth already created for Organization
This task checks if the vault path already exists.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**environment** : It includes the list of environment variables.
**shell** : This command lists the auth methods enabled. The output lists the enabled auth methods and options for those methods.
**vault* : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 

##### Output Variables
    auth_list: Stores the list of enables auth methods

#### 4. Enable and configure Kubernetes-auth for Organization
This task enables the path for the organizations and orderers on vault
This task runs only when {{auth_path}} is not already created
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *auth_path: Contains the auth path.
**environment** : It includes the list of environment variables.
**shell** : This command enables the path for the organizations and orderers on vault.
**vault* : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 
**when**: It runs Only when auth_path is *NOT* in the output of auth_list
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 5. Get Kubernetes cert files for organizations
This task get the certificate for the cluster mentioned in k8 secret
##### Input Variables
    *component_name: The name of resource
    *KUBECONFIG: Contains config file of cluster, Fetched using 'kubernetes.' from network.yaml
**shell** : This command get the certificates for cluster and stores them in the temporary build directory.
**when**: It runs only when the *auth_path* is not created

#### 6. Write reviewer token for Organisations
This task writes the Service Account token to the vault for Organisations.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
**shell** : Export command makes the variables, knowm to child processes.
The vault write command writes the Service Account token to the vault for Organisations
**when**: It runs only when the *auth_path* is not created

#### 7. Check if policy exists
This task checks if the vault-ro polict already exists
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
**shell** : This command reads the vault and checks if the policy exists.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

##### Output Variables
    vault_policy_result: Stores the result of policy check shell command.
    
#### 8. Create policy for Orderer Access Control
This task creates the access policy for orderers
##### Input Variables
    *component_name: The name of resource
**template** : It contains the source and destinations details required for value file generation of access policy.
**src**: Contains the details of template file.
**dest**: Destination path and name of file to be generated.
**when**: Condition is specified here, runs only if the policy check is failed

#### 9.  Create policy for Organisations Access Control
This task creates the access policy for organisations
##### Input Variables
    *component_name: The name of resource
**template** : It contains the source and destinations details required for value file generation of access policy.
**src**: Contains the details of template file.
**dest**: Destination path and name of file to be generated.
**when**: Condition is specified here, runs only if the policy check is failed and component type is peer.


#### 9.  Write policy for vault
This task creates the access policy for organisations
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
    *component_type: The type of resource
**shell** : This command writes the policies to vault.
**when**: Condition is specified here, runs only if the policy check is failed.


#### 10.  Create Vault auth role
This task creates the vault auth
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
    *component_type: The type of resource
**shell** : This command creates the vault auth.
**when**: Condition is specified here, runs only when *auth_path* is not found.


#### 11.  Check docker cred exists
This task checks if the docker credentials exists
##### Input Variables

    kind: This defines the kind of Kubernetes resource
    *namespace: Namespace of the component 
    name: The name of credentials
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    get_regcred: This variable stores the output of docker credentials check query.
    
#### 12.  Create the docker pull credentials
This task creates the docker pull credentials
##### Input Variables
    *KUBECONFIG: Contains config file of cluster, Fetched using 'kubernetes.' from network.yaml
    *component_name: The name of resource
**shell** : This command creates the docker credentials.
**when**: Condition is specified here, runs only when *get_regcred.resources* is not found.

