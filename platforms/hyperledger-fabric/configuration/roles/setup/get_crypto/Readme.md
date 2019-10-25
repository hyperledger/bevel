## setup/get_crypto
This role saves the crypto from Vault into ansible_provisioner
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Ensure admincerts directory exists
This task ensures that admincerts directory is present in build
##### Input Variables
    path: The path where to check is specified here.
    recurse: Yes/No to recursively check inside the path specified. 
    state: directory (If not present , It makes a directory at the path)

#### 2. Save admincerts
This task Save the admincerts file.
##### Input Variables
    *msp_path: Path of MSP is specified here
    *component_name: The name of resource
**local_Action**: Command specified here copies the admin certs to destination directory.

#### 3. Ensure cacerts directory exists
This task ensures that cacerts directory exists
##### Input Variables
    path: The path where to check is specified here.
    recurse: Yes/No to recursively check inside the path specified. 
    state: directory (If not present , It makes a directory at the path)

#### 4. Save cacerts
This task saves the cacerts
##### Input Variables
    *msp_path: Path of MSP is specified here
    *component_name: The name of resource
**local_Action**: Command specified here copies the admin certs to destination directory.


#### 5. Ensure tlscacerts directory exists
This task ensure that tlscacerts directory exists
##### Input Variables
    path: The path where to check is specified here.
    recurse: Yes/No to recursively check inside the path specified. 
    state: directory (If not present , It makes a directory at the path)

#### 6. Save tlscacerts
This task saves the tlscacerts
##### Input Variables
    *msp_path: Path of MSP is specified here
    *component_name: The name of resource
**local_Action**: Command specified here copies the admin certs to destination directory.
