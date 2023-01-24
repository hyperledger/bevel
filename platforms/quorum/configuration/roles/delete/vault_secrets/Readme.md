[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## delete/vault_secrets
This role deletes the Vault configurations
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Delete docker creds
This task deletes docker credentials.
##### Input Variables
    kind: Secret
    *namespace: Namespace of the component
    name: "regcred"
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 2. Delete ambassador creds
This task deletes ambassador credentials.
##### Input Variables
    kind: Secret
    namespace: Namespace of the component here it is default
    name: "Name of the ambassador credential"
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**loop**: iterates over all the peers.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 3. Delete vault-auth path
This task deletes vault auth.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *org_name: The name of organisation
**shell** : This command deletes the vault auth.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 4. Delete Crypto material 
This task deletes crypto material
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : This command deletes the secrets
**loop**: iterates over all peers
**ignore_errors**: This flag ignores any errors and proceeds further.

#### 5. Delete Access policies 
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : This module deletes the access policies
**loop**: iterates over all peers
**ignore_errors**: This flag ignores any errors and proceeds further.
