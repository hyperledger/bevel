## ROLE: create/constellation
This role creates the helm value file of constellation transaction manager for each node of all organizations.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)    

#### 1. Set enode_data to an empty list
This task initializes the enode_data variable to an empty string

**set_fact**: This module sets the variable assignment as globally accessible variable

#### 2. Get enode data
This task gets the enode data in the format of
peer_name
enodeval
p2p_ambassador
raft_ambassador

**include_task**: enode_data.yaml
**loop**: loop over the organizations
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 3. Create Value files for Constellation TM for each node
This task creates the value file by calling the helm_component role
##### Input Variables

    *genesis: "The genesis block fetched from .build/genesis.block.base64" 
    *component_name: "The name of the component"
    type: "constellation"
**include_role**: It includes the name of intermediatory role which is required for creating the helm value file, here helm_component
**loop**: loops over peers list fetched using *{{ peers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 4. Git Push
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

**include_role**: It includes the name of intermediatory role which is required for creating the vault auth value file.
