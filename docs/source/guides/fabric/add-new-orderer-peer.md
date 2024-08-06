[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Add Orderer Node to an existing organization

This guide explains how to add an orderer node to an existing Hyperledger Fabric network using two methods:

1. Using the `add-orderer.yaml` playbook: This method involves running an Ansible playbook that automates the process of adding an orderer node to the network.

1. Using `helm install`: This method involves using the helm install command to directly install the orderer node chart.

## Prerequisites

- A fully configured Fabric network with Orderers and Peers. 
- Corresponding crypto materials present in Hashicorp Vault or Kubernetes secrets.
- Hyperledger Bevel configured.

## Method 1: Using the `add-cli.yaml` playbook

1. **Update Configuration File**

      To add a new Orderer node, a fully configured Fabric network must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels) and the organization to which the peer is being added. The corresponding crypto materials should also be present in their respective Hashicorp Vault. 

      ---
      **NOTE**: Addition of a new Orderer node has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.
      This works only for RAFT Orderer.

      ---

1. **Update Configuration File**

      A Sample configuration file for adding new orderer is available [here](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/configuration/samples/network-fabricv2-raft-add-orderer.yaml). Please go through this file and all the comments there and edit accordingly.

      For generic instructions on the Fabric configuration file, refer [this guide](../networkyaml-fabric.md).

      While modifying the configuration file(`network.yaml`) for adding new peer, all the existing orderers should have `status` tag as `existing` and the new orderers should have `status` tag as `new` under `network.organizations` as

      ```yaml

      --8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2-raft-add-orderer.yaml:126:135"
            ..
            ..
      --8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2-raft-add-orderer.yaml:174:174"
      --8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2-raft-add-orderer.yaml:185:220"

      ```
      and under `network.orderers` the new orderer must be added.

      ```yaml
      --8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2-raft-add-orderer.yaml:42:66"
      ```
            
      The `network.yaml` file should contain the specific `network.organization` details.

      Ensure the following is considered when adding the new orderer on a different cluster:
      - The CA server is accessible publicly or at least from the new cluster.
      - The CA server public certificate is stored in a local path and that path provided in network.yaml.
      - There is a single Hashicorp Vault and both clusters (as well as ansible controller) can access it.
      - Admin User certs have been already generated and store in Vault (this is taken care of by deploy-network.yaml playbook if you are using Bevel to setup the network).
      - The `network.env.type` is different for different clusters.
      - The GitOps release directory `gitops.release_dir` is different for different clusters.

1. **Run playbook**

      The [add-orderer.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/add-orderer.yaml) playbook is used to add a new peer to an existing organization in the existing network. This can be done using the following command

      ```
      ansible-playbook platforms/hyperledger-fabric/configuration/add-orderer.yaml --extra-vars "@path-to-network.yaml"
      ```

      ---
      **NOTE:** The `orderer.status` is not required when the network is deployed for the first time but is mandatory for addition of new orderer.


## Method 2: Using `helm install`

1. **Update the orderernode values.yaml file**

    Following changes are must in the `values.yaml` file for a new orderer node to be added to the network:

    - `certs.settings.createConfigMaps: false` as the ConfigMaps for certs are already generated in the same namespace.

    Refer to the [fabric-orderernode chart documentation](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/charts/fabric-orderernode) for a complete list of available configuration options.

1. **Install the orderernode chart**
    
    Execute the following command to install the Peer chart:
	```bash
	helm dependency update ./fabric-orderernode
	helm install <release-name> ./fabric-orderernode --namespace <namespace> --values <values-file.yaml>
	```
	Replace the following placeholders:

	- `<release-name>`: The desired name for the orderer node release.
	- `<namespace>`: The Kubernetes namespace where the Peer should be deployed.
	- `<values-file.yaml>`: The path to a YAML file containing the new peer configuration values.

1. **Update the osnadmin-channel-create values.yaml file**

    Following changes are must in the `values.yaml` file for a new orderer node to be added to the network:
      ```
      orderer:
            addOrderer: true
            name: orderer5
            localMspId: orgNameMSP
            ordererAddress: orderer1.orgname-net:443
      ```

    Refer to the [fabric-osn-channel-create chart documentation](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/charts/fabric-osn-channel-create) for a complete list of available configuration options.

1. **Install the osnadmin-channel-create chart**
    
    Execute the following command to install the fabric-osnadmin-channel-create chart:
	```bash
    cd ../..
	helm install <release-name> ./fabric-osnadmin-channel-create --namespace <namespace> --values <values-file.yaml>
	```
	Replace the following placeholders:

	- `<release-name>`: The desired name for the Peer release.
	- `<namespace>`: The Kubernetes namespace where the Peer should be deployed.
	- `<values-file.yaml>`: The path to a YAML file containing the new peer configuration values.


## Additional Notes
- The `add-orderer.yaml playbook` and `helm install` method has been tested on networks created by Bevel. Networks created using other methods may be suitable, but this has not been tested by the Bevel team.
- Ensure that the network.yaml file contains the specific network.organization details along with the orderer information.
