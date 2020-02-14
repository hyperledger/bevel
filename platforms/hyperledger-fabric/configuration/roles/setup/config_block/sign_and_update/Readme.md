## ROLE: setup/config_block/sign_and_update
 This role creates cli for the first peer of every existing organization in channel and get the modified config block signed by the admin of each organization.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

#### 1. Call valuefile when participant is new
This task calls valuefile
##### Input Variables
**include_tasks**: It includes the name of intermediatory task which is required for creating the value file for cli of peer, starting the cli and signing the block
**loop**: loops over result list fetched from *channel_participants*
**loop_control**: Specify conditions for controlling the loop.
    
     loop_var: loop variable used for iterating the loop.

#### 2. Call nested_sign_and_update for each peer
This task calls nested_sign_and_update
##### Input Variables
    *channel_name: Name of the channel
    org_query: Query to get peer names for organizations
    *org: First organization from the list of org_query
    peer: first peer of the organization
    config_block: name of the config block
**include_tasks**: It includes the name of intermediatory task which is required for creating the value file for cli of peer, starting the cli and signing the block
**loop**: loops over result list fetched from *channel_participants*
**loop_control**: Specify conditions for controlling the loop.
    
     loop_var: loop variable used for iterating the loop.

#### 2. Call nested_update_channel for each peer
This task calls nested_update_channel
##### Input Variables
    *channel_name: Name of the channel
    org_query: Query to get peer names for organizations
    *org: First organization from the list of org_query
    peer: first peer of the organization
    config_block: name of the config block
**include_tasks**: It includes the name of intermediatory task which is required for creating the value file for cli of peer, starting the cli and signing the block
**loop**: loops over result list fetched from *channel_participants*
**loop_control**: Specify conditions for controlling the loop.
    
     loop_var: loop variable used for iterating the loop.

------------
### nested_sign_and_update.yaml
This task initiates the signing of all the admins of existing network on the configuration block

### Tasks
#### 1. create value file for cli  {{ *peer_name* }}
This task creates valuefile for the peer.
##### Input Variables

    *component_type_name: Name of the organization
    *component_type: Name of the valuefile template   
    *component_name: Component name
    *peer_name: Name of the peer
    *peer_address: Peer gossip address
    *component_ns: Namespace
    *vault: Organization vault
    *channel_name: Channel name
    *release_dir: Path for the valufile
    storage_class: Storage class of of the organization
    

#### 2. start cli for the creator organization for the {{ *channel_name* }}
This task creates the cli for the valuefile created in last step.
##### Input Variables

    *build_path: The path of build directory.
    *config_file: Kubernetes file
    *playbook_dir: Path for the playbook directory
    *chart_source: Path for the charts directory 

#### 3. waiting for the fabric cli
This task wait for the fabric cli generated in the previous step to get into running state.
##### Input Variables

    namespace: Namespace of the organization
    kubeconfig: kubeconfig file
##### Output Variables
    get_cli: This variable stores the output of check if fabric cli is present query.

#### 4. Signing from the admin of  {{ *organization_name* }}
This task get the modified configuration block signed from the admin of existing organization.
##### Input Variables

    *config_file: Kubernetes file
    *kubernetes: Kubernetes cluster information of the organization

#### 5. delete the cli
This task creates the cli for the creator organization first peer.
##### Input Variables

    *config_file: Kubernetes file



------------
### nested_update_channel.yaml
This task get the block signed by the reator organization and then updates the channel by modified config block

### Tasks
#### 1. create value file for cli  {{ *peer_name* }}
This task creates valuefile for the peer.
##### Input Variables

    *component_type_name: Name of the organization
    *component_type: Name of the valuefile template   
    *component_name: Component name
    *peer_name: Name of the peer
    *peer_address: Peer gossip address
    *component_ns: Namespace
    *vault: Organization vault
    *channel_name: Channel name
    *release_dir: Path for the valufile
    storage_class: Storage class of of the organization
    

#### 2. start cli for the creator organization for the {{ *channel_name* }}
This task creates the cli for the valuefile created in last step.
##### Input Variables

    *build_path: The path of build directory.
    *config_file: Kubernetes file
    *playbook_dir: Path for the playbook directory
    *chart_source: Path for the charts directory 

#### 3. waiting for the fabric cli
This task wait for the fabric cli generated in the previous step to get into running state.
##### Input Variables

    namespace: Namespace of the organization
    kubeconfig: kubeconfig file
##### Output Variables
    get_cli: This variable stores the output of check if fabric cli is present query.

#### 4. Updating the channel with the new configuration block
This task get the modified configuration block signed from the admin of creator organization and updates the channel.
##### Input Variables

    *config_file: Kubernetes file
    *kubernetes: Kubernetes cluster information of the organization

#### 5. delete the cli
This task creates the cli for the creator organization first peer.
##### Input Variables

    *config_file: Kubernetes file


------------
### valuefile.yaml
This task performs a check if the new organization peers are up

### Tasks
#### 1. Check peer pod is up
This task creates valuefile for the peer.
##### Input Variables

    *org_query: New organization information 
    *peer_data: Peer information

**include_tasks**: It includes the name of intermediatory task which is required for creating the value file for cli of peer, starting the cli and signing the block
**loop**: loops over result list fetched from *channel_participants*
**loop_control**: Specify conditions for controlling the loop.
    
     loop_var: loop variable used for iterating the loop.  

------------
### peercheck.yaml
This task performs a check if the new organization peers are up

### Tasks
#### 1. Check peer pod is up
This task creates valuefile for the peer.
##### Input Variables

    *namespace: Namespace of the new organization 
    *kubeconfig: Kubeconfig information
