## ROLE: create/channels_join
 This role creates helm value files for create_channel and join_channel jobs

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Call nested_channel_join for each peer
This task calls nested_channel_join
##### Input Variables
    *channel_name: Name of the channel
    *org_query: Query to get peer names for organisations
    *org: List of orgs
**include_tasks**: It includes the name of intermediatory task which is required for creating the vault auth value file.
**loop**: loops over result list fetched from *channelcreator_query*
**loop_control**: Specify conditions for controlling the loop.
    
     loop_var: loop variable used for iterating the loop.

#### 2. Call check for each peer
This task calls check.yaml
##### Input Variables
    *channel_name: Name of the channel
    *org_query: Query to get peer names for organisations
    *org: List of orgs
**include_tasks**: It includes the name of intermediatory task which is required for creating the vault auth value file.
**loop**: loops over result list fetched from *participants query*
**loop_control**: Specify conditions for controlling the loop.
    
     loop_var: loop variable used for iterating the loop.

------------
### nested_channel_join.yaml
This task initiates the nested join channel role to internally join the peers in various permutations

### Tasks
#### 1. Check create channel job is done
This task check or wait for the create channel job to complete.
##### Input Variables

    kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *namespace: Namespace of the component
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
    *org_query: Query to get peer names for organisations
    *peer_name: Name of the peer
##### Output Variables

    get_peer: This variable stores the output of get peer pod query.
	
  **until**: This condition checks until *get_peer.resources* exists
  **retries**: No of retries
  **delay**: Specifies the delay between every retry
  
#### 2. join channel {{ *channel_name* }}
This task creates the value file for each participationg peer.
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
    channeltx: path to channeltx file
    values_dir: "Destination where to generate file"
**include_role**: It includes the name of intermediatory role which is required for creating the helm value file.
**loop**: loops over result list fetched from *participants.peers*.
**loop_control**: Specify conditions for controlling the loop.
    loop_var: loop variable used for iterating the loop.

#### 3. Git Push
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

-------------------------------------------------------------
#### check.yaml
#### 1. Check create channel job is done
This task check or wait for the create channel job to complete.
##### Input Variables

    kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *namespace: Namespace of the component
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
    *org_query: Query to get peer names for organisations
    *peer_name: Name of the peer
##### Output Variables

    get_peer: This variable stores the output of get peer pod query.
	
  **until**: This condition checks until *get_peer.resources* exists
  **retries**: No of retries
  **delay**: Specifies the delay between every retry