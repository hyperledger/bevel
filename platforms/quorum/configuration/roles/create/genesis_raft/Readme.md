## ROLE: genesis_raft
This role generates genesis.json file

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Fetch the node address
This task fetch node address of each node of all organizations.
##### Input Variables

    *vault*: This variable contains the vault information of the specificed organization
**include_tasks**: This module includes the nested task
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 2. Create genesis.yaml
This task creates the genesis file from the template.
**template**: 

#### 3. Read the genesis.yaml file
This task reads the genesis file and put it in the variable.
**file** : This module will create the directory if it does not exist with 755 permissions.
**when**: vault_check count is greater than zero.

#### 4. Create genesis.yaml file
This task converts the above read variable into json format and writes it in the gensis.json file
**shell**: This task generates the nodekey for each node placed in numerical directories
**when**: vault_check count is greater than zero.
