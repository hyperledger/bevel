## ROLE: create/ibft
This role creates the helm value file of orion transaction manager for each node of all organizations.
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)    

#### 1. Set enode_data to an empty list
This task initializes the enode_data variable to an empty string

**set_fact**: This module sets the variable assignment as globally accessible variable

#### 2. Set nodelist to an empty list
This task initializes the enode_data variable to an empty string

**set_fact**: This module sets the variable assignment as globally accessible variable

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

#### 4. Get nodelist data
This task creates a file for each peer consisting of the peernode url of other peers

**include_task**: enode_data.yaml
**loop**: loop over the organizations
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 5. Create Value files for orion TM for each node
This task creates the value file by calling the helm_component role
##### Input Variables

    *genesis: "The genesis file fetched from the url defined by the network.yaml" 
    *component_name: "The name of the component"
    type: "node_orion"
**include_role**: It includes the name of intermediatory role which is required for creating the helm value file, here helm_component
**loop**: loops over peers list fetched using *{{ peers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 6. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"
    GIT_REPO: "The name of GIT REPO"
    GIT_USERNAME: "Username of Repo"
    GIT_PASSWORD: "Password for Repo"
    GIT_EMAIL: "Email for git config"
    GIT_BRANCH: "Branch Name"
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    msg: "Message for git commit"
These variables are fetched through network.yaml using *item.gitops*
**include_role**: It includes the name of intermediatory role which is required for pushing  the value file to git repository.

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

### nodelist.yaml
### Tasks

#### 1. creates nodelist data
**include_task**: nested_nodelist.yaml
**loop**: loop over peers in the organization
**loop_control**: Specify the conditions for controlling the loop.

    loop_var: loop variable used for iterating the loop.

-------------------

### nested_nodelist.yaml
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

#### 3. Enode_data_list loop

##### Input variables
    *VAULT_ADDR: Vault URI
    *VAULT_TOKEN: Vault token
**when**: It runs when *file_status.stat.exists* == False
