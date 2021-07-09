## ROLE: create/crypto/tessera
This role generates the crypto material for tessera transaction manager

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Call nested_main for each node in an organisation
This task calls nested_main
##### Input Variables
    *node_name: Name of the node
**include_tasks**: It includes the name of intermediary task which is required for creating the crypto material for each peer.
**loop**: loops over all the peers in an organisation
**loop_control**: Specifies the condition for controlling the loop.

    loop_var: loop variable used for iterating over the loop.

---------------

### nested_main.yaml
This task initaiates the nested_main role for each node in the organisation
### Tasks
#### 1. Check if tm key already present in the vault
This tasks checks if tm key is already present in the vault

**shell**: This module runs the vault kv get command in a shell

##### Input Variables

    VAULT_ADDR: vault address
    VAULT_TOKEN: vault token

##### Output Variables

    vault_tmkey_result: This variable stores whether the tm key is present in vault or not.

#### 2. Create build directory if it does not exist and the tm key is not present in vault
This task creates the build directory if it does not exist

**file**: This module creates the build directory if it does not exist  

**when**: This task runs only when *vault_tmkey_result.failed* == True, i.e, when tm key is not present in the vault  

#### 3. Checks if tessera jar file is present in the build folder
This tasks checks if tessera jar is already present in the build folder.  

**when**: This task runs only when *vault_tmkey_result.failed* == True, i.e, when tm key is not present in the vault  

**stat**: This module checks the status of the file

##### Output Variables

    tessera_app_jar_result: This variable stores whether the tessera jar is present in the build directory

#### 4. Download the tessera jar
This task downloads the Tessera transaction manager jar

**get_url**: This module downloads the jar and puts it in the build directory

**when**: It runs when *vault_tmkey_result.failed* == True and *tessera_app_jar_result.stat.exists* == False, i.e. when tessera app jar is not present in the build directory and the tm key is not present in the vault

#### 5. Generate crypto for tessera transaction manager
This task generates crypto material tessera transaction manager

**shell**: This module starts a shell which runs commands to generate crypto


**when**: It runs when *vault_tmkey_result.failed* == True, i.e. when tm key is not found in vault

#### 6. Copy the crypto material to Vault
This task copies the above generated crypto material to the vault

**shell**: This module is used to put the generated crypto material in the vault

**when**: It runs when *vault_tmkey_result.failed* == True, i.e. when tm key is not found in vault.

#### Note: 
vars folder has variable like tessera jar repo link