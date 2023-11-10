## ROLE: create/chaincode/peer_certs
This role generates and updates TLS certificates for chaincode interactons by peer

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Copy generate-crypto-peer-chaincode.sh to destination directory
This task copies the generate-crypto-peer-chaincode.sh from scripts folder to  specified destination folder

#### 2. Changing the permission of msp files
This task chnages the permission required for creating msp files

#### 3. Copy generate_crypto.sh file using the CA Tools
This task pushes the above file to CA CLI Pod.

#### 4. Execute generate-crypto-peer-chaincode.sh file using the CA Tools 
This tasks executes generate-crypto-peer-chaincode.sh inside the CA CLI Pod and copies the generated crypto to a destination folder

#### 5. Copy certificates to vault
This task copies the generated certificates to vault.
