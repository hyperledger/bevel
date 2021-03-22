## ROLE: create/channels
 This task Creates the channels looking up the channel artifacts generated in previous steps.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Call valuefile when participant is creator
This task Call valuefile when participant is creator
##### Input Variables
    *channelcreator_query: Type of query
**include_tasks**: It includes the name of intermediatory task which is required for creating the vault auth value file.
**loop**: loops over result list fetched from *channelcreator_query*
**loop_control**: Specify conditions for controlling the loop.
    
    loop_var: loop variable used for iterating the loop.

------------
### valuefile.yaml
This task is the nested task for main.yaml which helps to create the channels_join files

### Tasks
#### 1. Check orderer pod is up
This tasks check if the orderer is already created or not.
##### Input Variables

    kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *namespace: Namespace of the component
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
    *org_query: Query to get peer names for organisations
    *peer_name: Name of the peer
##### Output Variables

    get_orderer: This variable stores the output of get orderer pod query.
	
  **until**: This condition checks until *get_peer.resources* exists
  **retries**: No of retries
  **delay**: Specifies the delay between every retry

#### 2. Check peer pod is up
This tasks check if the namespace is already created or not.
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
  
#### 3. Create Create_Channel value file
This task creates the value file for creator Organization
##### Input Variables
    *name: The name of the organisation
    *component_type: The type of resource
    *org_query: Query to get peer names for organisations
    type: "create_channel_job"
    component_name: The name of the component
    component_ns: NAmespace of the component
    peer_name: The name of the peer"
    git_url: The Url of the git Repo
    git_branch: Git repo branch name
    charts_dir: "Path to charts directory"
    vault: Details for Vault
    channeltx: path to channeltx file
    values_dir: "Destination where to generate file"
**include_role**: It includes the name of intermediatory role which is required for creating the namespace.
**loop**: loops over result list fetched from *org_query*
**loop_control**: Specify conditions for controlling the loop.
    loop_var: loop variable used for iterating the loop.

#### 4. Git Push
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

