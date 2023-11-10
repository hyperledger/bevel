## ROLE: create/chaincode/server_certs
This role generates and updates TLS certs for external chaincode server

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Copy generate-crypto-chaincode-server.sh to destination directory
This task copies the generate-crypto-chaincode-server.sh from scripts folder to  specified destination folder

#### 2. Changing the permission of msp files
This task chnages the permission required for creating msp files

#### 3. Copy generate_crypto.sh file using the CA Tools
This task pushes the above file to CA CLI Pod.

#### 4. Execute generate-crypto-chaincode-server.sh file using the CA Tools 
This tasks executes generate-crypto-chaincode-server.sh inside the CA CLI Pod and copies the generated crypto to a destination folder

#### 5. Copy certificates to vault
This task copies the generated certificates to vault.
