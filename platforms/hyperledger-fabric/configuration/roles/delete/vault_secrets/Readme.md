## delete/vault_secrets
This role deletes the Vault configurations
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Delete docker creds
This task deletes docker credentials.
##### Input Variables
    kind: Helmrelease, The kind of component
    namespace: Namespace of the component
    name: "regcred"
    state: absent ( This deletes any found result)
    kubeconfig: The config file of cluster
    context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 2. Delete Ambassador creds
This task deletes ambassador credentials.
##### Input Variables
    kind: Helmrelease, The kind of component
    namespace: Namespace of the component
    name: "regcred"
    state: absent ( This deletes any found result)
    kubeconfig: The config file of cluster
    context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 3. Delete vault-auth path
This task deletes vault auth.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
**shell** : This command deletes the vault auth.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 4. Delete Crypto for orderers
This task deletes crypto materials for the orderer from vault.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
    *orderer: Orderer Details
**shell** : This command deletes the vault auth.
**when**: Condition specified here, runs only when the *component_type* is 'orderer'.


#### 5. Delete Crypto for peers
This task deletes crypto materials for peers from vault
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
    *peers: Peers Details PAtch fetched from Network yaml.
    *org_name: Name of the organisation
**shell** : This command deletes the vault auth.
**when**: Condition specified here, runs only when the *component_type* is 'peer'.


#### 6. Delete policy
This task deletes policies from vault
**shell** : This command deletes the vault auth.
**ignore_errors**: Ignores any errors found.
