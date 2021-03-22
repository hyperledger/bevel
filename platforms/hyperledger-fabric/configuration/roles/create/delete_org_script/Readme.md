## ROLE: create/delete_org_script
This role creates the create_block.sh script for modifying the latest configuration block and removing organization(s) crypto material.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

#### 1. Create build directory if it does not exist
This task creates build directory where create_block.sh script will be stored.

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


### Template

#### 1. organisation_script.tpl
This template modifies config block by removing organisation and calculates the difference between original config block and modified config block. This difference is then added to envolope along with header to create channel config update.