[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/validator_node
This role creates the new enode data for the new validator nodes for an existing validator organization and the voting for its acceptance.
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)    

#### 1. Set enode_validator_list and new_validator_nodes to an empty list
This task initializes the enode_validator_list and new_validator_nodes variables to an empty array of string

**set_fact**: This module sets the variable assignment as globally accessible variable

#### 2. Create build directory if it does not exist
This task creates the build directory if it does not exist.
**file** : This module will create the directory if it does not exist with 755 permissions.
**when**: vault_check count is greater than zero.

#### 3. Create build directory if it does not exist
This task creates the build directory if it does not exist.
**file** : This module will create the directory if it does not exist with 755 permissions.

#### 4. Create node key mgmt value file for new validator nodes 
This task creates node key mgmt value file for new validator nodes 
##### Input Variables

    *organisation: "Organization name's"
    *organisation_ns: "Organization namespace"
    *kubernetes: "Kubernetes cluster information of the organization"
    *vault: "Vault uri and token read from network.yaml"
    *charts_dir: "Chart to be executed"
    *values_dir: "Directory where release files are stored"
    *gitops: *item.gitops* from network.yaml

**include_role**: create/crypto/node.yaml
**loop**: loop over the organizations
**loop_control**: Specify conditions for controlling the loop.
**when**: the organization is type validator

#### 5. Get validator nodes data
This task gets the enode data in the format of
org_name
peer_name
org_type

**include_task**: node_data.yaml
**loop**: loop over the organizations
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 6. Get crypto from vault
This tasks checks the crypto material in the vault
##### Input Variables
    *component_ns: "Organization namespace"
    *vault: "Vault uri and token read from network.yaml"

**include_task**: check_vault.yaml
**loop**: loop over the organizations
**loop_control**: Specify conditions for controlling the loop.


#### 7. Touch file to store information for validators
 This file stores the address of the validator nodes
**file** : This module will create the file if it does not exist
**when**: *generate_crypto* count is *True*.

#### 8. Touch toEncode.json file
 This file used by besu binary to generate the extra data information
**file** : This module will create the flie if it does not exist.
**when**: *generate_crypto* count is *True*.

#### 9. Get node data
 Create the validator address array 
**shell**: This task generates the validator address array 
**when**: *generate_crypto* count is *True*.

#### 10. Voting for the new validator node to be added
This task does the voting from every existing validator node for adding the new one (or new ones).
**include_tasks**: validator_vote.yaml
**loop**: loops over all the new nodes that will be added
**loop_control**: Specifies the condition for controlling the loop.
    loop_var: loop variable used for iterating over the loop.
##### Input Variables
     *besu_nodes: Organization validators
**when**: *generate_crypto* count is *True*.

----------------

### enode_data.yaml
### Tasks

#### 1. Create the enode_data
**include_task**: nested_enode_data.yaml
**loop**: loop over peers in the organization
**loop_control**: Specify the conditions for controlling the loop.

    loop_var: loop variable used for iterating the loop.

-------------------

### nested_enode_data.yaml
### Tasks

#### 1. Check if enode is present in the build directory or not
This task checks if enode is present in the build directory or not

**stat**: This module checks the file exist or not.
##### Input variables
    *path: path to the enode.
##### Output variables
    *file_status: output of the enode exists or not task

#### 2. Creates the build directory
This task creates the build directory if it does not exist

**file**: This module creates the directory

##### Input variables 

    *path: path where the folders need to be created.

**when**: It runs when *file_status.stat.exists* == False, i.e. folder does not exists.

#### 3. Get the nodekey from vault and generate the enode

##### Input variables
    *VAULT_ADDR: Vault URI
    *VAULT_TOKEN: Vault token
**shell**: It reads the nodekey from vault and places at the specified address and then generates the enode using bootnode binary and write at the specified location.
**when**: It runs when *file_status.stat.exists* == False


#### 4. Get enode_data

**set_fact**: This modules sets the enode_data variable globally to enode data of the organisation.

#### 5. Get Validator node data

**set_fact**: This modules sets the enode_data_list variable globally to Get information about each validator node present in network.yaml and store it as a list of org, node.

----------------

### validator_vote.yaml
### Tasks

#### 1. Set enode_data_list to an empty list
This task initializes the enode_data_list to an empty array of string

#### 2. Get enode data
This task gets the enode data in the format of
peer_name
enodeval
p2p_ambassador
raft_ambassador
node_ambassador
peer_publicIP

**include_task**: enode_data.yaml
**loop**: loop over the organizations
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 3. creates nodelist data
**include_task**: nested_nodelist.yaml
**loop**: loop over peers in the organization
**loop_control**: Specify the conditions for controlling the loop.

    loop_var: loop variable used for iterating the loop.

### nested_nodelist.yaml
### Tasks

#### Check if enode is present in the build directory or not
 This task checks if enode is present in the build directory or not

**stat**: This module checks the file exist or not.
##### Input variables
    *path: path to the enode.
##### Output variables
    *file_status: output of the enode exists or not task

#### 5. Voting proposal
**include_task**: nested_validator_vote.yaml
**loop**: loop over peers in the organization
**loop_control**: Specify the conditions for controlling the loop.

    loop_var: loop variable used for iterating the loop.

### nested_validator_vote.yaml
### Tasks

#### 1. Voting by the validator nodes that were already in the network - IBFT consensus
 This task does the voting part by the existing validator nodes

#### 2. Voting by the new validator nodes that have been previously accepted in the same deployment - IBFT consensus
 This task does the voting part by the new validator nodes that have been already accepted

#### 3. Voting by the validator nodes that were already in the network - QBFT consensus
 This task does the voting part by the existing validator nodes

#### 4. Voting by the new validator nodes that have been previously accepted in the same deployment - QBFT consensus
 This task does the voting part by the new validator nodes that have been already accepted

#### 5. Adding the new validator address to the new_validator_nodes array for future voting participation
 This task adds the url of the new added validator node to be used in Task 2 if new validator nodes are pending to be accepted
