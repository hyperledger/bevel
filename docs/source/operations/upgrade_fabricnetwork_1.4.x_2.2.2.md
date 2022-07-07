[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "upgrading-fabric"></a>
# Upgrading Hyperledger Fabric version from 1.4.x to 2.2.2

- [Pre-requisites](#pre_req)
- [Steps to upgrade](#upgrade_steps)

<a name = "pre_req"></a>
## Pre-requisites
A DLT system which is using Hyperledger Fabric version 1.4.8 and is setup using Bevel automation framework

<a name = "upgrade_steps"></a>
## Steps to upgrade
This involve upgrading the nodes and channels to the version of Fabric is, at a high level, a four step process.

1. Backup the ledger and MSPs.
2. Upgrade the orderer binaries in a rolling fashion to the latest Fabric version.
3. Upgrade the peer binaries in a rolling fashion to the latest Fabric version.
4. Update the orderer system channel and any application channels to the latest capability levels, where available.

As mentioned in prerequisite, existing system(will be called as source system) is setup using Hyperledger Bevel and currently using verion 1.4.x. The following guide provide the steps to upgrade it to Hyperledger Fabric version 2.2.2 and the upgraded system(will be called as target system)

The steps to be followed may require manual intervention and facilitation when source system consists of different organizations having separate kubernetes cluster. This also means every organization control the network.yaml file which Hyperledger Bevel uses as payload. This guide shall mention those steps where off chain faciliation is involved

The following are the steps to be  performed:
## 1. Setup network.yaml for upgrade
Update the network network.yaml [here](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml) 
	a. Set the required version tag under `network.version` for upgrading the base images of CA, orderer and peer.
	b. Add the upgrade flag to true
	For example:
		network:
	  		version: 2.2.2
			upgrade: true

## 2. Executing Ansible playbook
The playbook [site.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/site.yaml) ([ReadMe](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/)) can be run after the configuration file (for example: [network.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml) for Fabric) has been updated.
```
ansible-playbook platforms/shared/configuration/site.yaml --extra-vars "@path-to-network.yaml"
