[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/genesis_nodekey
This role generates genesis.json and nodekey/enode for each organization.
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if nodekey is present in vault
This task checks if nodekey is present in the vault or not
**include_tasks**: nodekey_vault_check
**loop**: loops over all the node in an organisation
**loop_control**: Specifies the condition for controlling the loop.
    loop_var: loop variable used for iterating over the loop.
##### Input Variables
     *component_ns: Organization namespace   
     *vault: Vault uri and token read from network.yaml

#### 2. Fetching data of validator nodes in the network from network.yaml
##### Input Variables
    *node_name: Name of the node
**include_tasks**: It includes the name of intermediary task which is required for creating the ambassador certificates.
**loop**: loops over all the node in an organisation
**when**: vault_check count is greater than zero.
**loop_control**: Specifies the condition for controlling the loop.

    loop_var: loop variable used for iterating over the loop.

#### 3. Create build directory if it does not exist
This task creates the build directory if it does not exist.
**file** : This module will create the directory if it does not exist with 755 permissions.
**when**: vault_check count is greater than zero.

#### 4. Generate istanbul files
 This task generates the istanbul files
**shell**: This task generates the nodekey for each node placed in numerical directories
**when**: vault_check count is greater than zero.

    
#### 5. Rename the directories created above with the elements of validator_node_list
This task rename the above created directories to the org_name/node_name     
**copy** : This module copies the content of numerical directories to org/node directory
**when**: vault_check count is greater than zero.

#### 6. Delete the numbered directories
 This tasks deletes the numbered directories
**file** : This module deletes the numerical directories
**when**: vault_check count is greater than zero.

-------------
### nodekey_vault_check
### Tasks
#### 1. Call nested check for each node
This task calls nested_nodekey_vault_check to check if nodekey for each node is present or not
**include_tasks**: It includes the name of intermediary task which is required for checking the presence of nodekey.
**loop**: loops over all the node in an organisation
**loop_control**: Specifies the condition for controlling the loop.

    loop_var: loop variable used for iterating over the loop.

----------------
### nested_nodekey_vault_check
### Tasks
#### 1. Check if nodekey already present in the vault
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore if any error occurs

##### Output Variables

    vault_nodekey_result: This variable stores the output of nodekey check query.

#### 2. vault_check variable
**set_fact**: This module sets the variable *vault_check* globally.
**when**: It runs when *vault_nodekey_result.failed* == True, i.e. nodekey of any of the node is not in vault.

--------------------------
### validator_node_data.yaml

#### 1. Get validator node data
This task fetch (org,node) pairs for each validating node present in all organizations of the network
**when**: peer.type == 'validator'
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.
