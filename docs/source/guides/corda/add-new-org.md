[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Add a new member to an existing organization

This guide explains how to add a new validator node to an existing organization in a a R3 Corda network using two methods:

1. Using the `add-new-organization.yaml` playbook: This playbook involves running an Ansible playbook that automates the process of adding a new org to the network.

1. Using `helm install`: This method involves using the `helm install` commands to directly add a new org to the network.

## Method 1: Using the `add-new-organization.yaml` playbook

1. **Prerequisites**
    To add a new organization, Corda Doorman/Idman and Networkmap services should already be running. The public certificates from Doorman/Idman and Networkmap should be available and specified in the configuration file. 

    !!! note
        Addition of a new organization has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

1. **Create Configuration File**

    Refer [this guide](../networkyaml-corda.md) for details on editing the configuration file.

    The `network.yaml` file should contain the specific `network.organization` details along with the network service information about the networkmap and doorman service.

    !!! note
        Make sure the doorman and networkmap service certificates are in plain text and not encoded in base64 or any other encoding scheme, along with correct paths to them mentioned in network.yaml.

    For reference, sample `network.yaml` file [here](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda/configuration/samples/network-cordav2.yaml) but always check the latest `network.yaml` file.

    ```yaml
    --8<-- "platforms/r3-corda/configuration/samples/network-cordav2.yaml:1:223"
    ```

1. **Run playbook**

    The [add-new-organization.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/shared/configuration/add-new-organization.yaml) playbook is used to add a new organization to the existing network. This can be done using the following command

    ```
    ansible-playbook platforms/shared/configuration/add-new-organization.yaml --extra-vars "@path-to-network.yaml"
    ```

    !!! note
        If you have CorDapps and applications, please deploy them as well.

## Method 2: Using `helm install`

Refer [this guide](../../../../platforms/r3-corda/charts/README.md) for details on editing the configuration file.

1. **Update the node.yaml file**

    Following changes are must in the `node.yaml` file for a new member to be added to the network:

    - `global.proxy.externalUrlSuffix`
	- `nodeConf.legalName`

1. **Get the init and static nodes from existing member and place in corda-init/files**

    ```bash
    cd ./corda-init/files/
    kubectl --namespace supplychain-ns get secret nms-tls-certs -o jsonpath='{.data.tls\.crt}' > nms.crt
    kubectl --namespace supplychain-ns get secret doorman-tls-certs  -o jsonpath='{.data.tls\.crt}' > doorman.crt
    ```

1. **Install the init-sec chart**

    ```bash
    helm install init ./corda-init --namespace manufacturer-ns --values ./values/proxy-and-vault/init-sec.yaml

    helm install manufacturer ./corda-node --namespace manufacturer-ns --values ./values/proxy-and-vault/node.yaml --set nodeConf.legalName="O=Manufacturer\,OU=Manufacturer\,L=47.38/8.54/Zurich\,C=CH"
    ```