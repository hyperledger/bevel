<a name = "adding-new-channel-to-existing-network-in-fabric"></a>
# Adding a new channel in Hyperledger Fabric

- [Prerequisites](#prerequisites)
- [Modifying configuration file](#create_config_file)
- [Running playbook to deploy Hyperledger Fabric network](#run_network)


<a name = "prerequisites"></a>
## Prerequisites
To add a new channel a fully configured Fabric network must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels). The corresponding crypto materials should also be present in their respective Hashicorp Vault. 

---
**NOTE**: Do not try to add a new organization as a part of this operation. Use only existing organization for new channel addition. 

---

<a name = "create_config_file"></a>
## Modifying Configuration File

Refer [this guide](./fabric_networkyaml.md) for details on editing the configuration file.

While modifying the configuration file(`network.yaml`) for adding new channel, all the existing channel should have `channel_status` tag as `existing` and the new channel should have `channel_status` tag as `new` under `network.channels` eg.

    network:
      channels:
      - channel:
        channel_status: existing
        ..
        ..
        participants:
        - organization:
          ..
          ..
        - organization:
          ..
          ..
      - channel:
        channel_status: new
        ..
        ..
        participants:
        - organization:
          ..
          ..
        - organization:
          ..
          ..


The `network.yaml` file should contain the specific `network.organization` patch along with the orderer information.


For reference, see `network-fabric-add-channel.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/samples).

<a name = "run_network"></a>
## Run playbook

The [add-new-channel.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/add-new-channel.yaml) playbook is used to add a new channel to the existing network. This can be done using the following command

```
ansible-playbook platforms/hyperledger-fabric/configuration/add-new-channel.yaml --extra-vars "@path-to-network.yaml"
```

---
**NOTE:** Make sure that the `channel_status` label was set as `new` when the network is deployed for the first time. If you have additional applications, please deploy them as well.
