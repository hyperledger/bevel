# Fabric Configurations

In the Blockchain Automation Framework project, ansible is used to automate the certificate generation, putting them in vault and generate value files, which are then pushed to the repository for deployment, using GitOps. This is achieved using Ansible playbooks. 
Ansible playbooks contains a series of roles and tasks which run in sequential order to achieve the automation.

```
/hyperledger-fabric
|-- charts
|   |-- ca
|   |-- catools
|   |-- zkkafka
|   |-- orderernode
|   |-- peernode
|   |-- create_channel
|   |-- join_channel
|   |-- install_chaincode
|   |-- instantiate_chaincode
|   |-- upgrade_chaincode
|-- images
|-- configuration
|   |-- roles/
|   |-- samples/
|   |-- playbook(s)
|   |-- openssl.conf
|-- releases
|   |-- dev/
|-- scripts
```

For Hyperledger-Fabric, the ansible roles and playbooks are located at `/platforms/hyperledger-fabric/configuration/`
Some of the common roles and playbooks between Hyperledger-Fabric and R3-Corda are located at
`/platforms/shared/configuration/`

--------

## Roles for setting up Fabric Network

Roles in ansible are a combination of logically inter-related tasks.

Below is the single playbook that you need to execute to setup complete fabric network.

## **create/anchorpeer**
* Call nested_anchorpeer for each organization
* Check join channel job is done
* Creating value file of anchor peer for {{ channel_name }}
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/blob/master/platforms/hyperledger-fabric/configuration/roles/create/anchorpeer/) for detailed information.

## **create/ca_server**

* Check if ca certs already created
* Ensures crypto dir exists
* Get ca certs and key
* Generate the CA certificate
* Copy the crypto material to Vault
* Check if ca admin credentials are already created
* Write the ca server admin credentials to Vault
* Check Ambassador cred exists
* Create the Ambassador credentials
* Create CA server values for Orderer
* Create CA server values for Organisations
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/blob/master/platforms/hyperledger-fabric/configuration/roles/create/ca-server/) for detailed information.

## **create/ca_tools**

* Check CA-server is available
* Create CA-tools Values file
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/ca-tools) for detailed information.

## **create/chaincode/install**

* Create value file for chaincode installation
* Check/Wait for anchorpeer update job
* Check for install-chaincode job
* Write the git credentials to Vault
* Create value file for chaincode installation ( nested )
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/chaincode/install) for detailed information.

## **create/chaincode/instantiate**

* Create value file for chaincode instantiation
* Check/Wait for install-chaincode job
* Check for instantiate-chaincode job
* Create value file for chaincode instantiaiton (nested)
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/chaincode/instantiate) for detailed information.

## **create/chaincode/invoke**

* Create value file for chaincode invocation
* Check/Wait for install-chaincode job
* Create value file for chaincode invocation (nested)
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/chaincode/invoke) for detailed information.

## **create/chaincode/upgrade**

* Check/Wait for install-chaincode job
* Create value file for chaincode upgrade
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/chaincode/upgrade/tasks) for detailed information.

## **create/channel_artifacts**

* Check configtxgen
* Geting the configtxgen binary tar
* Unzipping the downloaded file
* Moving the configtxgen from the extracted folder and place in it path
* Remove old genesis block
* Creating channel-artifacts folder
* Creating genesis block
* Remove old channel block
* Creating channels 
* Creating Anchor artifacts
* Creating JSON configration for new organization

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/channel_artifacts) for detailed information.

## **create/channels**

* Call valuefile when participant is creator
* Check orderer pod is up
* Check peer pod is up
* Create Create_Channel value file
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/channels) for detailed information.

## **create/channels_join**

* Call nested_channel_join for each peer
* Check create channel job is done
* "join channel {{ channel_name }}"
* Git Push
* Call check for each peer
* Check join channel job is done

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/channels_join) for detailed information.

## **create/configtx**

* Remove old configtx file
* Create configtx file
* Adding init patch to configtx.yaml
* Adding organization patch to configtx.yaml
* Adding orderer patch to configtx.yaml
* Adding profile patch to configtx.yaml

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/configtx) for detailed information.

## **create/crypto/orderer**
* Call orderercheck.yaml for orderer
*  Check if CA-tools is running
* Ensure ca directory exists
* Check if ca certs already created
* Check if ca key already created
* Call orderer.yaml for each orderer
* Check if orderer msp already created
* Get MSP info
* Check if orderer tls already created
* Ensure tls directory exists
* Get Orderer tls crt
* Create directory path on CA Tools
* Copy generate-usercrypto.sh to destination directory
* Changing the permission of msp files
* Copy the generate_crypto.sh file into the CA Tools 
* Generate crypto material for organization orderers
* Copy the crypto config folder from the ca tools
* Copy the crypto material for orderer
* Check Ambassador cred exists
* Check if orderer ambassador secrets already created
* Get Orderer ambassador info
* Generate the orderer certificate
* Create the Ambassador credentials
* Copy the crypto material to Vault

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/crypto/orderer) for detailed information.

## **create/crypto/peer**

