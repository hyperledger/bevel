[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/validator_node
This role creates the new enode data for the new validator nodes for an existing validator organization and the voting for its acceptance.
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)    

#### 1. Set enode_validator_list, new_validator_nodes and node_list to an empty list
This task initializes the enode_validator_list, new_validator_nodes and node_list variables to an empty array of string

**set_fact**: This module sets the variable assignment as globally accessible variable

#### 2. Check if the validator node is already in the network
This task tries to get enode from the vault for the new validator just to check if it already exists in the network 

**include_task**: check_vault.yaml
**loop**: loop over the validator organization
**loop_control**: validator new needs to have the variable status as new.
                
    loop_var: loop variable used for iterating the loop.

#### 3. Get validator nodes data
This task gets the enode data in the format of
org_name
peer_name
org_type

**include_task**: node_data.yaml
**loop**: loop over the organizations
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 4. Create build directory if it does not exist
This task creates the build directory if it does not exist.
**file** : This module will create the directory if it does not exist with 755 permissions.
**when**: vault_check count is greater than zero.

#### 5. Create bin directory if it does not exist
This task creates the bin directory if it does not exist.
**file** : This module will create the directory if it does not exist with 755 permissions.
**when**: vault_check count is greater than zero.

#### 6. Check besu binary
This task check if besu is already present or not

**stat**: This module checks if besu is present or not with path variable.

#### 7. Getting the besu binary tar
This task creates a register temporary directory
##### Input Variables
    *network.version: Network version
    *tmp_directory.path: Temp Directory Path
**url**: The Url of the binary to download
**dest**: The destination path.
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.

#### 8. Unzipping the downloaded file
This task unzips the downloaded file.
##### Input Variables
    *network.version: Network version
    *tmp_directory.path: Temp Directory Path
**src**: The source of the downloaded binary
**dest**: The destination path for unzip.
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.

#### 9. Moving the besu from the extracted folder and place in it path
This task extracts the besu binary and place it at appropriate path.
##### Input Variables
    *bin_install_dir: The path of bin directory.
    *network.version: Network version
    *tmp_directory.path: Temp Directory Path
**src**: The source of the extracted binary
**dest**: The destination for the extracted binary.
**mode**: The permission for file is specified here.
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.

#### 10. Moving the lib folder from the extracted folder and place in it path
This task extracts the besu binary dependencies and place it at appropriate path.
##### Input Variables
    *bin_install_dir: The path of bin directory.
    *tmp_directory.path: Temp Directory Path
**src**: The source of the extracted binary
**dest**: The destination for the extracted binary.
**mode**: The permission for file is specified here.
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.

#### 11. Create organization directory if it does not exist
 This task creates the organization directories for crypto material if not exists.
**file** : This module will create the directory if it does not exist with 755 permissions.
**when**: *add_new_org* is true.

#### 12. Generate the nodeAddress for and key.pub for new validator
 This task creates the node address and pub key for each new peer 

**include_task**: enode_data.yaml
**shell**: This task generates the nodeAddress and public key for the new validator node placed in node directories
**loop**: loop over the new peers of validator organizations
**loop_control**: validator new needs to have the variable status as new.
                
    loop_var: loop variable used for iterating the loop.

#### 13. Touch file to store information for validators
 This file stores the address of the validator nodes
**file** : This module will create the file if it does not exist
**when**: *generate_crypto* count is *True*.

#### 14. Touch toEncode.json file
 This file used by besu binary to generate the extra data information
**file** : This module will create the flie if it does not exist.
**when**: *generate_crypto* count is *True*.

#### 15. Get node data
 Create the validator address array 
**shell**: This task generates the validator address array 
**when**: *generate_crypto* count is *True*.

#### 16. Voting for the new validator node to be added
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

#### 1. Copy the crypto material to Vault
This task adds the crypto material to Vault
**include_tasks**: add_to_vault
**loop**: loops over all the node in an organisation
**loop_control**: Specifies the condition for controlling the loop.
    loop_var: loop variable used for iterating over the loop.
##### Input Variables
     *component_ns: Organization namespace   
     *vault: Vault uri and token read from network.yaml
     *peers: Peers in the organization
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.

#### 2. Set enode_data_list to an empty list
This task initializes the enode_data_list to an empty array of string

#### 3. Get enode data
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

#### 4. creates nodelist data
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

#### 1. Voting by the validator nodes that were already in the network
 This task does the voting part by the existing validator nodes

#### 2. Voting by the new validator nodes that have been previously accepted in the same deployment
 This task does the voting part by the new validator nodes that have been already accepted

#### 3. Adding the new validator address to the new_validator_nodes array for future voting participation
 This task adds the url of the new added validator node to be used in Task 2 if new validator nodes are pending to be accepted
    