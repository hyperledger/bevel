[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "adding-new-peer-to-existing-organization-in-a-running-fabric-network"></a>
# Adding a new peer to existing organization in Hyperledger Fabric

  - [Prerequisites](#prerequisites)
  - [Modifying Configuration File](#modifying-configuration-file)
  - [Run playbook](#run-playbook)
  - [Chaincode Installation](#chaincode-installation)


<a name = "prerequisites"></a>
## Prerequisites
To add a new peer a fully configured Fabric network must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels) and the organization to which the peer is being added. The corresponding crypto materials should also be present in their respective Hashicorp Vault. 

---
**NOTE**: Addition of a new peer has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

---

<a name = "modifying-configuration-file"></a>
## Modifying Configuration File

A Sample configuration file for adding new peer is available [here](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/configuration/samples/network-fabricv-add-peer.yaml). Please go through this file and all the comments there and edit accordingly.

For generic instructions on the Fabric configuration file, refer [this guide](./fabric_networkyaml.md).

While modifying the configuration file(`network.yaml`) for adding new peer, all the existing peers should have `peerstatus` tag as `existing` and the new peers should have `peerstatus` tag as `new` under `network.channels` e.g.

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
            

The `network.yaml` file should contain the specific `network.organization` details. Orderer information is needed if you are going to install/upgrade the existing chaincodes, otherwise it is not needed. And the `org_status` must be `existing` when adding peer.

Ensure the following is considered when adding the new peer on a different cluster:
- The CA server is accessible publicly or at least from the new cluster.
- The CA server public certificate is stored in a local path and that path provided in network.yaml.
- There is a single Hashicorp Vault and both clusters (as well as ansible controller) can access it.
- Admin User certs have been already generated and store in Vault (this is taken care of by deploy-network.yaml playbook if you are using Bevel to setup the network).
- The `network.env.type` is different for different clusters.
- The GitOps release directory `gitops.release_dir` is different for different clusters.

<a name = "run-playbook"></a>
## Run playbook

The [add-peer.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/add-peer.yaml) playbook is used to add a new peer to an existing organization in the existing network. This can be done using the following command

```
ansible-playbook platforms/hyperledger-fabric/configuration/add-peer.yaml --extra-vars "@path-to-network.yaml"
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
