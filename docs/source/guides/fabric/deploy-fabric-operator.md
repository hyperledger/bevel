[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy-fabric-network-using-operator"></a>
# Deploy Fabric Network using Operator

  - [Introduction](#introduction)
  - [Modifying Configuration File](#modifying-configuration-file)
  - [Run playbook](#run-playbook)

## Introduction
The [bevel-operator-fabric](https://github.com/hyperledger/bevel-operator-fabric) provides a different approach to deploying the Fabric Network. It uses 
the kubernetes operator to deploy CAs, Orderers and Peers. 
This release supports bevel-operator-fabric version 1.9.0 and all the Fabric platforms supported by it. Also, chaincode and user/certificate management is not yet supported, there will be separate issues to handle this. Current implementation supports till Channel creation and joining.

Due to open issues with bevel-operator-fabric, it is not recommended for Production workloads yet.

---
**NOTE**: The bevel-operator-fabric deployment has been tested only for Fabric 2.5.3

---

## Modifying Configuration File

A Sample configuration file for deploying using bevel-operator-fabric is available [here](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/configuration/samples/network-operator-fabric.yaml). Following are the main changes in this file from previous versions:

1. `network.env.type` must be `operator`. This is how Ansible will understand that bevel-operator-fabric will be used.
1.  `network.env.proxy` must be `istio` as no other proxy is supported by bevel-operator-fabric.
1. Only `443` is supported as external port because that is what bevel-operator-fabric supports.
1. `vault` and `gitops` sections are removed as they are not applicable.

For generic instructions on the Fabric configuration file, refer [this guide](../networkyaml-fabric.md).

<a name = "run-playbook"></a>
## Run playbook

After all the configurations are updated in the `network.yaml`, execute the following to create the DLT network
```
# Run the provisioning scripts
ansible-playbook platforms/shared/configuration/site.yaml -e "@./build/network.yaml" 

```
The `site.yaml` playbook, in turn calls various playbooks depending on the configuration file and sets up your DLT/Blockchain network.

The [deploy-fabric-console.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/deploy-operator-network.yaml) playbook can be used as well if the pre-requisites like Istio and krew is already installed. This can be done using the following command

```
ansible-playbook platforms/hyperledger-fabric/configuration/deploy-operator-network.yaml -e "@/path/to/network.yaml"
```

Refer to [bevel-operator-fabric docs](https://hyperledger.github.io/bevel-operator-fabric/) for details the operator and latest releases.
