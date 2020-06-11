<a name = "upgrading-fabric"></a>
# Upgrading Hyperledger Fabric version

- [Pre-requisites](#pre_req)
- [Modifying image versions](#modify_image_version)

<a name = "pre_req"></a>
## Pre-requisites
Hyperledger Fabric image versions, which are compatible with the target fabric version need to be known. 

For example, for Fabric v1.4.4, these are the image tags of the supporting docker images 

| Fabric component | Fabric image tag |
|------------------|------------------|
| kafka            | 0.4.18           |
| zookeeper        | 0.4.18           |
| couchDB          | 0.4.18           |
| orderer          | 1.4.4            |
| peer             | 1.4.4            |
| ca               | 1.4.4            |

And, for Fabric v2.0.0, these are the image tags of the supporting docker images 

| Fabric component | Fabric image tag |
|------------------|------------------|
| kafka            | 0.4.18           |
| zookeeper        | 0.4.18           |
| couchDB          | 0.4.18           |
| orderer          | 2.0.0            |
| peer             | 2.0.0            |
| ca               | 1.4.5            |

---
**NOTE:** This change only upgrades the docker images, any other configuration changes is not covered by this guide. Please refer to Fabric documentation for any specific configuration changes.

---

<a name = "modify_image_version"></a>
## Modifying image versions
The network.yaml [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml) should be updated with the required version tag under `network.version` for upgrading the base images of CA, orderer and peer.
For example:


	network:
	  version: 1.4.4

2 files need to be edited in order to support version change for kafka, zookeeper and couchDB 

| File                                                                                                                                                                            | Fabric entity | Key                     |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|-------------------------|
| [orderer vars](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/orderers/vars/main.yaml) | kafka         | kafka_image_version     |
| [orderer vars](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/orderers/vars/main.yaml) | zookeeper     | zookeeper_image_version |
| [peer vars](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/peers/vars/main.yaml)       | couchDB       | couchdb_image_version   |

## Executing Ansible playbook
The playbook [site.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/site.yaml) ([ReadMe](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/)) can be run after the configuration file (for example: [network.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml) for Fabric) has been updated.
```
ansible-playbook platforms/shared/configuration/site.yaml --extra-vars "@path-to-network.yaml"
``
