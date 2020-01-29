## ROLE: create/new_organization/create_block
This role creates the create_block.sh script for modifying the latest configuration block and adding new organization crypto material.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Create create_block.sh script for channel
This task creates the create_block.sh script
##### Input Variables
    *component_name: The name of resource
    *component_ns: The namespace of resourse
    *peer_name: The peer name of resource
**template** : It contains the source and destinations details required for value file generation of access policy.
**src**: Contains the details of template file.
**dest**: Destination path and name of file to be generated.
**when**: Condition is specified here, runs only when the component type is orderer.
