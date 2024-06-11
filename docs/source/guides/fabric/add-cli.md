[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Add CLI to a Peer

This guide explains how to add a CLI to an existing Hyperledger Fabric network using two methods:

1. Using the `add-cli.yaml` playbook: This method involves running an Ansible playbook that automates the process of adding a CLI to the network.

1. Using `helm install`: This method involves using the helm install command to directly install the CLI chart.

## Prerequisites

- A fully configured Fabric network with Orderers and Peers. 
- Corresponding crypto materials present in Hashicorp Vault or Kubernetes secrets.
- Hyperledger Bevel configured.

## Method 1: Using the `add-cli.yaml` playbook

1. **Update Configuration File**

    - Edit the `network.yaml` file to include the new organization with the following details:
		- `org_status: new`
		- Organization details (name, MSP ID, etc.)
		- Orderer information
	- Existing organizations should have `org_status: existing`
    - Refer to the [networkyaml-fabric.md](../networkyaml-fabric.md) guide for details on editing the configuration file.

	Snippet from `network.channels` section below:
	```yaml
	--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabric-add-organization.yaml:65:139"
	```

	and from `network.organizations` section below:

	```yaml
	--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabric-add-organization.yaml:143:155"
		..
		..
	--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabric-add-organization.yaml:406:414"
		..
		..
	```

1. **Run Playbook**
	
	Execute the following command to run the `add-cli.yaml` playbook:

	```
	ansible-playbook platforms/hyperledger-fabric/configuration/add-cli.yaml --extra-vars "@path-to-network.yaml"
	```
	Replace `path-to-network.yaml` with the actual path to your updated `network.yaml` file.

	This will add the CLI to the specified organization in the existing Fabric network.

## Method 2: Using `helm install`

1. **Update the fabric-cli values.yaml file**
	
	The `values.yaml` file allows you to configure various aspects of the CLI, including:
	
	- The peer to which the CLI should connect.
	- The storage class and size for the CLI's persistent volume claim.
	- The local MSP ID of the organization.
	- The TLS status of the peer.
	- The GRPC Port of the peer.
	- The Orderer Address to which the CLI should connect.

	Refer to the [fabric-cli chart documentation](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/charts/fabric-cli) for a complete list of available configuration options.

1. **Install the CLI Chart**

	Execute the following command to install the CLI chart:
	```bash
	# From platforms/hyperledger-fabric/charts directory
	helm install <release-name> ./fabric-cli --namespace <namespace> --values <values-file.yaml>
	```
	Replace the following placeholders:

	- `<release-name>`: The desired name for the CLI release.
	- `<namespace>`: The Kubernetes namespace where the CLI should be deployed.
	- `<values-file.yaml>`: The path to a YAML file containing the CLI configuration values.

## Additional Notes
- The `add-cli.yaml playbook` and `helm install` method has been tested on networks created by Bevel. Networks created using other methods may be suitable, but this has not been tested by the Bevel team.
- Ensure that the network.yaml file contains the specific network.organization details along with the orderer information.
