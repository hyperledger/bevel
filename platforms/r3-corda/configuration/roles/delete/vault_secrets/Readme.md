[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

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

#### 2. Delete service creds
This task deletes service credentials.
##### include_tasks
    nested_main.yaml 
**loop**: loop through the services
**when**: runs this task when the *component_type* is 'node'.

#### 3. Delete Ambassador creds
This task deletes Ambassador credentials.
##### Input Variables
    kind: Secret, The kind of component
    namespace: Namespace of the component
    *name: {{ node.name }}-ambassador-certs
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**loop**: loop through organization peers
**when**: runs this task when the *component_type* is 'node'.
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 4. Delete vault-auth path
This task deletes vault auth.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**loop**: loop through organization peers
**shell** : This command deletes the vault auth.
**when**: runs this task when the *component_type* is 'node'.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 5. Delete Crypto for nodes
This task deletes crypto materials for the nodes from vault.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**loop**: loop through organization peers
**shell** : This command deletes the crypto for nodes.
**when**: Condition specified here, runs only when the *component_type* is 'nodes'.

#### 6.Delete policy
This task deletes the policies.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**loop**: loop through organization peers
**shell** : This command deletes the policies for nodes.
**when**: Condition specified here, runs only when the *component_type* is 'nodes'.

### nested_main.yaml

#### 1. Delete Ambassador creds
This task deletes Ambassador credentials.
##### Input Variables
    kind: Secret, The kind of component
    namespace: Namespace of the component
    *name: {{ node.name }}-ambassador-certs
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 2. Delete vault-auth path
This task deletes vault auth.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *service.value['name']: name of the service
**shell** : This command deletes the vault auth.

#### 3. Delete Crypto for services
This task deletes Crypto for services.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *service.value['name']: name of the service
**shell** : This command deletes the crypto for services.

#### 4.Delete policy
This task deletes the policies.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : This command deletes the policies for nodes.

#### 5. Delete Ambassador creds
This task deletes Ambassador credentials.
##### Input Variables
    kind: Secret, The kind of component
    namespace: Namespace of the component
    *name: {{ node.name }}-ambassador-certs
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
    state: absent ( This deletes any found result)
**ignore_errors**: This flag ignores the any errors and proceeds further


