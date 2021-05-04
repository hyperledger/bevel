## chaincode/install
This role creates helm value file for the deployment of chaincode_install job.
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Create value file for chaincode installation for fabric version 1.4.x
This task create value file for chaincode installation.
##### Input Variables

    *name: Name of Item
    *namespace: Namespace of Item
    *component_type: Type of component
    *component_peers: Peers Details Patch fetched using {{ item.services.peers }}
    *vault: Vault details from Network yaml
    *kubernetes: Kubernetes Cluster info
    *git_url: Git Repo SSH url
    *git_branch: Git branch name
    *charts_dir: Charts directory path
    *values_dir: Destination directory which stores the generated value file.
**include_tasks**: It includes the name of intermediatory task which is required for creating the value file, here `valuefile.yaml`.
**loop**: loops over peers list fetched from *{{ component_peers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 2. Create value file for chaincode installation for first pod in fabric version 2.2.x
This task create value file for chaincode installation.
##### Input Variables

    *name: Name of Item
    *namespace: Namespace of Item
    *component_type: Type of component
    *component_peers: Peers Details Patch fetched using {{ item.services.peers }}
    *vault: Vault details from Network yaml
    *kubernetes: Kubernetes Cluster info
    *git_url: Git Repo SSH url
    *git_branch: Git branch name
    *charts_dir: Charts directory path
    *values_dir: Destination directory which stores the generated value file.
**include_tasks**: It includes the name of intermediatory task which is required for creating the value file, here `valuefile.yaml`.
**loop**: loops over peers list fetched from *{{ component_peers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

#### 3. 'Waiting for chaincode to be installed on peer0'
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

#### 4. Create value file for chaincode installation for fabric version 2.2.x
This task create value file for chaincode installation.
##### Input Variables

    *name: Name of Item
    *namespace: Namespace of Item
    *component_type: Type of component
    *component_peers: Peers Details Patch fetched using {{ item.services.peers }}
    *vault: Vault details from Network yaml
    *kubernetes: Kubernetes Cluster info
    *git_url: Git Repo SSH url
    *git_branch: Git branch name
    *charts_dir: Charts directory path
    *values_dir: Destination directory which stores the generated value file.
**include_tasks**: It includes the name of intermediatory task which is required for creating the value file, here `valuefile.yaml`.
**loop**: loops over peers list fetched from *{{ component_peers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

-------
### valuefile.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check/Wait for anchorpeer update job
This task checks for anchor peer.
##### Input Variables

    *name: Name of Item
    kind: The kind of task i.e. here `Job`
    name: Name of join channel job. Format: "joinchannel-{{ peer.name }}-{{ channel_name }}"
    namespace: Namespace of component
    label_selectors:
      - app = joinchannel-{{ peer.name }}-{{ channel_name }}
    kubeconfig: The config file of the cluster
    context: The context of kubernetes
    channel_name: Name of the channel
**loop**: loops over peers list fetched from *{{ component_peers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.
##### Output Variables

    component_data: This variable stores the output of joinchannel query.
	
  **until**: This condition checks until *component_data.resources* variable exists and is not empty.
  **retries**: No of retries
  **delay**: Specifies the delay between every retry
  
#### 2. Check for install-chaincode job
This tasks checks if install-chaincode is already running or not.

##### Input Variables

    kind: The kind of task i.e. here `Job`
    name: Name of install chaincode job. Format: "installchaincode-{{ peer.name }}-{{ peer.chaincode.name }}-{{ peer.chaincode.version }}"
    namespace: Namespace of component
    label_selectors:
      - app = installchaincode-{{ peer.name }}-{{ peer.chaincode.name }}-{{ peer.chaincode.version }}
    kubeconfig: The config file of the cluster
    context: The context of kubernetes
##### Output Variables

    install_chaincode: This variable stores the output of install-chaincode query.
#### 3. Write the git credentials to Vault
This task writes git credentials to vault.
##### Input Variables
    *namespace: Namespace of the component
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**shell** : This command writes git credentials to vault. Password is fetched using `{{ peer.chaincode.repository.password }}`
**vault* : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 

#### 4. Create value file for chaincode installation - nested
This is the nested Task for chaincode installation.
##### Input Variables

    *orderer_address: URI address of orderer
    type: "install_chaincode_job"
    *peer_name: Name of the peer
    *peer_address: Gossip peer address
    *component_name: component name in format : "chaincode-install-{{ name }}-{{ peer.name }}-{{ peer.chaincode.version }}"
    *component_chaincode: chaincode of the peer
**include_role**: It includes the name of intermediatory role which is required for creating the helm value file, here `helm_component`.
**loop**: loops over peers list fetched from *{{ component_peers }}* from network yaml
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.
**when** : It runs when install chaincode is not found.

#### 5. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
