## ROLE: create/crypto/orion
This role generates orion nodekey for each peer in organizations.
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

#### 2. Create build directory if it does not exist
This task creates the build directory if it does not exist.
**file** : This module will create the directory if it does not exist with 755 permissions.
**when**: vault_check count is greater than zero.

#### 3. Create bin directory if it does not exist
This task creates the bin directory if it does not exist.
**file** : This module will create the directory if it does not exist with 755 permissions.
**when**: vault_check count is greater than zero.

#### 4. Check orion binary
This task check if orion is already present or not

**stat**: This module checks if orion is present or not with path variable.

##### Output Variables
    orion_stat_result: This variable stores the info on availibility on orion binary

#### 5. Geting the orion binary tar
This task creates a register temporary directory
##### Input Variables
    *network.version: Network version
    *tmp_directory.path: Temp Directory Path
**url**: The Url of the binary to download
**dest**: The destination path.
**when**: Condition specified here, It runs only when, orion binary is not found or crypto material are not found in vault.

#### 6. Unzipping the downloaded file
This task unzips the downloaded file.
##### Input Variables
    *network.version: Network version
    *tmp_directory.path: Temp Directory Path
**src**: The source of the downloaded binary
**dest**: The destination path for unzip.
**when**: Condition specified here, It runs only when, orion binary is not found or crypto material are not found in vault.

#### 7. Moving the orion from the extracted folder and place in it path
This task extracts the orion binary and place it at appropriate path.
##### Input Variables
    *bin_install_dir: The path of bin directory.
    *network.version: Network version
    *tmp_directory.path: Temp Directory Path
**src**: The source of the extracted binary
**dest**: The destination for the extracted binary.
**mode**: The permission for file is specified here.
**when**: Condition specified here, It runs only when, orion binary is not found or crypto material are not found in vault.

#### 8. Moving the lib folder from the extracted folder and place in it path
This task extracts the orion binary dependencies and place it at appropriate path.
##### Input Variables
    *bin_install_dir: The path of bin directory.
    *tmp_directory.path: Temp Directory Path
**src**: The source of the extracted binary
**dest**: The destination for the extracted binary.
**mode**: The permission for file is specified here.
**when**: Condition specified here, It runs only when, orion binary is not found or crypto material are not found in vault.

#### 15. Generate orion nodekey for every node
This tasks generates nodekey for each peer
**include_tasks**: generate_nodekey
**loop**: loops over all the organisation
**loop_control**: Specifies the condition for controlling the loop.
    loop_var: loop variable used for iterating over the loop.
##### Input Variables
     *component_ns: Organization namespace   
     *vault: Vault uri and token read from network.yaml
     *peers: Peers in the organization
**when**: Condition specified here, It runs only when, orion binary is not found or crypto material are not found in vault.

-------------
### check_vault
### Tasks
#### 1. Check if key already present in the vault
This tasks checks if key is already present in the vault

**shell**: This module runs the vault kv get command in a shell
**loop**: loops over all the node in an organisation
**loop_control**: Specifies the condition for controlling the loop.
    loop_var: loop variable used for iterating over the loop.

##### Input Variables

    VAULT_ADDR: vault address
    VAULT_TOKEN: vault token

##### Output Variables

    vault_result: This variable stores whether the nodekey is present in vault or not.


#### 2. vault_check variable
**set_fact**: This module sets the variable *generate_crypto* globally.
**when**: It runs when *vault_result.failed* == True, i.e. nodekey of any of the node is not in vault.

----------------
### generate_nodekey
### Tasks

#### 1. Ensure that the folder structure exists
This task creates the folder structure if it does not exist.
**file** : This module will create the directory if it does not exist with 755 permissions.
**loop**: loops over all the node in an organisation
**loop_control**: Specifies the condition for controlling the loop.
    loop_var: loop variable used for iterating over the loop.
**when**: vault_check count is greater than zero.

#### 2. Generate the Orion nodeKey 
 This task creates the Orion nodeKey for each peer 
**shell**: This task generates the password file and nodeKey for each node
**loop**: loops over all the node in an organisation
**loop_control**: Specifies the condition for controlling the loop.
    loop_var: loop variable used for iterating over the loop.
**when**: Condition specified here, It runs only when, orion binary is not found or crypto material are not found in vault.

#### 3. Add the crypto material to the vault
**loop**: loops over all the node in an organisation
**loop_control**: Specifies the condition for controlling the loop.
    loop_var: loop variable used for iterating over the loop.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml


