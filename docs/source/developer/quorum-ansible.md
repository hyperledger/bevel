# Quorum Configurations

In the Blockchain Automation Framework project, ansible is used to automate the certificate generation, putting them in vault and generate value files, which are then pushed to the repository for deployment, using GitOps. This is achieved using Ansible playbooks. 
Ansible playbooks contains a series of roles and tasks which run in sequential order to achieve the automation.

```
/quorum
|-- charts
|   |-- node_constellation
|   |-- node_tessera
|-- images
|-- configuration
|   |-- roles/
|   |-- samples/
|   |-- deploy-network.yaml
|-- releases
|   |-- dev/
|-- scripts
```

For Quorum, the ansible roles and playbooks are located at `/platforms/quorum/configuration/`
Some of the common roles and playbooks between Hyperledger-Fabric, Hyperledger-Indy, Hyperledger-Besu, R3 Corda and Quorum are located at `/platforms/shared/configurations/`

--------

## Roles for setting up a Quorum Network

Roles in ansible are a combination of logically inter-related tasks.

To deploy the quorum network, run the deploy-network.yaml in `blockchain-automation-framework\platforms\quorum\configuration\`
The roles included in the file are as follows:

## **check/k8_component

This role checks for the k8s resources in the cluster
* Wait for {{ component_type }} {{ component_name }}
* Wait for {{ component_type }} {{ component_name }}
Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/create/check/k8_component) for detailed information.

## **check/node_component

This role checks for the k8s resources in the cluster
* Wait for {{ component_type }} {{ component_name }}
* Wait for {{ component_type }} {{ component_name }}
Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/create/check/node_component) for detailed information.

## **create/certificates/ambassador**

This role calls for ambassador certificate creation for each node.
* Create Ambassador certificates
* Ensure rootca dir exists
* Ensure ambassador tls dir exists
* Check if certs already created
* Get root certs
* check root certs
* Generate CAroot certificate
* Check if ambassador tls already created
* Get ambassador tls certs
* Generate openssl conf file
* Generate ambassador tls certs
* Putting certs to vault
* Check Ambassador cred exists
* Create the Ambassador credentials
Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/create/certificates/ambassador) for detailed information.

## **create/crypto/constellation**

This role creates crypto for constellation.
* Create Crypto material for each node for constellation
* Check tm key is present the vault
* Create build directory
* Generate Crypto for constellation
* Copy the crypto into vault

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/create/crypto/constellation) for detailed information.

## **create/crypto/ibft**

This role creates crypto for ibft.
* Create crypto material for each peer with IBFT consensus
* Check if nodekey already present in the vault
* Create build directory if it does not exist
* Generate enode url for each node and create a geth account and keystore
* Copy the crypto material to Vault

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/create/crypto/ibft) for detailed information.

## **create/crypto/raft**

This role creates crypto for raft.
* Create crypto material for each peer with RAFT consensus
* Check if nodekey already present in the vault
* Create build directory if it does not exist
* Generate crypto for raft consensus
* Copy the crypto material to Vault

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/create/crypto/raft) for detailed information.

## **create/crypto/tessera**

This role creates crypto for tessera.
* Create tessera tm crypto material for each peer 
* Check if tm key is already present in the vault
* Create build directory if it does not exist
* Check if tessera jar file exists
* Download tessera jar
* Generate node tm keys
* Copy the crypto material to Vault

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/create/crypto/tessera) for detailed information.

## **create/genesis_nodekey**

This role creates genesis nodekey.
* Check if nodekey is present in vault
* Call nested check for each node
* Check if nodekey already present in the vault
* vault_check variable
* Fetching data of validator nodes in the network from network.yaml
* Get validator node data
* Create build directory if it does not exist
* Generate istanbul files
* Rename the directories created above with the elements of validator_node_list
 * Delete the numbered directories

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/create/genesis_nodekey) for detailed information.

## **create/k8_component**

This role creates deployment files for nodes, namespace storageclass, service accounts and clusterrolebinding. Deployment file for a node is created in a directory with name=nodeName, nodeName is stored in component_name
* "Ensures {{ release_dir }}/{{ component_name }} dir exists"
* create {{ component_type }} file for {{ component_name }}
* Helm lint

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/create/k8_component) for detailed information.

## **create/namespace_serviceaccount**

This role creates the deployment files for namespaces, vault-auth, vault-reviewer and clusterrolebinding for each node
* Check if namespace exists
* Create namespace for {{ organisation }}
* Create vault auth service account for {{ organisation }}
* Create vault reviewer for {{ organisation }}
* Create clusterrolebinding for {{ organisation }}
* Push the created deployment files to repository

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/create/namespace_serviceaccount) for detailed information.


## **create/storageclass**

This role creates value files for storage class
* Check if storageclass exists
* Create storageclass
* Push the created deployment files to repository
* Wait for Storageclass creation for {{ component_name }}

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/create/storageclass) for detailed information.

## **create/tessera**

* Set enode_data_list to []
* Get enode data for each node of all organization
* Get enode data
* Check if enode is present in the build directory or not
* Create build directory if it does not exist
* Get the nodekey from vault and generate the enode
* Get enode_data
* Get validator node data
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/create/tessera) for detailed information.

## **helm_component**

This role generates the value file for the helm releases.
* Ensures {{ values_dir }}/{{ name }} dir exists
* create value file for {{ component_name }}
* Helm lint

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/helm_component) for detailed information.


## **setup/bootnode**

This role is used to setup bootnode.
* Check bootnode
* Check quorum repo dir exists
* Clone the git repo
* Make bootnode
* Create bin directory
* Copy bootnode binary to destination directory

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/setup/bootnode) for detailed information.

## **setup/constellation-node**

This role is used to setup constellation-node.
* Register temporary directory
* check constellation
* Finding the release for os
* Release version
* Download the constellation-node binary
* Unarchive the file.
* Create the bin directory
* This task puts the constellation-node binary into the bin directory

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/setup/constellation-node) for detailed information.

## **setup/get_crypto**

This role saves the crypto from Vault into ansible_provisioner.
* Ensure directory exists
* Save cert
* Save key
* Save root keychain
* Extracting root certificate from .jks

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/setup/get_crypto) for detailed information.

## **setup/geth**

This role setups geth.
* Check geth
* Check quorum repo dir exists
* Clone the git repo
* Make geth
* Create bin directory
* Copy geth binary to destination directory

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/setup/geth) for detailed information.


## **setup/golang**

This role setups geth.
* Register temporary directory
* Check go
* Download golang tar 
* Extract the Go tarball
* Create bin directory
* Copy go binary to destination directory
* Test go installation

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/setup/golang) for detailed information.

## **setup/istanbul**

This role setups instanbul.
* Register temporary directory
* Check istanbul
* Clone the istanbul-tools git repo
* Make istanbul
* Create bin directory
* Copy istanbul binary to destination directory

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/setup/istanbul) for detailed information.

## **setup/vault_kubernetes**

This role setups communication between the vault and kubernetes cluster and install neccessary configurations.

* Check namespace is created
* Ensures build dir exists
* Check if Kubernetes-auth already created for Organization
* Vault Auth enable for organisation
* Get Kubernetes cert files for organizations
* Write reviewer token
* Check if secret-path already created for Organization
* Create Vault secrets path
* Check if policy exists
* Create policy for Access Control
* Create Vault auth role
* Create the docker pull credentials

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/setup/vault_kubernetes) for detailed information.

## **delete/flux_releases**

This role deletes the helm releases and uninstalls Flux

* Uninstall flux
* Delete the helmrelease for each peer
* Remove node helm releases
* Deletes namespaces

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/delete/flux_releases) for detailed information.

## **delete/gitops_files**

This role deletes all the gitops release files

* Delete release files
* Delete release files (namespaces)
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/delete/gitops_files) for detailed information.

## **delete/vault_secrets**

This role deletes the Vault configurations

* Delete docker creds
* Delete Ambassador creds
* Delete vault-auth path
* Delete Crypto material 
* Delete Access policies 

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/quorum/configuration/roles/delete/vault_secrets) for detailed information.

## **deploy-network.yaml**

 This playbook deploys a DLT/Blockchain network on existing Kubernetes clusters. The Kubernetes clusters should already be created and the infomation to connect to the clusters be updated in the network.yaml file that is used as an input to this playbook. It calls the following roles.


* create/namespace_serviceaccount
* create/storageclass
* setup/vault_kubernetes
* create/certificates/ambassador
* create/crypto/raft
* create/genesis_raft
* setup/istanbul
* create/genesis_nodekey
* create/crypto/ibft
* create/crypto/tessera
* create/crypto/constellation
* create/tessera
* create/constellation


## **reset-network.yaml**

This playbook deletes the DLT/Blockchain network on existing Kubernetes clusters which has been created using the Blockchain Automation Framework. It calls the following roles. THIS PLAYBOOK DELETES EVERYTHING, EVEN NAMESPACES and FLUX.

* delete/vault_secrets
* delete/flux_releases
* delete/gitops_files
* Remove build directory

