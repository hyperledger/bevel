[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Deploy Fabric Network using Operator

## Introduction

The [bevel-operator-fabric](https://github.com/hyperledger/bevel-operator-fabric) provides a streamlined way to deploy a Fabric network. It leverages the Kubernetes operator to manage the deployment of Certificate Authorities (CAs), Orderers, and Peers. This guide covers the deployment process using _bevel-operator-fabric_ version **1.9.0** and the Fabric platforms it supports.

!!! important

    Chaincode and user/certificate management are not yet supported by this Bevel release.  There will be separate issues to address these features. The current implementation supports channel creation and joining.


!!! note

	The bevel-operator-fabric automated deployment has been tested with Fabric 2.5.4.

## Understanding the Configuration File

A Sample configuration file for deploying using _bevel-operator-fabric_ is available [here](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/configuration/samples/network-operator-fabric.yaml). 

Here are the key changes from other versions:

1.  **`network.env.type`:**  Must be set to `operator`. This tells Ansible to use _bevel-operator-fabric_ for deployment.
1.  **`network.env.proxy`:**  Must be set to `istio` as _bevel-operator-fabric_ currently only supports Istio as a proxy.
1.  **External Port:** Only port `443` is supported for external access.
1.  **Removed Sections:** The `vault` and `gitops` sections are removed as they are not applicable to this deployment method.

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-operator-fabric.yaml:8:21"
    ..
    .. 
```

For a comprehensive guide on the Fabric configuration file, refer to [this guide](../networkyaml-fabric.md).

## Running the Deployment Playbook

After updating the `network.yaml` file with the necessary configurations, follow these steps to create your DLT network.

1. Run the provisioning scripts:
	```
	ansible-playbook platforms/shared/configuration/site.yaml -e "@./build/network.yaml" 
	```

	The `site.yaml` playbook will call various other playbooks based on your configuration file and set up your DLT/Blockchain network.

1. Alternative Deployment Method (Pre-requisites installed):

	If you have already installed and configured Istio and krew, you can use the [deploy-operator-network.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/deploy-operator-network.yaml) playbook:

	```
	ansible-playbook platforms/hyperledger-fabric/configuration/deploy-operator-network.yaml -e "@/path/to/network.yaml"
	```

## Manual Deployment
For detailed information about the operator and latest releases, and also for manual deployment instructions, refer to the [bevel-operator-fabric documentation](https://hyperledger.github.io/bevel-operator-fabric/).
