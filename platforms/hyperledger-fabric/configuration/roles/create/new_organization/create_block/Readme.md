## ROLE: create/new_organization/create_block
This role creates the create_block.sh script for modifying the latest configuration block and adding new organization crypto material.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

#### 1. Create JSON file with anchor peer information
This task calls create_json.yaml task
##### Input Variables
    *component_name: The name of resource
    *component_ns: The namespace of resourse
    *peer_name: The peer name of resource
    *org: The organization information
**template** : It contains the source and destinations details required for value file generation of access policy.
**src**: Contains the details of template file.
**dest**: Destination path and name of file to be generated.
**when**: Condition is specified here, runs only when the component type is orderer.

#### 2. Create create_block.sh script for channel
This task creates the create_block.sh script
##### Input Variables
    *component_name: The name of resource
    *component_ns: The namespace of resourse
    *peer_name: The peer name of resource
**template** : It contains the source and destinations details required for value file generation of access policy.
**src**: Contains the details of template file.
**dest**: Destination path and name of file to be generated.
**when**: Condition is specified here, runs only when the component type is orderer.

------------
### create_json.yaml
This task initiates the nested role for creating, fetching and modifying the config block

### Tasks
#### 1. Remove the old anchor file if generated in previous step
This task deletes the old anchor.json file if exists.
##### Input Variables

    *build_path: The path of build directory.
    *org_name: The name of the organization.

  
#### 2. Creates anchor file for anchor peer information
This task touches the anchor.json file.
##### Input Variables

    *build_path: The path of build directory.
    *org_name: The name of the organization.

#### 3. Create the values for anchor peer update
This task loops over the peer and add their information if they are anchor peer
##### Input Variables
    *build_path: The path of build directory.
    *org_name: The name of the organization.
    *peer: The peer information.
**loop**: loops over *peers* of the new organization
**loop_control**: Specify conditions for controlling the loop.
    
     loop_var: loop variable used for iterating the loop.
