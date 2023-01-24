[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/genesis_raft
This role generates genesis.json file

### main
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Fetch the node address
This task fetch node address of each node of all organizations.
##### Input Variables
    *vault: This variable contains the vault information of the specificed organization
**include_tasks**: This module includes the nested task validator_node_data.yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 2. Create genesis.yaml
This task creates the genesis file from the template.
**template**: This module generates the value file from specified template file present the templates folder.

#### 3. Read the genesis.yaml file
This task reads the genesis file and put it in the variable.
**set_fact** : This module will set the varaible as global variable setting up the genesis.yaml.

#### 4. Create genesis.yaml file
This task converts the above read variable into json format and writes it in the gensis.json file

------------

### validator_node_data
### Tasks

#### 1. Looping over peers
This task calls nested_validator_node_data for each peers in the organisation
**include_tasks**: This module includes the nested task validator_node_data.yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

-----------------

### nested_validator_node_data
### Tasks

#### 1. Check if keystore.json is present in the build directory or not
This task checks for the keystore.json file in build directory
**stat**: This module checks for the presence of the file in the specified location.
#### Output variable
    file_status: output of the stat module

#### 2. Create build directory if it does not exist
This task creates build directory if it is not there.
**file**: This module creates the file specified by *path*
**when**: *file_status.stat.exists* == False

#### 3. Get the keystore.json from vault
This task gets the keystore.json from the vault
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**when**: *file_status.stat.exists* == False

#### 4. Get the node_address
**set_fact**: Sets node_address as a global variable.

#### 5. Get validator node info
**set_fact**: sets node_address_list as global and appends the value of node_address from above task into this list.

#### Note:
 templates folder has tpl files for genesis.