[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Add a new member to an existing organization

This guide explains how to add a new validator node to an existing organization in a Quorum network using two methods:

1. Using the `site.yaml` playbook: This playbook involves running an Ansible playbook that automates the process of adding a new org to the network.

1. Using `helm install`: This method involves using the `helm install` commands to directly add a new org to the network.

## Method 1: Using the `site.yaml` playbook

1. **Prerequisites**

    To add a new organization in Quorum, an existing quorum network should be running, enode information of all existing nodes present in the network should be available, genesis block should be available in base64 encoding and the geth information of a node should be available and that node account should be unlocked prior adding the new node to the existing quorum network. 

    !!! important
        
        Addition of a new organization has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

1. **Create Configuration File**

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

1. **Run playbook**

    The [site.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/site.yaml) playbook is used to add a new organization to the existing network. This can be done using the following command

    ```
    ansible-playbook platforms/shared/configuration/site.yaml --extra-vars "@path-to-network.yaml"
    ```

1. **Verify network deployment**

    For instructions on how to troubleshoot network, read [our troubleshooting guide](../references/troubleshooting.md)

## Method 2: Using `helm install`

    For instructions on how to troubleshoot network, read [our troubleshooting guide](../../../../platforms/quorum/charts/README.md)

1. **Get the genesis and static nodes from existing member and place in quorum-genesis/files**

    ```bash
    cd ./quorum-genesis/files/
    kubectl --namespace supplychain-quo get configmap quorum-peers -o jsonpath='{.data.static-nodes\.json}' > static-nodes.json
    kubectl --namespace supplychain-quo get configmap quorum-genesis  -o jsonpath='{.data.genesis\.json}' > genesis.json
    ```

1. **Install the quorum genesis chart**

    ```bash
    helm install genesis ./quorum-genesis --namespace carrier-quo --values ./values/proxy-and-vault/genesis-sec.yaml
    ```

1. **Install the besu-node chart**

    ```bash
    helm install carrier ./quorum-node --namespace carrier-quo --values ./values/proxy-and-vault/txnode-sec.yaml --set global.proxy.p2p=15016
    ```