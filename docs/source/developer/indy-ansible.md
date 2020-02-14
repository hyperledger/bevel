# Indy Configurations

In the Blockchain Automation Framework project, ansible is used to automate the certificate generation, putting them in vault and generate value files, which are then pushed to the repository for deployment, using GitOps. This is achieved using Ansible playbooks. 
Ansible playbooks contains a series of roles and tasks which run in sequential order to achieve the automation.

```
/hyperledger-indy
|-- charts
|   |-- indy-auth-job
|   |-- indy-cli
|   |-- indy-domain-genesis
|   |-- indy-domain-genesis
|   |-- indy-key-mgmt
|   |-- indy-ledger-txn
|   |-- indy-node
|   |-- indy-pool-genesis
|-- images
|-- configuration
|   |-- roles/
|   |-- samples/
|   |-- playbook(s)
|   |-- cleanup.yaml
|-- releases
|   |-- dev/
|-- scripts
|   |-- indy_nym_txn
|   |-- setup indy cluster
```

For Hyperledger-Indy, the ansible roles and playbooks are located at `/platforms/hyperledger-indy/configuration/`
Some of the common roles and playbooks between Hyperledger-Indy, Hyperledger-Fabric and R3-Corda are located at
`/platforms/shared/configuration/`

--------

## Roles for setting up Indy Network

Roles in ansible are a combination of logically inter-related tasks.

