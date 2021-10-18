## ROLE: create/crypto/tessera
This role generates the crypto material for tessera transaction manager


### check_vault.yaml
### Task
#### 1. Check the crypto material to Vault
This tasks checks the crypto material in the vault

##### Input Variables

    VAULT_ADDR: vault address
    VAULT_TOKEN: vault token

#### Output Variables

    vault_result: This variable stores whether the crypto material is present in vault or not.
   
 ----------------------------------------------------------------------------------------------------------

 ### main.yaml

### Tasks
(Variables with * are fetched from the playbook which is calling this role)


#### 1. Check for the crypto material in the vault
This tasks checks the crypto material in the vault and wait for namespace creation

#### Input Variables

Get vars from *network.yaml*



#### 2. Create tessera crypto file
This task generates tessera crypto helmrelease file

##### Input Variables
   
**include_role**: It includes the name of intermediary role which is required for creating the crypto material for each peer.
**loop**: loops over all the peers in an organisation
**loop_control**: Specifies the condition for controlling the loop.

    loop_var: loop variable used for iterating over the loop.



**when**: This task runs only when *generate_crypto_tessera is defined* 



#### 3. Push the created deployment files to repository
This task pushes the created deployment files to repository

**include_role**: It includes the name of intermediary role which is required for pushing the files to repository.


**when**: This task runs only when *generate_crypto_tessera is defined* 



#### 4. Check if tessera crypto job is completed
This task checks if tessera crypto job is completed

Get vars from *network.yaml*


**include_role**: It includes the name of intermediary role which is required for checking if tessera job is complete.