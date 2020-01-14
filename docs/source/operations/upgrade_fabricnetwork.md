<a name = "upgrading-fabric"></a>
# Upgrading Hyperledger Fabric version

- [Pre-requisites](#pre_req)
- [Modifying image versions](#modify_image_version)

<a name = "pre_req"></a>
## Pre-requisites
Hyperledger Fabric image versions, which are compatible with the target fabric version need to be known. Here's the list of the images for which the versions should be known:  
kafka image-- hyperledger/fabric-kafka:`targer_version`  
zookeeper image-- hyperledger/fabric-zookeeper:`target_version`  
couchDB image-- hyperledger/fabric-couchdb:`target_version`  

---
**NOTE:** The upgrade based solely on the base image version change will work only if the fabric upgrade requires the change of image versions only

---

<a name = "modify_image_version"></a>
## Modifying image versions
The network.yaml [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml) should be updated with the required version tag under `network.version` for upgrading the base images of CA, orderer and peer.

2 files need to be edited in order to support version change for kafka, zookeeper and couchDB

Vars file mentioned [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/orderers/vars/main.yaml) for kafka and zookeeper and [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/roles/create/peers/vars/main.yaml) for couchdb are required to be edited by adding a `key:value` pair for the fabric version to the corresponding base image version.

