## ROLE: setup/get_crypto
This role saves the crypto from Vault into ansible_provisioner.

### Tasks
(Variables with * are fetched from the playbook which is calling this role.)
#### 1. Ensure directory exists
This task checks whether *cert_path* directory present or not. If not present, creates one.
##### Input Variables
  
    *path: The path where to check is specified here
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory.

#### 2. Save cert
This task takes the tlscacerts from vault and put in ansible container.
##### Input Variables
    * cert_path: path where the certificate getting stored
**when**: *type* == 'ambassador'

#### 3. Save key
This task takes the tlskey from vault and put in ansible container.
##### Input Variables
    * cert_path: path where the certificate getting stored
**when**: *type* == 'ambassador'

#### 4. Save root keychain
This task takes the rootcakey from vault and put in ansible container.
##### Input Variables
    * cert_path: path where the certificate getting stored
**when**: *type* == 'rootca'

#### 5. Save root cert
This task takes the cacerts from vault and put in ansible container.
##### Input Variables
    * cert_path: path where the certificate getting stored
**when**: *type* == 'rootca'

#### 6. Save root key
This task takes the keystore from vault and put in ansible container.
##### Input Variables
    * cert_path: path where the certificate getting stored
**when**: *type* == 'rootca'