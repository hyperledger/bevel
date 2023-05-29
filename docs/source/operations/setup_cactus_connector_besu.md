[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy-besu-cactus-connector"></a>
# Deploy Besu Cactus connector

- [Prerequisites](#prerequisites)
- [Modifying configuration file](#create_config_file)
- [Running playbook to deploy Hyperledger Besu network](#run_network)


<a name = "prerequisites"></a>
## Prerequisites
To deploy cactus connector a fully configured Besu network must be present already, i.e. a Besu network which has validator and member. The corresponding crypto materials should also be present in their respective Hashicorp Vault.

---
**NOTE**: Deployment of cactus connector has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

---

<a name = "create_config_file"></a>
## Modifying Configuration File

Refer [this guide](./besu_networkyaml.md) for details on editing the configuration file.

When editing the configuration file (`network.yaml`) to deploy the cactus connector, both validators and peers from validator and member organizations should have the `cactus_connector` field. To enable the cactus connector for a peer or validator, set the value as `enabled`. If a particular peer or validator does not want to support the cactus connector feature, set the `cactus_connector` field as `disabled`. A sample for the same is shared below:

    network:
    organizations:
        - organization: supplychain
          type: validator
          ..
          ..
          services:
            validators:
            - validator:
              name: validator1
              ..
              ..
              cactus_connector: enabled  # set to enabled to create a cactus connector for Besu otherwise set it to disabled
            
        - organization: carrier
          type: member
          ..
          ..
          services:
            peers:
            - peer:
              name: carrier
              ..
              ..
              cactus_connector: disabled  # set to enabled to create a cactus connector for Besu otherwise set it to disabled

For reference, see `network-besu-v22.yaml` file [here](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/configuration/samples/network-besu-v22.yaml).


<a name = "run_network"></a>
## Run playbook

The [setup-cactus-connector.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/configuration/setup-cactus-connector.yaml) playbook is used to deploy a cactus connector for Besu. This can be done using the following command:

```
ansible-playbook platforms/hyperledger-besu/configuration/setup-cactus-connector.yaml --extra-vars "@path-to-network.yaml"
```
