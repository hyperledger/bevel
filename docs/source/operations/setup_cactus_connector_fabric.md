[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy-fabric-cactus-connector"></a>
# Deploy Fabric Cactus connector

- [Prerequisites](#prerequisites)
- [Modifying configuration file](#create_config_file)
- [Running playbook to deploy Hyperledger Fabric network](#run_network)


<a name = "prerequisites"></a>
## Prerequisites
To deploy cactus connector a fully configured Fabric network must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels). The corresponding crypto materials should also be present in their respective Hashicorp Vault. 

---
**NOTE**: Deployment of cactus connector has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

---

<a name = "create_config_file"></a>
## Modifying Configuration File

Refer [this guide](./fabric_networkyaml.md) for details on editing the configuration file.

While modifying the configuration file(`network.yaml`)to deploy the cactus connector, all peers in member organizations should have `cactus_connector` tag as `enabled` e.g.

    network:
      organizations:
        - organization:
          type: peer
          ..
          ..
          services:
            peers:
            - peer:
              ..
              ..
              cactus_connector: enabled  # set to enabled to create a cactus connector for Fabric
              
        - organization:
          type: peer
          ..
          ..
          services:
            peers:
            - peer:
              ..
              ..
              cactus_connector: enabled  # set to enabled to create a cactus connector for Fabric

For reference, see `network-fabricv2.yaml` file [here](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/samples).


<a name = "run_network"></a>
## Run playbook

The [setup-cactus-connector.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/setup-cactus-connector.yaml) playbook is used to deploy a cactus connector for Fabric.
This can be done using the following command

```
ansible-playbook platforms/hyperledger-fabric/configuration/setup-cactus-connector.yaml --extra-vars "@path-to-network.yaml"
```
