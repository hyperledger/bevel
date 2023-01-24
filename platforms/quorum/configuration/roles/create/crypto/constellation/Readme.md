[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/crypto/constellation
This role generates the crypto material for transaction manager for each node.
### main.yaml

### Taks

#### 1. Create Crypto material for each node for constellation-node
This task call in nested_main.yaml which generates crypto material for each peer for constellation-node.

### Nested_main.yaml

#### 1. Check if transaction key already present in the vault
This tasks checks if nodekey is already present in the vault

**shell**: This module runs the vault read command in a shell

##### Input Variables

    VAULT_ADDR: vault address
    VAULT_TOKEN: vault token

##### Output Variables

    vault_tm_result: This variable stores whether the tm.pub is present in vault or not.

#### 2. Create build directory if it does not exist
This task creates the build directory if it does not exist

**file**: This module creates the build directory if it does not exist

**when**: It runs when *vault_tm_result.failed* == True, i.e. when tm.pub is not found in vault

#### 3. Generate crypto for constellation-node
This task generates crypto material for transaction manager for each node using constellation-node

**shell**: This module starts a shell which runs commands to generate crypto


**when**: It runs when *vault_tm_result.failed* == True, i.e. when tm.pub is not found in vault

#### 4. Copy the crypto material to Vault
This task copies the above generated crypto material to the vault

**shell**: This module is used to put the generated crypto material in the vault
##### Input variables
    *VAULT_ADDR: Vault address
    *VAULT_TOKEN: Vault token

**when**: It runs when *vault_tm.result.failed* == True, i.e. when nodekey is not found in vault.
