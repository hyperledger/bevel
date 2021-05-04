## ROLE: ca-tools
This role creates helm release value file for the deployment of CA Tools CLI.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check CA-server is available
This tasks checks if CA server is available or not and waits for the CA server to be available.
##### Input Variables


    kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *namespace: The namespace of the component.
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables
    get_ca: This variable stores the output of ca server check query.
    
  **until**: This condition checks until *get_ca.resources* exists
  **retries**: No of retries
  **delay**: Specifies the delay between every retry

#### 2. Create CA-tools Values file
This task creates the CA-tools value files.
##### Input Variables
    *name: The name of resource
    type: "ca-tools"
    *git_url: "The URL of git repo"
    *git_branch: "Git repo branch name"
    *charts_dir: "The path of chart files"
    
**include_role** : It includes the name of intermediatory role which is required for creating the CA Tools value file.

#### 3. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
