# Corda Enterprise Configurations

In the Blockchain Automation Framework project, Ansible is used to automate the certificate generation, putting them in vault and generate value files, which are then pushed to the git repository for deployment, using GitOps. This is achieved using Ansible playbooks. 
Ansible playbooks contains a series of roles and tasks which run in sequential order to achieve the automation.
For R3-Corda Enterprise, the ansible roles and playbooks are located at `platforms/r3-corda-ent/configuration/`
Some of the common roles and playbooks between Hyperledger-Fabric, Hyperledger-Indy, Hyperledger-Besu, R3 Corda and Quorum are located at `platforms/shared/configurations/`

```
platforms/r3-corda-ent/configuration
├── deploy-network.yaml
├── deploy-nodes.yaml
├── openssl.conf
├── README.md
├── reset-network.yaml
├── roles
│   ├── create
│   │   ├── certificates
│   │   ├── k8_component
│   │   ├── namespace_serviceaccount
│   │   └── storageclass
│   ├── delete
│   │   ├── flux_releases
│   │   ├── gitops_files
│   │   └── vault_secrets
│   ├── helm_component
│   │   ├── Readme.md
│   │   ├── tasks
│   │   ├── templates
│   │   └── vars
│   └── setup
│       ├── bridge
│       ├── cenm
│       ├── credentials
│       ├── float
│       ├── get_crypto
│       ├── idman
│       ├── nmap
│       ├── node
│       ├── node_registration
│       ├── notary
│       ├── notary-initial-registration
│       ├── pki-generator
│       ├── signer
│       ├── tlscerts
│       └── vault_kubernetes
└── samples
    ├── network-cordaent.yaml
    └── README.md
```

--------
## Playbooks for setting up Corda Enterprise Network

Below are the playbooks availabe for the network operations.
## **deploy_network.yaml**
This is the main ansible playbook which call all the roles in below sequence to setup Corda Enterprise network.

* Remove build directory
* Create Storage Class
* Create namespace and vault auth
* Deploy CENM services
* Check that network service uri are reachable
* Deploy nodes

## **deploy_nodes.yaml**
This ansible playbook should be used when deploying only the nodes. This can be used when the CENM Services are already up and managed by a different network.yaml. This calls the below supporting roles in sequence.

* Remove build directory
* Create Storage Class
* Create namespace and vault auth
* Check that network service uri are reachable
* Deploy nodes

## **reset_network.yaml**
This ansible playbook is used when deleting the network. This calls the below supporting roles in sequence.

* Deletes the Gitops release files
* Deletes the Vault secrets and authpaths
* Uninstalls Flux
* Deletes the helm releases from Kubernetes
* Remove build directory


Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration) for detailed information.

## Roles defined for Corda Enterprise 
Roles in ansible are a combination of logically inter-related tasks.
Below are the roles that are defined for Corda Enterprise.

## **create/certificates/cenm**

* Creates the Ambassador Proxy TLS Certificates for CENM components
* Saves them to Vault
* Creates Kubernetes secrets to be used by Ambassador pods

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/create/certificates/cenm) for detailed information.

## **create/certificates/node**

* Creates the Ambassador Proxy TLS Certificates for Corda Nodes
* Saves them to Vault
* Creates Kubernetes secrets to be used by Ambassador pods

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/create/certificates/node) for detailed information.

## **create/k8_component**

* Creates various Kubernetes components based on the `templates`
* Checks-in to git repo

Add new tpl files in `templates` folder when defining new storageclass.

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/create/k8_component) for detailed information.

## **create/namespace_serviceaccount**

* Creates the namespace, serviceaccounts and clusterrolebinding
* Checks-in to git repo

## **create/storageclass**

* Creates the storageclass template with name "cordaentsc"
* Checks-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/create/storageclass) for detailed information.

## **delete/flux_releases**

* Deletes all helmreleases in the namespace
* Deletes the namespace

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/delete/flux_releases) for detailed information.

