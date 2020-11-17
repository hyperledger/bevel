<a name = "adding-new-orderer-to-existing-network-in-fabric"></a>
# Adding a new orderer in Hyperledger Fabric

- [Adding a new orderer in Hyperledger Fabric](#adding-a-new-orderer-in-hyperledger-fabric)
  - [Prerequisites](#prerequisites)
  - [Modifying Configuration File](#modifying-configuration-file)
  - [Run playbook](#run-playbook)


<a name = "prerequisites"></a>
## Prerequisites
To add a new raft orderer, a fully configured Fabric network with raft consensus must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels). The corresponding crypto materials should also be present in their respective Hashicorp Vault. The running fabric network should be having atleast 3 raft orderer in the running state.

---
**NOTE**: Addition of a new raft orderer has been tested on an existing network which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team. Only one new raft orderer can be added with one run of this playbook.

---

<a name = "create_config_file"></a>
## Modifying Configuration File

Refer [this guide](./fabric_networkyaml.md) for details on editing the configuration file.

While modifying the configuration file(`network.yaml`) for adding new orderer, the existing orderers should have `status` tag as `existing` and the new orderer should have `status` tag as `new` under `network.organizations` as

    network:
      organizations:
        - organization:
          ..
          ..
          type: orderer
          services:
            orderers:
            - orderer:
              ..
              ..
              status: existing # existing for existing orderers(s)
            - orderer:
              ..
              ..
              status: new # new for new orderer

The `network.yaml` file should contain the specific `network.organization` patch along with the orderer information.


For reference, see `network-fabric-add-orderer.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/samples).

<a name = "run_network"></a>
## Run playbook

The [add-orderer.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/add-orderer.yaml) playbook is used to add a new raft orderer to the existing raft network with minimum 3 running raft orderers . This can be done using the following command

```
ansible-playbook add-orderer.yaml --extra-vars "@path-to-network.yaml"
```

---
**NOTE:** The `status` label is not required in orderers when the network is deployed for the first time. If you have additional applications, please deploy them as well.
