## ROLE: add_new_peer
This role creates the generate_crypto.sh script for new peers.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Set new_peer_list to an empty list
This task initializes the new_peer_list to empty.

**set_fact**: This module sets the variable assignment as globally accessible variable

#### 2. Count new peers
This task loops over the peers and add the peer data in new_node_list.

**set_fact**: This module sets the variable assignment as globally accessible variable

#### 3. Create generate_crypto script file for new peers
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