To deploy the indy network, run the deploy-network.yaml in `blockchain-automation-framework\platforms\hyperledger-indy\configuration\`
The roles included in the file are as follows.

## **check/auth_job**

* This role checks all auth jobs completing.
* Check if Indy  auth job pod for trustee is completed
* Check if Indy  auth job pod for stewards is completed
* Check if Indy  auth job pod for endorser is completed
* Check if Indy  auth job pod for baf-ac is completed

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/check/auth_job/README.md) for detailed information.

## **check/crypto**

* This role is checking if all crypto jobs are completed and all crypto data are in Vault.
* Check if Indy Key management pod for trustee is completed
* Check if Indy Key management pod for stewards is completed
* Check if Indy Key management pod for endorser is completed
* Check trustee in vault
* Check stewards in vault
* Check endorser in vault

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/check/crypto/README.md) for detailed information.

## **check/k8_component**

* This role is used for waiting to kubernetes component.
* Wait for {{ component_type }} {{ component_name }}
* Wait for {{ component_type }} {{ component_name }}
* Wait for {{ component_type }} {{ component_name }}
* Get a ServiceAccount token for {{ component_name }}
* Store Token

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/check/k8_component/README.md) for detailed information.

## **check/validation**

* This role checks for validation of network.yaml
* Check Validation
* Print error and end playbook if genesis steward count limit fails
* Print error and end playbook if total trustee count limit fails

## **clean/flux**

* Delete Helm release
* Wait for deleting of Helm release flux-{{ network.env.type }}

## **clean/gitops**

* Delete release files
* Git push

## **clean/k8s_resourses**

* Remove all Helm releases of organization {{ organization }}
* Get all existing Cluster Role Bindings of organization {{ organization }}
* Remove an existing Cluster Role Binding of {{ organization }}
* Remove an existing Namespace {{ organization_ns }}
* Remove an existing Storage Class of {{ organization }}

## **clean/vault**

* Remove Indy Crypto of {{ organization }}
* Remove Policies of trustees
* Remove Policies of stewards
* Remove Policies of endorsers

## **create/helm_component/auth_job**
#### This role create the job value file for creating Vault auth methods

* Ensures {{ release_dir }}/{{ component_type }}/{{ component_name }} dir exists
* Get the kubernetes server url
* Trustee vault policy and role generating
* Stewards vault policy and role generating
* Endorser vault policy and role generating
* baf-ac vault policy and role generating

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/create/helm_component/auth_job/README.md) for detailed information.

## **create/helm_component/crypto**
#### This role create the job value file for creating Hyperledger Indy Crypto

* Ensures {{ release_dir }}/{{ component_type }}/{{ component_name }} dir exists
* Trustee crypto generating
* Stewards crypto generating
* Endorser crypto generating

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/create/helm_component/crypto/README.md) for detailed information.

## **create/helm_component/domain_genesis**
#### This role create the config map value file for storing domain genesis for Indy cluster.

* Ensures {{ release_dir }}/{{ component_type }}/{{ component_name }} dir exists
* Generate domain genesis for organization
* create value file for {{ component_name }} {{ component_type }}

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/create/helm_component/domain_genesis/README.md) for detailed information.

## **create/helm_component/ledger_txn**
#### This role create the job value file for Indy NYM ledger transactions

* Ensures {{ release_dir }}/{{ component_type }}/{{ component_name }} dir exists
* Create HelmRelease file
* Get identity data from vault
* create value file for {{ new_component_name }} {{ component_type }}

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/create/helm_component/ledger_txn/Readme.md) for detailed information.

## **create/helm_component/node**
#### This role creates value file for Helm Release of stewards.

* Ensures {{ release_dir }}/{{ component_name }} dir exists
* create value file for {{ component_name }} {{ component_type }}

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/create/helm_component/node/README.md) for detailed information.

## **create/helm_component/pool_genesis**

* Ensures {{ release_dir }}/{{ component_type }}/{{ component_name }} dir exists
* Generate pool genesis for organization
* create value file for {{ component_name }} {{ component_type }}

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/create/helm_component/pool_genesis/README.md) for detailed information.

## **create/imagepullsecret**
#### This role creates secret in Kubernetes for pull docker images from repository.

* Check for ImagePullSecret for {{ organization }}
* Create the docker pull registry secret for {{ component_ns }}

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/create/imagepullsecret/README.md) for detailed information.

## **create/k8_component**
#### This role create value file for kubernetes component by inserted type.

* Ensures {{ component_type_name }} dir exists
* create {{ component_type }} file for {{ component_type_name }}

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/create/k8_component/README.md) for detailed information.

## **create/namespace**

* Check namespace is created
* Create namespaces
* Git Push

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/create/namespace/README.md) for detailed information.

## **create/serviceaccount/by_identities**

* Check if service account for {{ component_name }} exists
* Create service account for {{ component_name }}
* Check cluster role binding for {{ component_name }}
* Get component_name to var
* Get organization and admin string to var
* Create cluster role binding for {{ component_name }}
* Create admin cluster role binding for {{ component_name }}

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/create/serviceaccount/by_identities/README.md) for detailed information.


## **create/serviceaccount/main**

* Create service account for trustees [{{ organization }}]
* Create service account for stewards [{{ organization }}]
* Create service account for endorsers [{{ organization }}]
* Create service account for organization [{{ organization }}]
* Create service account for read only public crypto [{{ organization }}]
* Push the created deployment files to repository
* Waiting for trustees accounts and cluster binding roles
* Waiting for stewards accounts and cluster binding roles
* Waiting for endorsers accounts and cluster binding roles
* Waiting for organization accounts and cluster binding roles
* Waiting for organization read only account and cluster binding role

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/create/serviceaccount/main/README.md) for detailed information.

## **create/serviceaccount/waiting**

* Wait for creation for service account
* Wait for creation for cluster role binding

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/create/serviceaccount/waiting/README.md) for detailed information.

## **create/storageclass**

* Check if storageclass exists
* Create storageclass
* Push the created deployment files to repository
* Wait for Storageclass creation for {{ component_name }}

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/create/storageclass/README.md) for detailed information.

## **setup/auth_job**

* Wait for namespace creation for stewards
* Create auth_job of stewards, trustee and endorser
* Push the created deployment files to repository
* Check if auth job finished correctly

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/setup/auth_job/README.md) for detailed information.

## **setup/crypto**

* Wait for namespace creation for stewards
* Create image pull secret for stewards
* Create crypto of stewards, trustee and endorser
* Push the created deployment files to repository
* Check Vault for Indy crypto

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/setup/crypto/README.md) for detailed information.

## **setup/domain_genesis**

* Create domain genesis
* Push the created deployment files to repository
* Wait until domain genesis configmap are created


Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/setup/domain_genesis/README.md) for detailed information.


## **setup/endorsers**

* Wait for namespace creation
* Create image pull secret for identities
* Create Deployment files for Identities
* Select Admin Identity for Organisation {{ component_name }}
* Calling Helm Release Development Role...
* Push the created deployment files to repository

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/setup/endorsers/README.md) for detailed information.

## **setup/node**

* Wait for namespace creation for stewards
* Create image pull secret for stewards
* Create steward deployment file
* Push the created deployment files to repository
* Wait until steward pods are running

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/setup/node/README.md) for detailed information.

## **setup/pool_genesis**

* Create pool genesis
* Push the created deployment files to repository
* Wait until pool genesis configmap are created

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/setup/pool_genesis/README.md) for detailed information.

## **setup/vault_kubernetes**

* Check namespace is created
* Ensures build dir exists
* Check if Kubernetes-auth already created for Organization
* Enable and configure Kubernetes-auth for Organization
* Get Kubernetes cert files for organizations
* Write reviewer token for Organizations
* Check if policy exists
* Create policy for Access Control
* Write Policy to Vault
* Create Vault auth role

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-indy/configuration/roles/setup/vault_kubernetes/README.md) for detailed information.