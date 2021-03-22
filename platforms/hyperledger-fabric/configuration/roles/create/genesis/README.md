## ROLE: create/genesis
 This role creates the network genesis block and saves it to HashiCorp Vault.

### Tasks
**NOTE: Variables with * are fetched from the playbook which is calling this role**
#### 1. Remove old genesis block
Removes the old genesis block from the build directory (if any was previously created)
##### Input Variables
    *build_path: Path of the build directory
**path**: Path where the genesis block is stored
**state**: Specifies the state for the file - `absent`, meaning the file will be removed    

#### 2. Create genesis block
Creates network genesis block 
##### Input variables
    *build_path: The path of build directory, where the genesis block will be saved
**shell**: Goes to build path and creates the genesis block using the `configtx` binary. It is then encoded in BASE64 and stored in the build path.

#### 3. Write genesis block to Vault
Writes the BASE64 encoded genesis block to the Vault path of the orderer organizations.
**shell**: Executes a `vault cli` command to write the BASE 64 encoded genesis block to the Vault.
