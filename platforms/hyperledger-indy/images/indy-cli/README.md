[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

### Hyperledger Indy CLI Dockerfile

Add the file to the respective directory. Go to that directory.
To run the ledger transactions on the Docker Container
###### Steps to run
1. Build the file
                    
        docker build -t <imagename>:<imagetag> .
2. To check the successful build. (It should list the images running)

        docker images
3. To run the cli container

        docker run -a stdin -a stdout -i -t <imageid>
4. To Run the Script. Go to
	    
        cd /home
		chmod +x ledger-script.sh
		./ledger-script.sh vault_addr vault_token admin_path admin_name identity_path identity_name identity_role pool_genesis_path

NOTE: 
* Docker Pool Container should be already be running.
* This script can also run in any ubuntu system, provided that indy-cli is setup and docker pool is running.
* For complete setup RUN: indy-env-txn, it setup docker indy pool, setups Vault and performs transactions.
* JUST REPLACE THE SCRIPT VARIABLES WITH ACTUAL VALUES.
    `vault_addr` = Vault Address 
	`vault_token` = Vault Token 
	`admin_path` = Path of Admin DID in Vault  
	`admin_name` = Admin Name 
	`identity_path` = Path of Identity to be added in Vault
	`identity_name` = Identity Name 
	`identity_role` = Identity Role
	`pool_genesis_path` = Path of Pool Genesis Config File.
