
## chaincode/Upgrade
This role creates helm value file for the deployment of chaincode_upgrade job
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Create value file for chaincode upgradation
This task creates value file for chaincode upgradation.
##### Input Variables

    channelcreator_query:  query based on type, "participants[?type=='creator']"
    org_query: query based on name "organizations[?name=='{{participant.name}}']"
    org: query result of org_query"{{ network | json_query(org_query) | first }}"
**include_tasks**: It includes the name of intermediatory task which is required for creating the value file, here `valuefile.yaml`.
**loop**: loops over peers list fetched from *{{ component_peers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

-------
### valuefile.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)

#### 1. 'Check/Wait for install-chaincode job'
This tasks checks/Wait for install-chaincode job.

##### Input Variables

    kind: The kind of task i.e. here `Job`
    name: Name of join channel job. Format: "installchaincode-{{ peer.name }}-{{ peer.chaincode.name }}-{{ peer.chaincode.version }}"
    namespace: Namespace of component
    label_selectors:
      - app = installchaincode-{{ peer.name }}-{{ peer.chaincode.name }}-{{ peer.chaincode.version }}
    kubeconfig: The config file of the cluster
    kubernetes: The kubernetes patch from network yaml
    context: The context of kubernetes

##### Output Variables

    component_data: This variable stores the output of install-chaincode query.
	
  **until**: This condition checks until *component_data.resources* variable exists and is not empty.
  **retries**: No of retries
  **delay**: Specifies the delay between every retry
  
#### 2. Check for instantiate-chaincode job
This tasks checks if instantiate-chaincode is already run.

##### Input Variables

    kind: The kind of task i.e. here `Job`
    name: Name of instantiate chaincode job. Format: instantiatechaincode-{{ peer.name }}-{{peer.chaincode.name}}-{{ peer.chaincode.version }}
    namespace: Namespace of component
    label_selectors:
      - app = instantiatechaincode-{{ peer.name }}-{{peer.chaincode.name}}-{{ peer.chaincode.version }}
    kubeconfig: The config file of the cluster
    context: The context of kubernetes
##### Output Variables

    instantiate_chaincode: This variable stores the output of instantiate-chaincode query.

#### 3. Create value file for chaincode upgradation
This is the nested Task for chaincode upgradation.
##### Input Variables

    *name: "Name of the organisation"
    type: "upgrade_chaincode_job"
    *component_name: Name of the component, "upgrade-{{ org.name | lower }}-{{ peer.name }}-{{item.channel_name|lower}}-{{peer.chaincode.name}}{{peer.chaincode.version}}"
    *namespace: "Namespace of org , Format: {{ org.name |lower }}-net"
    *peer_name: "Name of the peer"
    *peer_address: "Gossip peer Address"    
    *git_url: "Git SSH url"
    *git_branch: "Git Branch Name"
    *charts_dir: "Path of Charts Directory"
    *vault: "Vault Details"
    *component_chaincode: "Chaincode Data"
    *values_dir: "Destination directory"
**include_role**: It includes the name of intermediatory role which is required for creating the helm value file, here `helm_component`.
**loop**: loops over peers list fetched from *{{ org.services.peers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.
**when** : It runs when chaincode is not upgraded i.e. *upgrade_chaincode.resources.length* == 0.

#### 4. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
