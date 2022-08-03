[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "removing-org-from-existing-network-in-fabric"></a>
# Removing an organization in Hyperledger Fabric

  - [Prerequisites](#prerequisites)
  - [Modifying Configuration File](#modifying-configuration-file)
  - [Run playbook](#run-playbook)


<a name = "prerequisites"></a>
## Prerequisites
To remove an organization a fully configured Fabric network must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels). The corresponding crypto materials should also be present in their respective Hashicorp Vault. 

---
**NOTE**: Removing an organization has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

---

<a name = "create_config_file"></a>
## Modifying Configuration File

Refer [this guide](./fabric_networkyaml.md) for details on editing the configuration file.

While modifying the configuration file(`network.yaml`) for removing an organization, all the existing organizations should have `org_status` tag as `existing` and to be deleted organization should have `org_status` tag as `delete` under `network.channels` e.g.

    network:
      channels:
      - channel:
        ..
        ..
        participants:
        - organization:
          ..
          ..
          org_status: delete  # delete for to be deleted organization(s)
        - organization:
          ..
          ..
          org_status: existing  # existing for old organization(s)

and under `network.organizations` as

    network:
      organizations:
        - organization:
          ..
          ..
          org_status: delete  # delete for to be deleted organization(s)
        - organization:
          ..
          ..
          org_status: existing  # existing for old organization(s)

The `network.yaml` file should contain the specific `network.organization` details along with the orderer information.


For reference, see `network-fabric-remove-organization.yaml` file [here](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/samples).

<a name = "run_network"></a>
## Run playbook

The [remove-organization.yaml](https://github.com/hyperledger/bevel/platforms/hyperledger-fabric/configuration/remove-organization.yaml) playbook is used to remove organization(s) from the existing network. This can be done using the following command

```
ansible-playbook platforms/hyperledger-fabric/configuration/remove-organization.yaml --extra-vars "@path-to-network.yaml"
```

---
**NOTE:** Make sure that the `org_status` label was set as `new` when the network is deployed for the first time. If you have additional applications, please deploy them as well.
