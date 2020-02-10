## ROLE: crypto/genesis_nodekey
This role generates genesis.json and nodekey/enode for each organization.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if nodekey is present in vault
This task checks if nodekey is present in the vault or not
##### Input Variables

    component_ns: Organization namespace   
##### Output Variables

    vault_check: This variable the count of nodes for which the nodekey is absent.

#### 2. Fetching data of validator nodes in the network from network.yaml
This task fetch (org,node) pairs for each validating node present in all organizations of the network
**when**: vault_check count is greater than zero.
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

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
