# Corda Enterprise Configurations
TODO
In the Blockchain Automation Framework project, Ansible is used to automate the certificate generation, putting them in vault and generate value files, which are then pushed to the git repository for deployment, using GitOps. This is achieved using Ansible playbooks. 
Ansible playbooks contains a series of roles and tasks which run in sequential order to achieve the automation.
```
corda-ent
├── charts
│   ├── bridge
│   ├── float
│   ├── generate-pki
│   ├── h2
│   ├── idman
│   ├── nmap
│   ├── node
│   ├── node-initial-registration
│   ├── notary
│   ├── notary-initial-registration
│   └── signer
├── configuration
│   ├── deploy-network.yaml
│   ├── deploy-nodes.yaml
│   ├── openssl.conf
│   ├── README.md
│   ├── reset-network.yaml
│   ├── roles
│   └── samples
├── images
│   ├── networkmap.dockerfile
│   └── README.md
├── README.md
└── releases
    └── README.md
```

For R3-Corda Enterprise, the ansible roles and playbooks are located at `/platforms/corda-ent/configuration/`
Some of the common roles and playbooks between Hyperledger-Fabric, Hyperledger-Indy, Hyperledger-Besu, R3 Corda and Quorum are located at `/platforms/shared/configurations/`

--------
## Roles for setting up Corda Enterprise Network

Roles in ansible are a combination of logically inter-related tasks.

Below is the single playbook that you need to execute to setup complete Corda Enterprise network.
## **deploy_network**
This is the main ansible playbook which call all the roles in below sequence to setup Corda Enterprise network.

* Remove build directory
* Create Storage Class
* Create namespace and vault auth
* Deploy CENM services
* Check that orderer uri are reachable
* Deploy nodes


Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/corda-ent/configuration) for detailed information.

Below are the roles that deploy_network playbook calls to complete the setup process.
## **create/storageclass**

* Creates the storageclass template with name "cordaentsc"
* Checks-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/corda-ent/configuration/roles/create/storageclass) for detailed information.

## **create/namespace_serviceaccount**

* Creates the namespace, serviceaccounts and clusterrolebinding
* Checks-in to git repo

## **setup/cenm**

* Checks all the prerequisite namespaces and serviceaccounts are created
* Create nms helm value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/corda-ent/configuration/roles/setup/nms) for detailed information.
## **setup/doorman**

* Perform all the prerequisites (namespace, Vault auth, rbac, imagepullsecret)
* Create doorman and mongodb helm value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/corda-ent/configuration/roles/setup/doorman) for detailed information.
## **create/certificates**
* Generate root certificates for doorman and nms

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/corda-ent/configuration/roles/create/certificates) for detailed information.
## **setup/notary**
* Perform all the prerequisites (namespace, Vault auth, rbac, imagepullsecret)
* Get crypto from doorman/nms, store in Vault
* Create notary db helm value files
* Create notary initial registration helm value files
* Create notary value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/corda-ent/configuration/roles/setup/notary) for detailed information.
## **setup/node**
* Perform all the prerequisites (namespace, Vault auth, rbac, imagepullsecret)
* Get crypto from doorman/nms, store in Vault
* Create node db helm value files
* Create node initial registration helm value files
* Create node value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/corda-ent/configuration/roles/setup/node) for detailed information.

## **deploy/cordapps**

* Deploy cordapps into each node and notary

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/corda-ent/configuration/roles/deploy/cordapps) for detailed information.

## **setup/springboot_services**
* Create springboot webserver helm value files for each node
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/corda-ent/configuration/roles/setup/springboot_services) for detailed information.

## **setup/get_crypto**
* Ensure admincerts directory exists
* Save the cert file
* Save the key file
* Save the root keychain
* Save root cert
* Save root key

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/corda-ent/configuration/roles/setup/get_crypto) for detailed information.
