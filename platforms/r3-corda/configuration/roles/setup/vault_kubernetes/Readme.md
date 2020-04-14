## ROLE: setup/vault_kubernetes
This role setups communication between the vault and kubernetes cluster and install neccessary configurations.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. "Ensures build dir exists"
This task checks whether build directory present or not.If not present,creates one.
##### Input Variables
  
    path: The path where to check is specified here
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory.

#### 2. Check if Kubernetes-auth already created for Organization
This task checks if the vault path already exists.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_auth: kubernetes auth path specified here.

##### Output Variables
    auth_list: Stores the list of enables auth methods

#### 3. Vault Auth enable for organisation
This task enables the path for the nms,doorman,notaries and nodes on vault
This task runs only when {{auth_path}} is not already created
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_auth: Contains the auth path. 
**when**: It runs Only when component_auth is *NOT* in the output of auth_list
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 4. "Get Kubernetes cert files for organizations"
This task get the certificate for the cluster mentioned in k8 secret
**shell** : This command get the certificates for cluster and stores them in the temporary build directory.
##### Input Variables
     *config_file: kuberetes configuration path specified here.
     *component_ns: name of the resource
**when**: It runs only when the *component_auth* is not created

#### 5. Write reviewer token for Organisations
This task writes the Service Account token to the vault for various corda entity(nms,doorman,notary,nodes)
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *config_file: kuberetes configuration path specified here.
    *component_ns: name of the resource
**shell** : Export command makes the variables, known to child processes.
The vault write command writes the Service Account token to the vault for Organisations
**when**: It runs only when the *auth_path* is not created

#### 6. Check if secret-path already created for Organization
This task checks if the vault secret path.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell**: list the secret in vault
##### Output Variables
    secrets_list: Stores the list of enables auth methods

#### 7. Create Vault secrets path
This task create Vault secrets path.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_path: path of the resource
    *component_name: name of the resource
**shell**: enable the vault secret path
**when**: It runs only when the *secrets_list* is not created

#### 8. Check if policy exists
This task checks if the vault-ro polict already exists.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: name of the resource
**shell**: read vault crypto policy
**ignore_errors**: This flag ignores the any errors and proceeds further.
##### Output Variables
    vault_policy_result: Stores the list of policy

#### 9. Create policy for Access Control
This task creates the access policy for various corda entity(nms,doorman,notary,nodes)
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: name of the resource
**when**: Condition is specified here, runs only if the policy check is failed and component type is peer.

#### 10. Create Vault auth role
This task creates the vault auth
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_auth: kubernetes auth path specified here.
    *component_name: name of the resource
**shell** : This command creates the vault auth.
**when**: Condition is specified here, runs only when *auth_path* is not found.
