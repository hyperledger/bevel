[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Substrate Configurations

In Hyperledger Bevel project, Ansible is used to automate the certificate generation, putting them in vault and generate value files, which are then pushed to the repository for deployment, using GitOps. This is achieved using Ansible playbooks. 
Ansible playbooks contains a series of roles and tasks which run in sequential order to achieve the automation.

```
/substrate
|-- charts
|   |-- dscp-ipfs-node
|   |-- substrate-genesis
|   |-- substrate-key-mgmt
|   |-- substrate-node
|   |-- vault-k8s-mgmt
|-- configuration
|-- |-- molecule/
|   |-- roles/
|   |-- samples/
|   |-- .yamllint
|   |-- cleanup.yaml
|   |-- deploy-network.yaml
|-- images
|-- releases
|   |-- dev/
|-- scripts
```

For Substrate, the ansible roles and playbooks are located at `platforms/substrate/configuration/`
Some of the common roles and playbooks between Hyperledger-Fabric, Hyperledger-Indy, Hyperledger-Besu, R3 Corda and Quorum are located at `platforms/shared/configuration/`

--------

## Roles for setting up a Substrate Network

Roles in ansible are a combination of logically inter-related tasks.

To deploy the substrate network, run the deploy-network.yaml in `platforms/substrate/configuration/`
The roles included in the file are as follows:

## **create/k8_component**

This role creates and checks for the k8s resources in the cluster
* Wait for {{ component_type }} {{ component_name }}
* Wait for {{ component_type }} {{ component_name }}
Follow [Readme](https://github.com/inteli-poc/bevel/tree/main/platforms/substrate/configuration/roles/create/k8_component) for detailed information.

## **create/bootnode**

This role creates the bootnode for the substrate network.
* Fetch bootnode peer id from vault
* Create value file for bootnode
* Push created value files into git repository
* Create the bootnode file

## **create/bootnodefile**

This role creates the bootnode file to be used by the bootnode.
* Set initial node list to empty
* Get the bootnode details from the vault
* Create the bootnode file

## **create/certificates/ambassador**

This role calls for ambassador certificate creation for each node.
* Create Ambassador certificates
* Ensure rootCA dir exists
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
Follow [Readme](https://github.com/inteli-poc/bevel/tree/main/platforms/substrate/configuration/roles/create/certificates/ambassador) for detailed information.

## **create/genesis**

This role creates the genesis file for the blockchain.
* Set initial aura key list to empty
* Set initial grandpa key list to empty
* Set initial member list to empty
* Check if the genesis file exists
* Get the keys for each peer organisation
* Generate a genesis helmrelease file
* Copy the genesis files into the vault of each organisation

## **helm_component**

This role generates the value file for the helm releases.
* Ensures {{ values_dir }}/{{ name }} dir exists
* create value file for {{ component_name }}
* Helm lint

Follow [Readme](https://github.com/inteli-poc/bevel/tree/main/platforms/substrate/configuration/roles/create/helm_component) for detailed information.



## **create/ipfs_bootnode**

This role creates the bootnode for the ipfs.
* Create value file for ipfs bootnode
* Genetates helmrelease file for ipfs bootnode.
* Push created value files into git repository

## **create/ipfsbootnodefile**

This role creates the bootnode file to be used by the ipfs bootnode.
* Set initial node list to empty
* Get the bootnode details from the vault
* Create the ipfs bootnode file

## **create/k8s_secrets**

This role creates the secrets and docker credentials
* Check if root token exists in the namespace
* Put root token of every organization in their namespace
* Check if Docker credentials exist already
* Set docker authentication with username and password
* Encrypt docker authentication data with base64 encoding
* Set docker config file
* Create the docker pull credentials for image registry

## **create/keys**

This role creates the keys for the nodes
* Create keys for each node

## **create/member_node**

This role creates the files needed for member nodes to join the network.
* Create the Bootnode value file for node helm chart
* Generate ipfs node helmrelease file
* Push the generated files to git directory

## **create/namespace_serviceaccount**

This role creates the deployment files for namespaces, vault-auth, vault-reviewer and clusterrolebinding for each node
* Check if namespace exists
* Create namespace for {{ organisation }}
* Create vault auth service account for {{ organisation }}
* Create vault reviewer for {{ organisation }}
* Create clusterrolebinding for {{ organisation }}
* Push the created deployment files to repository

Follow [Readme](https://github.com/inteli-poc/bevel/tree/main/platforms/substrate/configuration/roles/create/namespace_serviceaccount) for detailed information.

## **create/storageclass**

This role creates value files for storage class
* Check if storageclass exists
* Create storageclass
* Push the created deployment files to repository
* Wait for Storageclass creation for {{ component_name }}

Follow [Readme](https://github.com/inteli-poc/bevel/tree/main/platforms/substrate/configuration/roles/create/storageclass) for detailed information.

## **create/validator_node**

This role creates value files for the validator nodes 
* Create the files for validator nodes
* Push the created files to repository

Follow [Readme](https://github.com/inteli-poc/bevel/tree/main/platforms/substrate/configuration/roles/create) for detailed information.

## **setup/get_crypto**

This role saves the crypto from Vault into ansible_provisioner
* Ensures the directory exists
* Saves the cert file
* Saves the crypto key

Follow [Readme](https://github.com/inteli-poc/bevel/tree/main/platforms/substrate/configuration/roles/setup/get_crypto) for detailed information.

## **setup/vault_kubernetes**

This role sets up communication between the vault and kubernetes cluster and install neccessary configurations.

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

Follow [Readme](https://https://github.com/inteli-poc/bevel/tree/main/platforms/substrate/configuration/roles/setup/vault_kubernetes) for detailed information.

## **delete/flux_releases**

This role deletes the helm releases and uninstalls Flux

* Uninstall flux
* Delete the helmrelease for each peer
* Remove node helm releases
* Deletes namespaces

Follow [Readme](https://github.com/inteli-poc/bevel/tree/main/platforms/substrate/configuration/roles/delete/flux_releases) for detailed information.

## **delete/gitops_files**

This role deletes all the gitops release files

* Delete release files
* Delete release files (namespaces)
* Git Push

Follow [Readme](https://github.com/inteli-poc/bevel/tree/main/platforms/substrate/configuration/roles/delete/gitops_files) for detailed information.

## **delete/k8s_secrets**

This role deletes the vault root token.

* Delete vault root token

## **delete/vault_secrets**

This role deletes the Vault configurations

* Delete docker creds
* Delete Ambassador creds
* Delete vault-auth path
* Delete Crypto material 
* Delete Access policies

Follow [Readme](https://github.com/inteli-poc/bevel/tree/main/platforms/substrate/configuration/roles/delete/vault_secrets) for detailed information.

## **deploy-network.yaml**

 This playbook deploys a DLT/Blockchain network on existing Kubernetes clusters. The Kubernetes clusters should already be created and the infomation to connect to the clusters be updated in the network.yaml file that is used as an input to this playbook. It calls the following roles.


* create/bootnode
* create/nootnodefile
* create/certificates/ambassador
* create/genesis
* create/helm_component
* create/ipfs_bootnode
* create/ipfsbootnodefile
* create/k8s_component
* create/k8s_secrets
* create/keys
* create/member_node
* create/namespace_serviceaccount
* create/storageclass
* create/validator_node
* setup/get_crypto
* setup/vault_kubernetes

## **cleanup.yaml**

This playbook deletes the DLT/Blockchain network on existing Kubernetes clusters which has been created using Hyperledger Bevel. It calls the following roles.

* delete/vault_secrets
* delete/k8s_secrets
* Remove build directory
