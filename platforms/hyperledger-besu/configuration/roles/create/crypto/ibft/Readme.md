## ROLE: create/crypto/ibft
This role generates ibftConfigFile.json, key, key.pub, genesis.json and nodeAddress for each organization.
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check the crypto material to Vault
This task checks if key is present in the vault or not
**include_tasks**: check_vault
**loop**: loops over all the node in an organisation
**loop_control**: Specifies the condition for controlling the loop.
    loop_var: loop variable used for iterating over the loop.
##### Input Variables
     *component_ns: Organization namespace   
     *vault: Vault uri and token read from network.yaml
     *peers: Peers in the organization

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

#### 4. Create bin directory if it does not exist
This task creates the bin directory if it does not exist.
**file** : This module will create the directory if it does not exist with 755 permissions.
**when**: vault_check count is greater than zero.

#### 5. Check besu binary
This task check if besu is already present or not

**stat**: This module checks if besu is present or not with path variable.

##### Output Variables
    besu_stat_result: This variable stores the info on availibility on besu binary

#### 6. Geting the besu binary tar
This task creates a register temporary directory
##### Input Variables
    *network.version: Network version
    *tmp_directory.path: Temp Directory Path
**url**: The Url of the binary to download
**dest**: The destination path.
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.

#### 7. Unzipping the downloaded file
This task unzips the downloaded file.
##### Input Variables
    *network.version: Network version
    *tmp_directory.path: Temp Directory Path
**src**: The source of the downloaded binary
**dest**: The destination path for unzip.
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.

#### 8. Moving the besu from the extracted folder and place in it path
This task extracts the besu binary and place it at appropriate path.
##### Input Variables
    *bin_install_dir: The path of bin directory.
    *network.version: Network version
    *tmp_directory.path: Temp Directory Path
**src**: The source of the extracted binary
**dest**: The destination for the extracted binary.
**mode**: The permission for file is specified here.
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.

#### 9. Moving the lib folder from the extracted folder and place in it path
This task extracts the besu binary dependencies and place it at appropriate path.
##### Input Variables
    *bin_install_dir: The path of bin directory.
    *tmp_directory.path: Temp Directory Path
**src**: The source of the extracted binary
**dest**: The destination for the extracted binary.
**mode**: The permission for file is specified here.
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.

#### 10. Create ibftConfigFile.json
This task creates the ibftConfigFile.json using the ibftConfigFile.tpl file in templates .
##### Input Variables

    *build_path: Path of build directory.
**src**: Tepmlate file
**dest**: The destination path for file
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.

#### 11. Generate crypto for IBFT consensus
 This task generates the key, key.pub and genesis file for ibft consensus
**shell**: This task generates the key, key.pub and genesis file for each node placed in keys directories
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.
    
#### 12. Rename the directories created above with the elements of validator_node_list
This task rename the above created directories to the org_name/node_name     
**copy** : This module copies the content of numerical directories to org/node directory
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.

#### 13. Generate the nodeAddress for each peer
 This task creates the node address for each peer 
**shell**: This task generates the nodeAddress for each node placed in node directories
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.

#### 14. Delete the keys directories
 This tasks deletes the keys directories
**file** : This module deletes the numerical directories
**when**: Condition specified here, It runs only when, besu binary is not found or crypto material are not found in vault.

#### 15. Copy the crypto material to Vault
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

-------------
### check_vault
### Tasks
#### 1. Check if key already present in the vault
This tasks checks if key is already present in the vault

**shell**: This module runs the vault read command in a shell

##### Input Variables

    VAULT_ADDR: vault address
    VAULT_TOKEN: vault token

##### Output Variables

    vault_result: This variable stores whether the nodekey is present in vault or not.


#### 2. vault_check variable
**set_fact**: This module sets the variable *generate_crypto* globally.
**when**: It runs when *vault_result.failed* == True, i.e. nodekey of any of the node is not in vault.

----------------
### add_to_vault
### Tasks
#### 1. Add the crypto material to the vault
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml

--------------------------
### validator_node_data.yaml

#### 1. Get validator node data
This task fetch (org,node) pairs for each validating node present in all organizations of the network
**when**: peer.type == 'validator'
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.