* Check if CA-tools is running
* Ensure ca directory exists
* Check if ca certs already created
* Check if ca key already created
* Call peercheck.yaml for each peer
* Check if peer msp already created
* Get MSP info
* Call common.yaml for each peer
* Create directory path on CA Tools
* Copy generate-usercrypto.sh to destination directory
* Changing the permission of msp files
* Copy the generate_crypto.sh file into the CA Tools 
* Generate crypto material for organization peers
* Copy the crypto config folder from the ca tools
* Check that orderer-certificate file exists
* Ensure orderer tls cert directory exists
* Copy tls ca.crt from auto-generated path to given path
* Check if Orderer certs exist in Vault
* Save Orderer certs if not in Vault
* Copy organization level certificates for orderers
* Check if admin msp already created
* Copy organization level certificates for orgs
* Check if user msp already created
* Copy user certificates for orgs

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/crypto/peer) for detailed information.

## **create/crypto_script**

* Create generate_crypto script file for orderers
* Create generate_crypto script file for organizations

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/crypto_script) for detailed information.

## **create/namespace_vaultauth**

* Check namespace is created
* Create namespaces
* Create vault reviewer service account for Organizations
* Create vault auth service account for Organizations
* Create clusterrolebinding for Orderers
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/namespace_vaultauth) for detailed information.

## **create/new_organisation/create_block**

* Call nested_create_json for each peer
* Ensure channel-artifacts dir exists
* Remove old anchor file
* Creating new anchor file
* adding new org peers anchor peer information
* Create create-block-{{ channel_name }}.sh script file for new organisations

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/new_organization/create_block) for detailed information.

## **create/orderers**

* create kafka clusters
* create orderers
* Git push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/orderers) for detailed information.

## **create/peers**

* Write the couchdb credentials to Vault
* Create Value files for Organization Peers
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/peers) for detailed information.

## **create/storageclass**

* Check if storage class created
* Ensures "*component_type*" dir exists
* Create Storage class for Orderer
* Create Storage class for Organizations
* Git push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/storageclass) for detailed information.

## **delete/flux_releases**

* Deletes all the helmreleases CRD
* Remove all Helm releases
* Deletes namespaces

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/delete/flux_releases) for detailed information.

## **delete/gitops_files**

* Delete release files
* Git push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/delete/gitops_files) for detailed information.

## **delete/vault_secrets**

* Delete docker creds
* Delete Ambassador creds
* Delete vault-auth path
* Delete Crypto for orderers
* Delete Crypto for peers
* Delete policy

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/delete/vault_secrets) for detailed information.

## **helm_component**

* Ensures value directory exist
* Create value file
* Helm lint

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/helm_component) for detailed information.

## **k8_component**

* Ensures value directory exist
* Create value file

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/k8_component) for detailed information.


## **setup/config_block/fetch**

* Call nested_create_cli for the peer
* create valuefile for cli {{ peer.name }}-{{ participant.name }}-{{ channel_name }}
* Call nested_fetch_role for the peer
* start cli
* fetch and copy the configuration block from the blockchain
* delete cli

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/setup/config_block/fetch) for detailed information.

## **setup/config_block/sign_and_update**

* Call valuefile when participant is new
* Check peer pod is up
* Call nested_sign_and_update for each peer
* create cli value files for {{peer.name}}-{{ org.name }} for signing the modified configuration block
* start cli {{peer.name}}-{{ org.name }}
* Check if fabric cli is present
* signing from the admin of {{ org.name }}
* delete cli {{ peer.name }}-{{ participant.name }}-cli
* Call nested_update_channel for the peer
* start cli for {{ peer.name }}-{{ org.name }} for updating the channel
* Check if fabric cli is present
* updating the channel with the new configuration block
* delete cli {{ peer.name }}-{{ participant.name }}-cli

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/setup/config_block/sign_and_update) for detailed information.

## **setup/get_ambassador_crypto**

* Ensure ambassador secrets directory exists
* Save keys 
* Save certs
* Ensure ambassador secrets directory exists
* Save keys 
* Save certs
* signing from the admin of {{ org.name }}
* delete cli {{ peer.name }}-{{ participant.name }}-cli
* Call nested_update_channel for the peer
* start cli for {{ peer.name }}-{{ org.name }} for updating the channel
* Check if fabric cli is present
* updating the channel with the new configuration block
* delete cli {{ peer.name }}-{{ participant.name }}-cli


## **setup/get_crypto**

* Ensure admincerts directory exists
* Save admincerts
* Ensure cacerts directory exists
* Save cacerts
* Ensure tlscacerts directory exists
* Save tlscacerts

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/setup/get_crypto) for detailed information.

## **setup/vault_kubernetes**

* Check if namespace is created
* Ensures build dir exists
* Check if Kubernetes-auth already created for Organization
* Enable and configure Kubernetes-auth for Organization
* Get Kubernetes cert files for organizations
* Write reviewer token for Organisations
* Check if policy exists
* Create policy for Orderer Access Control
* Create policy for Organisations Access Control
* Write policy for vault
* Create Vault auth role
* Check docker cred exists
* Create the docker pull credentials

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/setup/vault_kubernetes) for detailed information.