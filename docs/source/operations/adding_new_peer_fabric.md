<a name = "adding-new-peer-to-existing-organization-in-a-running-fabric-network"></a>
# Adding a new peer to existing organization in Hyperledger Fabric

- [Adding a new peer to existing organization in Hyperledger Fabric](#adding-a-new-peer-to-existing-organization-in-hyperledger-fabric)
  - [Prerequisites](#prerequisites)
  - [Modifying Configuration File](#modifying-configuration-file)
  - [Run playbook](#run-playbook)


<a name = "prerequisites"></a>
## Prerequisites
To add a new peer a fully configured Fabric network must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels) and the organization to which the peer is being added. The corresponding crypto materials should also be present in their respective Hashicorp Vault. 

---
**NOTE**: Addition of a new peer has been tested on an existing network which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.

---

<a name = "create_config_file"></a>
## Modifying Configuration File

Refer [this guide](./fabric_networkyaml.md) for details on editing the configuration file.

While modifying the configuration file(`network.yaml`) for adding new peer, all the existing peers should have `peerstatus` tag as `existing` and the new peers should have `peerstatus` tag as `new` under `network.channels` eg.

    network:
      channels:
      - channel:
        ..
        ..
        participants:
        - organization:
          peers:
          - peer:
            ..
            ..
            peerstatus: new  # new for new peers(s)
          - peer:
            ..
            ..
            peerstatus: existing  # existing for existing peers(s)
          

and under `network.organizations` as

    network:
      organizations:
        - organization:
          ..
          ..
          services:
            peers:
            - peer:
              ..
              ..
              peerstatus: new   # new for new peers(s)
            - peer:
              ..
              ..
              peerstatus: existing   # existing for existing peers(s)
            

The `network.yaml` file should contain the specific `network.organization` patch along with the orderer information.


For reference, see `network-fabric-add-peer.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/samples).

<a name = "run_network"></a>
## Run playbook

The [add-peer.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/add-peer.yaml) playbook is used to add a new peer to an existing organization in the existing network. This can be done using the following command

```
ansible-playbook add-peer.yaml --extra-vars "@path-to-network.yaml" -e "add_new_org='false'" -e "add_peer='true'"
```

---
**NOTE:** The `peerstatus` is not required when the network is deployed for the first time. If you have additional applications, please deploy them as well.
