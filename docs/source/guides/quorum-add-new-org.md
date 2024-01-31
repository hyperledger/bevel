[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "adding-new-org-to-existing-network-in-quorum"></a>
# Adding a new node in Quorum

  - [Prerequisites](#prerequisites)
  - [Create Configuration File](#create-configuration-file)
  - [Run playbook](#run-playbook)

<a name = "prerequisites"></a>
## Prerequisites
To add a new organization in Quorum, an existing quorum network should be running, enode information of all existing nodes present in the network should be available, genesis block should be available in base64 encoding and the geth information of a node should be available and that node account should be unlocked prior adding the new node to the existing quorum network. 

!!! important
    
    Addition of a new organization has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

<a name = "create_config_file"></a>
## Create Configuration File

Refer [this guide](./networkyaml-quorum.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organization` details along with the enode information, genesis block in base64 encoding and geth account details

!!! note

    Make sure that the genesis block information is given in base64 encoding. Also, if you are adding node to the same cluster as of another node, make sure that you add the ambassador ports of the existing node present in the cluster to the network.yaml

For reference, sample `network-quorum-newnode.yaml` file [here](https://github.com/hyperledger/bevel/blob/main/platforms/quorum/configuration/samples/network-quorum-newnode.yaml)

```yaml
--8<-- "platforms/quorum/configuration/samples/network-quorum-newnode.yaml:1:133"
```

Below three new sections are added to the network.yaml

| Field                            | Description                                        |
|----------------------------------|----------------------------------------------------|
| staticnodes                      | Existing network's static nodes file path needs to be given                               |
| genesis                              | Existing network's genesis.json file path needs to be given  |
| bootnode                          | Bootnode account details.                         |


The `network.config.bootnode` field contains:

| Field                            | Description                                        |
|----------------------------------|----------------------------------------------------|
| name                             | Name of the bootnode                               |
| url                              | URL of the bootnode, generally the ambassador URL  |
| rpcport                          | RPC port of the bootnode                           |
| nodeid                           | Node ID of the bootnode                            |

<a name = "run_network"></a>
## Run playbook

The [site.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/site.yaml) playbook is used to add a new organization to the existing network. This can be done using the following command

```
ansible-playbook platforms/shared/configuration/site.yaml --extra-vars "@path-to-network.yaml"
```

## Verify network deployment
For instructions on how to troubleshoot network, read [our troubleshooting guide](../references/troubleshooting.md)
