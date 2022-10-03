[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "upgrading-fabric"></a>
# Upgrading Hyperledger Fabric version from 1.4.x to 2.2.x

- [Pre-requisites](#pre_req)
- [Steps to upgrade](#upgrade_steps)

<a name = "pre_req"></a>
## Pre-requisites
A DLT system which is using Hyperledger Fabric version 1.4.x and is setup using Bevel automation framework

<a name = "upgrade_steps"></a>
## Steps to upgrade
This involve upgrading the nodes and channels to the version 2.2.x of Fabric is, at a high level, a four step process.

1. Upgrade the orderer binaries in a rolling fashion to the Fabric version mentioned in network yaml file.
2. Upgrade the peer binaries in a rolling fashion to the Fabric version mentioned in network yaml file.
3. Update the orderer system channel and any application channels for the following:
	1.	Orderer address endpoint
	2.	Endorsement policies for system channel consortium 
	3.	Endorsement and lifecycle policies for application channels
	4.	ACL for application channels

As mentioned in prerequisite, existing system(will be called as source system) is setup using Hyperledger Bevel and currently using verion 1.4.x. This guide provide the steps to upgrade it to Hyperledger Fabric version 2.2.x

Note: The operator doing this upgrade should have access to all kubernetes cluster(s) and can verify the logs of any pods as prompted by the workflow. 

The following are the steps to be  performed:
## 1. Update network.yaml for upgrade
Update the network network.yaml [here](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml)
 
	a. Set the required version tag under `network.version` for upgrading the base images of CA, orderer and peer.
	b. Add the upgrade flag to true
	For example:
		network:
	  		version: 2.2.2
			upgrade: true			

Note: The network.yaml should reflect the entire network which requires to be upgraded

## 2. Executing Ansible playbook
Execute the [run.sh] (https://github.com/hyperledger/bevel/tree/main/platforms/)
The playbook [site.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/site.yaml) ([ReadMe](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/)) can be run after the configuration file (for example: [network.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml) for Fabric) has been updated.
```
ansible-playbook platforms/shared/configuration/site.yaml --extra-vars "@path-to-network.yaml"
```
It covers all the [steps](#upgrade_steps). As stated earlier this execution is in rolling fashion i.e. in a specific cluster first orderer(s) are upgraded one by one, after that peers are upgraded in rolling fashion. The script will pause after node is upgraded and provide information to operator to check the upgraded node health using 'kubectl logs' command and then decide whether to continue or abort the script. For this reason the operator should have access to each kubernetes cluster(s).
The script is idempotent and can be run mutiple times without impacting existing configurations

## 3. Upgrade Capabilities level
To upgrade the capabilities in system channel and across application channel, the steps in below image needs to be performed. 

Note: Before execution of this step, it should be ensured that all nodes(orderer(s) and peer(s)) in entire network is upgraded to target version successfuly.

![](./../_static/upgrade_channel.png)

As discussed earlier, the operator should have access to all the kubernetes clusters. It is an assumption that operator has one network.yaml file which consists of all participating organizations such as peers and orderers.

The following are the steps:

1.	Upgrade the System channel's orderer and channel level capabilities
2.	Upgrade all application channel's orderer, channel and application level capabilities
3.	Add Orderer endpoints in orderer and all application channels replacing the global Orderer Addresses  	 
	section of channel configuration
4.	Upgrade the system channel for enabling endorsement policy in consortium organizations
5.	Upgrade all the existing application channel orgs for enabling endorsement policy
6. 	Upgrade all the existing application channels application policy for endorsement and lifecyle
7.  Optional: Upgrade all the existing application channels ACL policy
	
	When there is a single network file the following script automates the upgrade of capabilities as required by version 2.2.x
	ansible-playbook platforms/shared/configuration/upgrade-capabilites.yaml --extra-vars "@path-to-network.yaml"

## 4. Compare core.yaml & orderer.yaml
When core.yaml and orderer.yaml was modified in source system, a diff is done with new core.yaml and orderer.yaml in the target system. Based on this analysis the target system files can be modified

## 5. Upgrade existing Chaincode lifecycle
Any existing chaincode should be verified as it should continue running as usual. It will be good practice to update them new Hyperledger Fabric 2.2.x lifecycle.

For each chaincode to be upgraded update the network.yaml for the specific chaincode and execute the following script to install, approve and commit as per 2.2.x lifecyle
ansible-playbook platforms/shared/configuration/chaincode-ops.yaml --extra-vars "@path-to-network.yaml"

TODO: the steps for upgrade to be mentioned here.