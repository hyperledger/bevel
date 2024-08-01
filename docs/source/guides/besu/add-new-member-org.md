[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "adding-new-member-org-to-existing-network-in-besu"></a>
# Adding a new member organization in Besu

  - [Prerequisites](#prerequisites)
  - [Create Configuration File](#create-configuration-file)
  - [Run playbook](#run-playbook)

<a name = "prerequisites"></a>
## Prerequisites
To add a new organization in Besu, an existing besu network should be running, enode information of all existing nodes present in the network should be available, genesis file should be available in base64 encoding and the information of besu nodes should be available. The new node account should be unlocked prior adding the new node to the existing besu network. 

!!! important

    Addition of a new organization has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

!!! note 

    The guide is only for the addition of member organization in existing besu network.

---

<a name = "create_config_file"></a>
## Create Configuration File

Refer [this guide](../networkyaml-besu.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organization` details along with the enode information, genesis file in base64 encoding and tessera transaction manager details

!!! note

    Make sure that the genesis file is provided in base64 encoding. Also, if you are adding node to the same cluster as of another node, make sure that you add the ambassador ports of the existing node present in the cluster to the network.yaml

For reference, sample `network-besu-new-memberorg.yaml` file [here](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-besu/configuration/samples/network-besu-new-memberorg.yaml)

```yaml
--8<-- "platforms/hyperledger-besu/configuration/samples/network-besu-new-memberorg.yaml:1:152"
```

Three new sections are added to the network.yaml

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| tm_nodes | Existing network's transaction manager nodes' public addresses with nodeport.|
| besu_nodes | Existing network's besu nodes' public addresses with rpc port.|
| genesis | Path to existing network's genesis.json in base64.|


<a name = "run_network"></a>
## Run playbook

The [site.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/site.yaml) playbook is used to add a new organization to the existing network. This can be done using the following command

```
ansible-playbook platforms/shared/configuration/add-new-organization.yaml --extra-vars "@path-to-network.yaml"
```

## Verify network deployment
For instructions on how to troubleshoot network, read [our troubleshooting guide](../../references/troubleshooting.md)

