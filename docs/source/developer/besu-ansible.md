[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Hyperledger Besu Configurations

In Hyperledger Bevel project, ansible is used to automate the certificate generation, put them in the vault and generate value files, which are then pushed to the repository for deployment, using GitOps. This is achieved using Ansible playbooks.
Ansible playbooks contains a series of roles and tasks which run in sequential order to achieve the automation.

```
/hyperledger-besu
|-- charts
|   |-- besu-member-node
|-- images
|-- configurations
|   |-- roles/
|   |-- samples/
|   |-- deploy-network.yaml
|-- releases
|   |-- dev/
|-- scripts
```

For Hyperledger Besu, the ansible roles and playbooks are located at `/platforms/hyperledger-besu/configuration/`. Some of the common roles and playbooks between Hyperledger-Fabric, Hyperledger-Indy, Hyperledger-Besu, R3 Corda and Quorum are located at `/platforms/shared/configurations/`

-------------

## Roles for setting up a Hyperledger Besu Network

Roles in ansible are a combination of logically inter-related tasks.

To deploy the Hyperledger-Besu network, run the deploy-network.yaml in `bevel\platforms\hyperledger-besu\configuration\`
The roles included in the files are as follows:

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
Follow [Readme](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-besu/configuration/roles/create/certificates/ambassador) for detailed information.

## **create/crypto/ibft**

This role creates crypto for ibft.
* Create crypto material for each peer with IBFT consensus
* Check if nodekey already present in the vault
* Create build directory if it does not exist
* Generate enode url for each node and create a geth account and keystore
* Copy the crypto material to Vault

Follow [Readme](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-besu/configuration/roles/create/crypto/ibft) for detailed information.

## **create/crypto/clique**

This role creates crypto for clique.
* Create crypto material for each peer with CLIQUE consensus
* Check if nodekey already present in the vault
* Create build directory if it does not exist
* Generate enode url for each node and create a geth account and keystore
* Copy the crypto material to Vault

Follow [Readme](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-besu/configuration/roles/create/crypto/clique) for detailed information.

## **create/k8_component**

This role creates deployment files for nodes, namespace storageclass, service accounts and clusterrolebinding. Deployment file for a node is created in a directory with name=nodeName, nodeName is stored in component_name
* "Ensures {{ release_dir }}/{{ component_name }} dir exists"
* create {{ component_type }} file for {{ component_name }}
* Helm lint

Follow [Readme](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-besu/configuration/roles/create/k8_component) for detailed information.

## **create/namespace_serviceaccount**

This role creates the deployment files for namespaces, vault-auth, vault-reviewer and clusterrolebinding for each node
* Check if namespace exists
* Create namespace for {{ organisation }}
* Create vault auth service account for {{ organisation }}
* Create vault reviewer for {{ organisation }}
* Create clusterrolebinding for {{ organisation }}
* Push the created deployment files to repository

Follow [Readme](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-besu/configuration/roles/create/namespace_serviceaccount) for detailed information.

## **create/storageclass**

This role creates value files for storage class
* Check if storageclass exists
* Create storageclass
* Push the created deployment files to repository
* Wait for Storageclass creation for {{ component_name }}

Follow [Readme](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-besu/configuration/roles/create/storageclass) for detailed information.

## **setup/get_crypto**

This role saves the crypto from Vault into ansible_provisioner.
* Ensure directory exists
* Save cert
* Save key
* Save root keychain
* Extracting root certificate from .jks

Follow [Readme](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-besu/configuration/roles/setup/get_crypto) for detailed information.


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

Follow [Readme](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-besu/configuration/roles/setup/vault_kubernetes) for detailed information.