## ROLE: setup/config_block/fetch
 This role fetches the latest config block from the channel and add new organization crypto material to it.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Call nested_fetch_role for creator organization peer
This task calls nested_fetch_role
##### Input Variables
    *channel_name: Name of the channel
    *org_query: Query to get peer names for organisations
    *org: List of orgs
**include_tasks**: It includes the name of intermediatory task which is required for creating the vault auth value file.
**loop**: loops over result list fetched from *channel_participants*
**loop_control**: Specify conditions for controlling the loop.
    
     loop_var: loop variable used for iterating the loop.

------------
### nested_fetch_role.yaml
This task initiates the nested role for creating, fetching and modifying the config block

### Tasks
#### 1. start cli for the creator organization for the {{ *channel_name* }}
This task creates the cli for the creator organization first peer.
##### Input Variables

    *build_path: The path of build directory.
    *config_file: Kubernetes file
    *playbook_dir: Path for the playbook directory
    *chart_source: Path for the charts directory 

  
#### 2. waiting for the fabric cli
This task wait for the fabric cli generated in the previous step to get into running state.
##### Input Variables

    namespace: Namespace of the organization
    kubeconfig: kubeconfig file
##### Output Variables
    get_cli: This variable stores the output of check if fabric cli is present query.

#### 3. fetch and modify config block from {{ *channel_name* }}
This task fetches the config block from the channel and add the new organization material into the block.
##### Input Variables

    *config_file: Kubernetes file
    *kubernetes: Kubernetes cluster information of the organization
##### Output Variables
    config_stat_result: This variable stores the output of configtxgen check query.

#### 4. delete the cli
This task creates the cli for the creator organization first peer.
##### Input Variables

    *config_file: Kubernetes file