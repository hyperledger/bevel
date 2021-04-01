<a name = "adding-new-peer-to-existing-organization-in-a-running-fabric-network"></a>
# Adding a new peer to existing organization in Hyperledger Fabric

- [Adding a new peer to existing organization in Hyperledger Fabric](#adding-a-new-peer-to-existing-organization-in-hyperledger-fabric)
  - [Prerequisites](#prerequisites)
  - [Modifying Configuration File](#modifying-configuration-file)
  - [Run playbook](#run-playbook)
  - [Chaincode Installation](#chaincode-installation)


<a name = "prerequisites"></a>
## Prerequisites
To add a new peer a fully configured Fabric network must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels) and the organization to which the peer is being added. The corresponding crypto materials should also be present in their respective Hashicorp Vault. 

---
**NOTE**: Addition of a new peer has been tested on an existing network which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.

---

<a name = "modifying-configuration-file"></a>
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
            gossipAddress: peer0.xxxx.com # gossip Address must be one existing peer
          - peer:
            ..
            ..
            peerstatus: existing  # existing for existing peers(s)
          

and under `network.organizations` as

    network:
      organizations:
        - organization:
          org_status: existing  # org_status must be existing when adding peer
          ..
          ..
          services:
            peers:
            - peer:
              ..
              ..
              peerstatus: new   # new for new peers(s)
              gossipAddress: peer0.xxxx.com # gossip Address must be one existing peer
            - peer:
              ..
              ..
              peerstatus: existing   # existing for existing peers(s)
            

The `network.yaml` file should contain the specific `network.organization` patch along with the orderer information. And the `org_status` must be `existing` when adding peer.


For reference, see `network-fabric-add-peer.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/samples).

<a name = "run-playbook"></a>
## Run playbook

The [add-peer.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/add-peer.yaml) playbook is used to add a new peer to an existing organization in the existing network. This can be done using the following command

```
ansible-playbook add-peer.yaml --extra-vars "@path-to-network.yaml"
```

---
**NOTE:** The `peerstatus` is not required when the network is deployed for the first time but is mandatory for addition of new peer. If you have additional applications, please deploy them as well.

---

<a name = "chaincode-install"></a>
## Chaincode Installation

Use the same network.yaml if you need to install chaincode on the new peers.

---
**NOTE:** With Fabric 2.2 chaincode lifecyle, re-installing chaincode on new peer is not needed as when the blocks are synced, the new peer will have access to already committed chaincode. If still needed, you can upgrade the version of the chaincode and install on all peers.

---

Refer [this guide](./install_instantiate_chaincode.md) for details on installing chaincode.