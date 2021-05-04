## ROLE: storageclass
This role creates helm value files for storage class.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if storage class created
This tasks check if the storage class is already created or not.
##### Input Variables

    kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    get_sc: This variable stores the output of storage class check query.

#### 2. Ensures "*component_type*" dir exists
This task checks if that particular *component_type* directory exists. If not it creates one.
##### Input Variables
    path: The path where to check is specified here.
    recurse: Yes/No to recursively check inside the path specified.
    state: Type of state i.e. directory

**when**: It runs if the storage class is not present.

#### 3. Create Storage class for Orderer
This task creates the storage class for orderers
##### Input Variables
    *type: The type of resource
    *values_file: Path and name of the file to be generated.
**template** : It contains the source and destinations details required for value file generation of access policy.
**src**: Contains the details of template file.
**dest**: Destination path and name of file to be generated.
**when**: Condition is specified here, runs only if the storage class is absent and *component_type* is orderer.


#### 4. Create Storage class for Organisations
This task creates the storage class for orderers
##### Input Variables
    *type: The type of resource
    *values_file: Path and name of the file to be generated.
**template** : It contains the source and destinations details required for value file generation of access policy.
**src**: Contains the details of template file.
**dest**: Destination path and name of file to be generated.
**when**: Condition is specified here, runs only if the storage class is absent and *component_type* is peer.

#### 5. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
