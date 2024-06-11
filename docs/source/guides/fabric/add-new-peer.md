[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Add a new peer to an existing organization

This guide explains how to add a new **general** (non-anchor) peer to an existing organization in a Hyperledger Fabric network using two methods:

1. Using the `add-peer.yaml` playbook: This method involves running an Ansible playbook that automates the process of adding a new peer to the network.

1. Using `helm install`: This method involves using the `helm install` commands to directly add a new peer to the network.

## Prerequisites
- A fully configured Fabric network with Orderers, Peers, Peer Organization and the Channel that the new peer will join. 
- Corresponding crypto materials present in Hashicorp Vault or Kubernetes secrets.
- Hyperledger Bevel configured.

## Method 1: Using the `add-peer.yaml` playbook

1. **Additional Considerations**

    Consider the following points when adding the new peer on a different cluster:

    - The CA server is accessible publicly or at least from the new cluster.
    - The CA server public certificate is stored in a local path and that path provided in `network.yaml`.
    - There is a single Hashicorp Vault and both clusters (as well as ansible controller) can access it.
    - Admin User certs have been already generated and stored in Vault (this is taken care of by deploy-network.yaml playbook if you are using Bevel to setup the network).
    - The `network.env.type` is different for different clusters.
    - The GitOps release directory `gitops.release_dir` is different for different clusters.

1. **Update Configuration File**

    - Edit the `network.yaml` file to include the new peer with the following details:
		- `peerstatus: new`
        - `org_status: existing`
		- Organization details (name, CA address, MSP ID, etc.)
		- Orderer information, if you are going to install/upgrade the existing chaincodes.
	- Existing peer(s) should have `peerstatus: existing`
    - Refer to the [networkyaml-fabric.md](../networkyaml-fabric.md) guide for details on editing the configuration file.

    Snippet from `network.channels` section below:
    ```yaml
    --8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabric-add-peer.yaml:60:87"
    ```

    and from `network.organizations` section below:

    ```yaml
    --8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabric-add-peer.yaml:94:103"
        ..
        ..
    --8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabric-add-peer.yaml:144:144"
    --8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabric-add-peer.yaml:153:159"
            ..
            ..
    --8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabric-add-peer.yaml:187:192"
            ..
            ..
    ```

1. **Run Playbook**
	
	Execute the following command to run the `add-peer.yaml` playbook:

	```
	ansible-playbook platforms/hyperledger-fabric/configuration/add-peer.yaml --extra-vars "@path-to-network.yaml"
	```
	Replace `path-to-network.yaml` with the actual path to your updated `network.yaml` file.

	This will add a new peer and the new peer will join the channel provided in the existing Fabric network.

## Method 2: Using `helm install`

1. **Update the fabric-peernode values.yaml file**

    Following changes are must in the `values.yaml` file for a new peer to be added to the network:

    - `certs.settings.createConfigMaps: false` as the ConfigMaps for certs are already generated in the same namespace.
	- `certs.settings.addPeerValue: true` Most important flag for adding a new Peer.
	- `peer.gossipPeerAddress: <existing peer address>` So that the new peer can gossip with existing peer.

    Refer to the [fabric-peernode chart documentation](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/charts/fabric-peernode) for a complete list of available configuration options.

1. **Install the fabric-peernode chart**
    
    Ensure the Orderer tls certificate is in `fabric-peernode/files`

    ```bash
    # Get the orderer.crt from Kubernetes
    cd ./platforms/hyperledger-fabric/charts/fabric-peernode/files
    kubectl --namespace supplychain-net get configmap orderer-tls-cacert -o jsonpath='{.data.cacert}' > orderer.crt
    ```

    Execute the following command to install the Peer chart:
	```bash
    cd ../..
	helm dependency update ./fabric-peernode
	helm install <release-name> ./fabric-peernode --namespace <namespace> --values <values-file.yaml>
	```
	Replace the following placeholders:

	- `<release-name>`: The desired name for the Peer release.
	- `<namespace>`: The Kubernetes namespace where the Peer should be deployed.
	- `<values-file.yaml>`: The path to a YAML file containing the new peer configuration values.

1. **Update the fabric-channel-join values.yaml file**

    After the peer has started, we need to join the channel. The channel should already exist in the network.
    Following changes are must in the `values.yaml` file for a new peer to join an existing channel:

    - `peer.name: <new peer name>`
	- `peer.type: general`
	- `peer.address: <new peer address>`
    - `peer.localMspId: <existing org MSP>`
    - `peer.channelName: <existing channel name>`
    - `peer.ordererAddress: <existing orderer grpc address>` the Orderer Address to which the peer should connect.

    Refer to the [fabric-channel-join chart documentation](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/charts/fabric-channel-join) for a complete list of available configuration options.

1. **Join the channel**

    Execute the following command to join the channel:
	```bash
	# From platforms/hyperledger-fabric/charts directory
	helm install <release-name> ./fabric-channel-join --namespace <namespace> --values <values-file.yaml>
	```
	Replace the following placeholders:

	- `<release-name>`: The desired name for the join channel release.
	- `<namespace>`: The Kubernetes namespace must be same as the namespace of the Peer release.
	- `<values-file.yaml>`: The path to a YAML file containing the updated join channel configuration values.

## Additional Notes
 
- The `peerstatus` is _optional_ when the network is deployed for the first time but is _mandatory_ for addition of new peer.

- Currently, only a `general` or non-anchor peer can be added.

- Chaincode Installation: Use the same `network.yaml` if you need to install chaincode on the new peers.

- With Fabric 2.2 and 2.5 chaincode lifecyle, re-installing chaincode on new peer is not needed as when the blocks are synced, the new peer will have access to already committed chaincode. If still needed, you can upgrade the version of the chaincode and install on all peers.

- Refer [Install chaincode guide](./chaincode-operations.md) or [Install external chaincode guide](./external-chaincode-operations.md) for details on installing chaincode.
