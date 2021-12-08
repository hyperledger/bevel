[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: users
This role generates and updates users and thier enrollment certificates for peers

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Copy generate-user-crypto.sh to destination directory
This task copies the generate-user-crypto.sh from scripts folder to  specified destination folder

#### 2. Changing the permission of msp files
This task changes the permission required for creating msp files

#### 3. Copy generate_crypto.sh file using the CA Tools
This task pushes the above file to CA CLI Pod.

#### 4. Execute generate-user-crypto.sh file using the CA Tools 
This tasks executes generate-user-crypto.sh inside the CA CLI Pod and copies the generated crypto to a destination folder

#### 5. Copy user certificates to vault
This task copies the generated certificates to vault.
