[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/refresh_certs/fetch_old_certs
This role obtains the old certificates, which will be replaced

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

#### 1. Copy the tls server.crt from vault
This task copies the tls server.crt from vault to the build directory
##### Input Variables
    *component_ns: The namespace of resourse
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the vault
**loop**: loops over orderers list fetched from *{{ orderers }}*
**loop_control**: Specify conditions for controlling the loop.

#### 2. Fetch the msp admin from vault
This task copies the msp admin from vault to the build directory
##### Input Variables
    *component_ns: The namespace of resourse
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the vault

#### 3. Fetch the cacerts msp from vault
This task copies the msp cacerts from vault to the build directory
##### Input Variables
    *component_ns: The namespace of resourse
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the vault

#### 4. Fetch the msp keystore from vaul
This task copies the msp keystore from vault to the build directory
##### Input Variables
    *component_ns: The namespace of resourse
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the vault

#### 5. Fetch the msp signcerts from vault
This task copies the msp signcerts from vault to the build directory
##### Input Variables
    *component_ns: The namespace of resourse
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the vault

#### 6. Fetch the msp tlscacerts from vault
This task copies the msp tlscacerts from vault to the build directory
##### Input Variables
    *component_ns: The namespace of resourse
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : The specified commands copies the msp folder from the vault
