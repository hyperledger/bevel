## ROLE: deploy/cordapps
This role deploys the corDapps to nodes and notary Kubernetes pods.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Ensure {{ source_dir }} dir exists
This task ensures directory existance, if not creates a new one.
##### Input Variables
  
    path: The path where to check is specified here
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory.

#### 2. Copy cordapp jar files
This task copy jar files from source to destination directory
**copy** : copies the local cordapps jar files from the source folder into destination
**with_fileglob** : lookup matching pattern in local system

#### 3. Run uploadCordapps.sh for notary
This task run the shell script to upload cordapp jar files for notary from network.yaml
##### Input Variables
    component_name: name of the resource/organization
**shell** : contains script to upload cordapps jar into notary.

#### 4. Run uploadCordapps.sh for each node
This task run the shell script to upload cordapp jar files for each node
##### Input Variables
    component_name: name of the resource/organization
**shell** : contains script to upload cordapps jar into notary.

#### 5. remove cordapp jar files from script
This task removes jar files from scripts directory after uploading is complete
##### Input Variables
    path: path where jar file is present
