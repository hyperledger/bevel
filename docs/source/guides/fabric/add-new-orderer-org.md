[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "adding-new-orderer-to-existing-network-in-fabric"></a>
# Adding a new Orderer organization in Hyperledger Fabric

- [Prerequisites](#prerequisites)
- [Modifying Configuration File](#modifying-configuration-file)
- [Run playbook](#run-playbook)

<a name = "prerequisites"></a>
## Prerequisites
To add a new Orderer organization, a fully configured Fabric network must be present already setup, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels). The corresponding crypto materials should also be present in their respective Hashicorp Vault. 

---
**NOTE**: Addition of a new Orderer organization has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.
Addition of new Orderer organization only works with Fabric 2.2.2, 2.5.4 and RAFT Service.

---

<a name = "create_config_file"></a>
## Modifying Configuration File

Refer [this guide](../networkyaml-fabric.md) for details on editing the configuration file.

While modifying the configuration file(`network.yaml`) for adding new orderer organization, all the existing organizations should have `org_status` tag as `existing` and the new organization should have `org_status` tag as `new` under `network.channels` e.g.


```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabric-add-ordererorg.yaml:64:138"
```

and under `network.organizations` as

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabric-add-ordererorg.yaml:145:154"
      ..
      ..
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabric-add-ordererorg.yaml:230:239"
      ..
      ..
```

The `network.yaml` file should contain the specific `network.organization` details along with the orderer information.


For reference, see `network-fabric-add-ordererorg.yaml` file [here](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/samples/network-fabric-add-ordererorg.yaml).

<a name = "run_network"></a>
## Run playbook

The [add-orderer-organization.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/add-orderer-organization.yaml) playbook is used to add a new Orderer organization to the existing network. This can be done using the following command

```
ansible-playbook platforms/hyperledger-fabric/configuration/add-orderer-organization.yaml --extra-vars "@path-to-network.yaml"
```

---
**NOTE:** Make sure that the `org_status` label was set as `new` when the network is deployed for the first time. If you have additional applications, please deploy them as well.
