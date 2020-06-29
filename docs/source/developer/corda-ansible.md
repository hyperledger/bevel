# Corda Configurations

In the Blockchain Automation Framework project, ansible is used to automate the certificate generation, putting them in vault and generate value files, which are then pushed to the repository for deployment, using GitOps. This is achieved using Ansible playbooks. 
Ansible playbooks contains a series of roles and tasks which run in sequential order to achieve the automation.
```
/r3-corda
|-- charts
|   |-- doorman
|   |-- doorman-tls
|   |-- h2
|   |-- h2-addUser
|   |-- h2-password-change
|   |-- mongodb
|   |-- mongodb-tls
|   |-- nms
|   |-- nms-tls
|   |-- node
|   |-- node-initial-registration
|   |-- notary
|   |-- notary-initial-registration
|   |-- storage
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

For R3-Corda, the ansible roles and playbooks are located at `/platforms/r3-corda/configuration/`
Some of the common roles and playbooks between Hyperledger-Fabric, Hyperledger-Indy, Hyperledger-Besu, R3 Corda and Quorum are located at `/platforms/shared/configurations/`

--------
## Roles for setting up Corda Network

Roles in ansible are a combination of logically inter-related tasks.

Below is the single playbook that you need to execute to setup complete corda network.
## **deploy_network**
This is the main ansible playbook which call all the roles in below sequence to setup corda network.

* Create Storage Class
* Create namespace and vault auth
* Deploy Doorman service node
* Deploy Networkmap service node
* Check that orderer uri are reachable
* Deploy notary
* Deploy nodes
* Remove build directory


Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration) for detailed information.

Below are the roles that deploy_network playbook calls to complete the setup process.
## **setup/nms**

* Perform all the prerequisites (namespace, Vault auth, rbac, imagepullsecret)
* Create nms helm value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/roles/setup/nms) for detailed information.
## **setup/doorman**

* Perform all the prerequisites (namespace, Vault auth, rbac, imagepullsecret)
* Create doorman and mongodb helm value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/roles/setup/doorman) for detailed information.
## **create/certificates**
* Generate root certificates for doorman and nms

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/roles/create/certificates) for detailed information.
## **setup/notary**
* Perform all the prerequisites (namespace, Vault auth, rbac, imagepullsecret)
* Get crypto from doorman/nms, store in Vault
* Create notary db helm value files
* Create notary initial registration helm value files
* Create notary value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/roles/setup/notary) for detailed information.
## **setup/node**
* Perform all the prerequisites (namespace, Vault auth, rbac, imagepullsecret)
* Get crypto from doorman/nms, store in Vault
* Create node db helm value files
* Create node initial registration helm value files
* Create node value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/roles/setup/node) for detailed information.

## **deploy/cordapps**

* Deploy cordapps into each node and notary

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/roles/deploy/cordapps) for detailed information.

## **setup/springboot_services**
* Create springboot webserver helm value files for each node
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/roles/setup/springboot_services) for detailed information.

## **setup/get_crypto**
* Ensure admincerts directory exists
* Save the cert file
* Save the key file
* Save the root keychain
* Save root cert
* Save root key

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/roles/setup/get_crypto) for detailed information.
