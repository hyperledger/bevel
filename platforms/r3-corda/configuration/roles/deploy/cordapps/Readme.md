## ROLE: deploy_cordapps
This role deploys the corDapps to nodes and notary Kubernetes pods.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Ensure build directory exists
This task ensures directory existance, if not creates a new one.
##### Input Variables
  
    path: The path where to check is specified here
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory.

#### 2. Copy jar files from source to scripts directory
This task copy jar files from source to destination directory
**copy** : copies the local cordapps jar files from the source folder into destination
**with_fileglob** : lookup matching pattern in local system

#### 3. Uploads the cordapp jar files into each node and notary from network.yaml
This task run the shell script to upload cordapp jar files for each nodes and notary from network.yaml
##### Input Variables
    component_name: name of the resource/organization
**shell** : contains script to upload cordapps jar into notary and node pods