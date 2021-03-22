## ROLE: crypto-script
This role creates the generate_crypto.sh script for orderers and organizations.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Create generate_crypto script file for orderers
This task creates the generate_crypto.sh file for orderers
##### Input Variables
    *component_name: The name of resource
    *component_ns: The namespace of resourse
    *component_country: The specified country of resourse
    *component_state:The specified city of resource
    *component_location: The location of resource
    *peer_name: The peer name of recource
**template** : It contains the source and destinations details required for value file generation of access policy.
**src**: Contains the details of template file.
**dest**: Destination path and name of file to be generated.
**when**: Condition is specified here, runs only when the component type is orderer.

#### 2. Create generate_crypto script file for orderer organisations
This task creates the generate_crypto.sh file for orderer organisations
##### Input Variables
    *component_name: The name of resource
    *component_ns: The namespace of resourse
    *component_country: The specified country of resourse
    *component_state:The specified city of resource
    *component_location: The location of resource
**template** : It contains the source and destinations details required for value file generation of access policy.
**src**: Contains the details of template file.
**dest**: Destination path and name of file to be generated.
**when**: Condition is specified here, runs only when the component type is orderer.

#### 2. Create generate_crypto script file for organisations
This task creates the generate_crypto.sh file for organisations
##### Input Variables
    *component_name: The name of resource
    *component_ns: The namespace of resourse
    *component_country: The specified country of resourse
    *component_state:The specified city of resource
    *component_location: The location of resource
    *peer_name: The peer name of recource
**template** : It contains the source and destinations details required for value file generation of access policy.
**src**: Contains the details of template file.
**dest**: Destination path and name of file to be generated.
**when**: Condition is specified here, runs only when the component type is peer.