## **delete/gitops_files**

* Deletes all gitops files from release folder
* Checks-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/delete/gitops_files) for detailed information.

## **delete/vault_secrets**

* Deletes all contents of Vault
* Deletes the related Kubernetes secrets 
* Deletes Vault access policies

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/delete/vault_secrets) for detailed information.

## **helm_component**

* Creates various Helmrelease components based on the `templates`
* Performs helm lint (when true)

Most default values are in the tpl files in `templates` folder. If any need to be changed, these tpl files need to be edited.

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/helm_component) for detailed information.

## **setup/bridge**
* Create helmrelease files for Bridge component
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/setup/bridge) for detailed information.

## **setup/cenm**

* Checks all the prerequisite namespaces and serviceaccounts are created
* Creates vault access for cenm organization
* Calls setup/pki-generator role to generate network crypto.
* Calls setup/signer role to deploy signer service.
* Calls setup/idman role to deploy idman service.
* Calls setup/nmap role to deploy nmap service.
* Calls setup/notary role to deploy notary service.

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/setup/cenm) for detailed information.

## **setup/credentials**

* Writes keystore,truststore,ssl passwords for CENM services
* Writes node keystore, node truststore, network root-truststore passwords for CENM services

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/setup/credentials) for detailed information.

## **setup/float**
* Create helmrelease files for Float component
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/setup/float) for detailed information.

## **setup/get_crypto**

* Saves the Ambassador cert and key file to local file from Vault when playbook is re-run.

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/setup/get_crypto) for detailed information.

## **setup/idman**
* Wait for Signer pod to be "Running"
* Creates Ambassador certs by calling create/certificates/cenm role
* Create idman value files
* Check-in to git repo

## **setup/nmap**
* Wait for PKI Job to "Complete" if certificates are not on Vault
* Creates Ambassador certs by calling create/certificates/cenm role
* Gets network-root-truststore.jks from Vault to save to local
* Create Notary-registration Job if not done already
* Wait forNotary-registration Job to "Complete" if not done already
* Create nmap value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/setup/nmap) for detailed information.

## **setup/node**
* Wait for all the prerequisites (namespace, Vault auth, rbac, imagepullsecret)
* Create Vault access using setup/vault_kubernetes role
* Create ambassador certificates by calling create/certificates/node
* Save idman/networkmap tls certs to Vault for this org
* Create node initial registration by calling setup/node_registration role
* Create node value files
* Create bridge, if enabled, by calling setup/bridge
* Create float, if enabled, by calling setup/float
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/setup/node) for detailed information.

## **setup/node_registration**
* Create node db helm value files
* Create node initial registration helm value files, if not registered already
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/setup/node_registration) for detailed information.

## **setup/notary**
* Wait for networkmap pod to be "Running"
* Create ambassador certificates by calling create/certificates/cenm
* Create notary value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/setup/notary) for detailed information.

## **setup/notary-initial-registration**
* Wait for idman pod to be "Running"
* Create notary db helm value files
* Create notary initial registration helm value files, if not registered already
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/setup/notary-initial-registration) for detailed information.

## **setup/pki-generator**
* Create pki-generator value files, if values are not in Vault
* Check-in to git repo

## **setup/signer**
* Wait for pki-generator Job to be "Completed"
* Create signer value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/setup/signer) for detailed information.

## **setup/tlscerts**
* Copies the idman/nmap certificates and truststore to each node's Vault

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/setup/tlscerts) for detailed information.

## **setup/vault_kubernetes**
* Creates vault auth path if it does not exist
* Gets Kubernetes ca certs
* Enables Kubernetes and Vault authentication
* Creates Vault policies if they do not exist
* Creates docker credentials if they do not exist

If the Vault policies need to be changed, then this role will need to be edited.

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda-ent/configuration/roles/setup/vault_kubernetes) for detailed information.
