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

Below is the single playbook that you need to execute to setup complete corda network.
## **create/ca_server**

* Check if ca certs already created
* Ensures crypto dir exists
* Generate the CA certificate
* Copy the crypto material to Vault
* Check if ca admin credentials are already created
* Write the ca server admin credentials to Vault
* Check Ambassador cred exists
* Create the Ambassador credentials
* Create CA server values for Orderer
* Create CA server values for Organisations
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/ca_server/Readme.md) for detailed information.

## **create/ca_tools**

* Check CA-server is available
* Create CA-tools Values file
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/ca_tools/Readme.md) for detailed information.

## **create/chaincode/install**

* Check/Wait for joinchannel job
* Check for install-chaincode job
* Write the git credentials to Vault
* Create value file for chaincode installation - nested
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/chaincode/install/Readme.md) for detailed information.

## **create/chaincode/instantiate**

* Check/Wait for install-chaincode job
* Check for instantiate-chaincode job
* Create value file for chaincode instantiation
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/chaincode/instantiate/Readme.md) for detailed information.

## **create/chaincode/upgrade**

* Check/Wait for install-chaincode job
* Check for instantiate-chaincode job
* Create value file for chaincode upgradation
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/chaincode/upgrade/Readme.md) for detailed information.

## **create/channel_artifacts**

* Check configtxgen
* Register temporary directory
* Geting the configtxgen binary tar
* Unzipping the downloaded file
* Moving the configtxgen from the extracted folder and place in it path
* Remove old genesis block
* Creating channel-artifacts folder
* Creating genesis block
* Remove old channel block
* Creating channels 

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/channel_artifacts/Readme.md) for detailed information.

## **create/channels**

* Check creator peer pod is up
* Create channel value file
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/channels/Readme.md) for detailed information.

## **create/channels_join**

* Create join channel value file for peer
* Create join channel value file for orderer
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/channels_join/Readme.md) for detailed information.

## **create/configtx**

* Remove old configtx file
* Create configtx file
* Adding init patch to configtx.yaml
* Adding organization patch to configtx.yaml
* Adding orderer patch to configtx.yaml
* Adding profile patch to configtx.yaml

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/configtx/Readme.md) for detailed information.

## **create/crypto**

* Create directory path on CA Tools for Orderers
* Create directory path on CA Tools for Orgs
* Install dos2unix to use unarchieve module of ansible
* Convert the file to unix format for orderer
* Convert the file to unix format for organization
* Copy the generate_crypto.sh file into the orderer CA Tools
* Copy the generate_crypto.sh file into the organization CA Tools
* Copy the Orderer CA certificates to the Orderer CA Tools
* Copy the Orderer CA certificates to the org CA Tools
* Generate crypto material for organization peers
* Generate crypto material for orderer
* Backing up crypto config folder
* Copy the crypto config folder from the orderer ca tools
* Copy the crypto config folder from the org ca tools
* Create the MSP config.yaml file for orgs
* Copy the crypto material for orderer
* Copy the crypto material for organizations
* Copy organization level certificates for orderers
* Copy organization level certificates for orgs

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/crypto/Readme.md) for detailed information.

## **create/crypto_script**

* Create generate_crypto script file for orderers
* Create generate_crypto script file for organizations

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/crypto_script/Readme.md) for detailed information.

## **create/namespace_vaultauth**

* Check namespace is created
* Create namespaces
* Create Vault reviewer
* Create Vault Auth
* Create clusterrolebinding for Orderers
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/namespace_vaultauth/Readme.md) for detailed information.

## **create/orderers**

* create kafka clusters
* create orderers
* Git push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/orderers/Readme.md) for detailed information.

## **create/peers**

* Write the couchdb credentials to Vault
* Create Value files for Organization Peers
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/peers/Readme.md) for detailed information.

## **create/storageclass**

* Check if storage class created
* Ensures "*component_type*" dir exists
* Create Storage class for Orderer
* Create Storage class for Organizations
* Git push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/storageclass/Readme.md) for detailed information.

## **delete/flux_releases**

* Deletes the CA server Helmrelease
* Deletes the CA tools helmrelease
* Remove Common Helm releases
* Remove Helm releases for orderer
* Remove Helm releases for peers
* Remove Helm releases for channels
* Uninstall Flux
* Uninstall Namespaces

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/delete/flux_releases/Readme.md) for detailed information.

## **delete/gitops_files**

* Delete release files
* Git push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/delete/gitops_files/Readme.md) for detailed information.

## **delete/vault_secrets**

* Delete docker creds
* Delete vault-auth path
* Delete Crypto for orderers
* Delete Crypto for peers

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/delete/vault_secrets/Readme.md) for detailed information.

## **helm_component**

* Ensures value directory exist
* Create value file
* Helm lint

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/helm_component/Readme.md) for detailed information.

## **k8_component**

* Ensures value directory exist
* Create value file

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/k8_component/Readme.md) for detailed information.

## **setup/get_crypto**

* Ensure admincerts directory exists
* Save admincerts
* Ensure cacerts directory exists
* Save cacerts
* Ensure tlscacerts directory exists
* Save tlscacerts

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/setup/get_crypto/Readme.md) for detailed information.

## **setup/vault_kuberntes**

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

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/setup/vault_kubernetes/Readme.md) for detailed information.