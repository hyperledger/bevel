# delete/vault_secrets
This role deletes the Vault configurations
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Delete docker creds
This task deletes docker credentials.
##### Input Variables
    kind: Helmrelease, The kind of component
    *namespace: Namespace of the component
    name: "regcred"
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 2. Delete Ambassador creds for idman
This task deletes Ambassador credentials for idman
##### Input Variables
    kind: Secret, The kind of component
    namespace: Namespace of the component
    *name: {{ org.services.idman.name }}-ambassador-certs
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**when**: runs this task when the *org.type* is 'cenm'.
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 3. Delete Ambassador creds for networkmap
This task deletes Ambassador credentials for networkmap
##### Input Variables
    kind: Secret, The kind of component
    namespace: Namespace of the component
    *name: {{ org.services.networkmap.name }}-ambassador-certs
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**when**: runs this task when the *org.type* is 'cenm'.
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 4. Delete Ambassador creds for notary
This task deletes Ambassador credentials for notary
##### Input Variables
    kind: Secret, The kind of component
    namespace: Namespace of the component
    *name: {{ org.services.notary.name }}-ambassador-certs
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**when**: runs this task when the *org.type* is 'cenm'.
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 5. Delete Ambassador creds for each peer of all nodes
This task deletes Ambassador credentials for each peer of all nodes
##### Input Variables
    kind: Secret, The kind of component
    namespace: Namespace of the component
    *name: {{ peer.name }}-ambassador-certs
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**when**: runs this task when the *org.type* is 'cenm'.
**loop**: loop through organization peers
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 6. Delete vault-auth path
This task deletes vault auth.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : This command deletes the vault auth.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 7. Delete vault-auth path
This task deletes vault auth.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *service.value['name']: name of the service
**shell** : This command deletes the vault auth.

#### 8. Delete Crypto for cenm
This task deletes crypto materials for the CENM from vault.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : This command deletes the crypto for CENM.

#### 9. Delete Crypto for cenm
This task deletes crypto materials for the nodes from vault.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**loop**: Loop through each peer of all organizations.
**shell** : This command deletes the crypto for nodes.

#### 10. Delete vault access control policy
This task deletes crypto materials for the organizations from vault.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : This command deletes the crypto for organizations.
