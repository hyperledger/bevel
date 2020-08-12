## ROLE: setup/vault_kubernetes
This role setups communication between the vault and kubernetes cluster and install neccessary configurations.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)


#### 1. Check namespace is created
This task checks if the namespace is created or not
**k8s_info**: This module checks for the k8s resources in the cluster
##### Input Variables
    kind: name of the resources
    *name: namespace name
    *kubeconfig: kubeconfig file from network.yaml file.
    *context: cluster context
    
##### Output variable
    *get_namespace: Stores the output of this task.

#### 2. Ensure build directory exists
This task checks whether build directory present or not.If not present,creates one.
##### Input Variables
  
    path: The path where to check is specified here
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory.

#### 3. Check if Kubernetes-auth already created for Organization
This task checks if the vault path already exists.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_auth: kubernetes auth path specified here.

##### Output Variables
    auth_list: Stores the list of enables auth methods

#### 4. Vault Auth enable for organisation
This task enables the path for the nodes on vault
This task runs only when {{component_auth}} is not already created
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_auth: Contains the auth path. 
**when**: It runs Only when component_auth is *NOT* in the output of auth_list
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 5. Get Kubernetes cert files for organizations
This task get the certificate for the cluster mentioned in k8 secret
**shell** : This command get the certificates for cluster and stores them in the temporary build directory.
##### Input Variables
     *config_file: kuberetes configuration path specified here.
     *component_ns: name of the resource
**when**: It runs only when the *component_auth* is not created

#### 6. Write reviewer token
This task writes the Service Account token to the vault for various Quorum entity
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *config_file: kuberetes configuration path specified here.
    *component_ns: name of the resource
**shell** : Export command makes the variables, known to child processes.
The vault write command writes the Service Account token to the vault for Organisations
**when**: It runs only when the *auth_path* is not created

#### 7. Check if policy exists
Checks if policy for the node organizations exists
**shell**: calls vault binary to read the vault policy
 ##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
#### Output variable
    *vault_policy_result*: result of the above task.
**ignore_errors** : ignore errors


#### 8. Create policy for Access Control
This task checks for the vault secret path and creates policy
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell**: creates the policies for the organization


#### 9. Create Vault auth role
This task create Vault secrets path.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_path: path of the resource
    *component_name: name of the resource
**shell**: enable the vault secret path
**when**: It runs only when the *auth_list.stdout.find(component_auth)* does not exists i.e. auth path is not found

#### 10.  Create the docker pull credentials
This task creates the docker pull credentials for image registry
##### Input Variables
    *component_ns: name of the namespace

**shell** : This command creates the vault auth.
**when**: Condition is specified here, runs only when *auth_path* is not found.
