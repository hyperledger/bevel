# Corda Configurations

In the Blockchain Automation Framework project, ansible is used to automate the certificate generation, putting them in vault and generate value files, which are then pushed to the repository for deployment, using GitOps. This is achieved using Ansible playbooks. 
Ansible playbooks contains a series of roles and tasks which run in sequential order to achieve the automation.
```
/r3-corda
|-- charts
|   |-- doorman
|   |-- h2
|   |-- h2-addUser
|   |-- h2-password-change
|   |-- mongodb
|   |-- nms
|   |-- node
|   |-- node-initial-registration
|   |-- notary
|   |-- notary-initial-registration
|   |-- springbootwebserver
|   |-- storage
|   |-- webserver
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
Some of the common roles and playbooks between Hyperledger-Fabric and R3-Corda are located at
`/platforms/shared/configuration/`

--------
## Roles for setting up Corda Network

Roles in ansible are a combination of logically inter-related tasks.

Below is the single playbook that you need to execute to setup complete corda network.
## **deploy_network**
This is the main ansible playbook which call all the roles in below sequence to setup corda network.

* Create Storage Class
* Create root certificates
* Store certificates and credentials to vault for doorman and nms
* Deploy Networkmap service node
* Deploy Doorman service node
* Deploy notary
* Deploy nodes


Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/README.md) for detailed information.

Below are the roles that deploy_network playbook calls to complete the setup process.
## **setup/nms**

* Perform all the prerequisites (namespace, Vault auth, rbac, imagepullsecret)
* Create nms helm value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/setup/nms/README.md) for detailed information.
## **setup/doorman**

* Perform all the prerequisites (namespace, Vault auth, rbac, imagepullsecret)
* Create doorman and mongodb helm value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/setup/doorman/README.md) for detailed information.
## **create/certificates**
* Generate root certificates for doorman and nms

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/create/certificates/README.md) for detailed information.
## **setup_notary**
* Perform all the prerequisites (namespace, Vault auth, rbac, imagepullsecret)
* Get crypto from doorman/nms, store in Vault
* Create notary db helm value files
* Create notary initial registration helm value files
* Create notary value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/README.md) for detailed information.
## **setup_node**
* Perform all the prerequisites (namespace, Vault auth, rbac, imagepullsecret)
* Get crypto from doorman/nms, store in Vault
* Create node db helm value files
* Create node initial registration helm value files
* Create node value files
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/README.md) for detailed information.

## **deploy_cordapps**

* Deploy cordapps into each node and notary

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/README.md) for detailed information.

## **setup_springboot_services**
* Create springboot webserver helm value files for each node
* Check-in to git repo

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/README.md) for detailed information.
