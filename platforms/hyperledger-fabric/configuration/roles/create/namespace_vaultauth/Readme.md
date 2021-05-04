## namespace_vaultauth
This role creates value files for namespaces, vault reviewer service accounts, vault auth service accounts and cluster role binding of organizations and ordererers.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check namespace is created
This tasks check if the namespace is already created or not.
##### Input Variables

    kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    get_namespace: This variable stores the output of namespace query.

#### 2. Create namespaces
This task creates the value file of Namespace for Organizations
##### Input Variables
    component_type: The type of resource
**include_role**: It includes the name of intermediatory role which is required for creating the namespace.
**when**: *get_namespace* variable is zero i.e. namespace doesn't exist. 

#### 3. Create Vault reviewer
This task creates the value file of Vault Reviewer Service Account for Organizations
##### Input Variables
    component_type: The type of resource
**include_role**: It includes the name of intermediatory role which is required for creating the Vault Reviewer value file.
**when**: *get_namespace* variable is zero i.e. Vault Reviewer doesn't exist. 

#### 4. Create Vault Auth
This task creates the value file of Vault Auth for Organizations
##### Input Variables
    component_type: The type of resource
**include_role**: It includes the name of intermediatory role which is required for creating the vault auth value file.
**when**: *get_namespace* variable is zero i.e. vault auth doesn't exist. 

#### 5. Create clusterrolebinding for Orderers
This task creates the value file of Cluster Role Binding
##### Input Variables
    component_type: The type of resource
**include_role**: It includes the name of intermediatory role which is required for creating the vault auth value file.
**when**: *get_namespace* variable is zero i.e.cluster role binding doesn't exist. 

#### 6. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"

**include_role**: It includes the name of intermediatory role which is required for creating the vault auth value file.
