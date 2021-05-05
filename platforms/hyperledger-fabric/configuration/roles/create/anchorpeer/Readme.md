## ROLE: create/anchorpeer
 This role creates helm value files for anchorpeers

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Call nested_anchorpeer for each organization
This task calls nested_anchorpeer
##### Input Variables
    *channel_name: Name of the channel
    *org_query: Query to get peer names for organisations
    *org: List of orgs
**include_tasks**: It includes the name of intermediatory task which is required for creating the vault auth value file.
**loop**: loops over result list fetched from *channelcreator_query*
**loop_control**: Specify conditions for controlling the loop.
    
     loop_var: loop variable used for iterating the loop.

------------
### nested_anchorpeer.yaml
This task initiates the nested anchorpeer role for each organization

### Tasks
#### 1. Check join channel job is done
This task checks for completion of join channel job
##### Input Variables
    kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *namespace: Namespace of the component
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
    *peer.name: Name of the peer
##### Output Variables

    get_peer: This variable stores the output of join_channel_job query. 	
	
  **until**: This condition checks until *get_peer.resources* exists
  **retries**: No of retries
  **delay**: Specifies the delay between every retry
  
#### 2. Creating value file of anchor peer for {{ *channel_name* }}
This task creates the value file for anchor peer update for each organization
##### Input Variables
    *name: The name of the organisation
    type: "join_channel_job"
    component_name: The name of the component
    component_ns: NAmespace of the component
    peer_name: The name of the peer"
    git_url: The Url of the git Repo
    git_branch: Git repo branch name
    charts_dir: "Path to charts directory"
    vault: Details for Vault
    anchortx: path to anchortx file
    values_dir: "Destination where to generate file"
**include_role**: It includes the name of intermediatory role which is required for creating the helm value file.
**loop**: loops over result list fetched from *participants.peers*.
**loop_control**: Specify conditions for controlling the loop.
    loop_var: loop variable used for iterating the loop.

#### 3. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
