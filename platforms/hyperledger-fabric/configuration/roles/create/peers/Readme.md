## ROLE: peers
This role creates the helm value file for peers of organisations and write couch db credentials to the vault.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Write the couchdb credentials to Vault
This task writes the couchdb credentials for each organizatiosn to the vault
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *namespace: The namespace of resource
**shell**: It writes the  couchdb credentials for each organizatiosn to the vault.

    
#### 2. Create Value files for Organization Peers
This task is the nested task for main.yaml which helps to iterate over all peers.
##### Input Variables

    *name: Name of the item
    *peer_name: The name of the peer
    *peer_ns: Namespace of the peer
    *component_name: "The name of the component"
    type: "value_peer"
**include_role**: It includes the name of intermediatory role which is required for creating the helm value file, here helm_component
**loop**: loops over peers list fetched using *{{ component_services.peers }}* from network yaml
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

**include_role**: It includes the name of intermediatory role which is required for creating the vault auth value file.

#### 4. Check peer pod is up
This tasks check if the namespace is already created or not.
##### Input Variables

    kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *namespace: Namespace of the component
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
    *org_query: Query to get peer names for organisations
    *peer_name: Name of the peer
    
**include_role**: It includes the name of intermediatory role which is required for creating the vault auth value file.