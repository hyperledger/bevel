[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "adding-new-org-to-existing-network-in-corda"></a>
# Adding a new organization in R3 Corda

- [Prerequisites](#prerequisites)
- [Create configuration file](#create-configuration-file)
- [Run playbook](#run-playbook)

<a name = "prerequisites"></a>
## Prerequisites
To add a new organization, Corda Doorman/Idman and Networkmap services should already be running. The public certificates from Doorman/Idman and Networkmap should be available and specified in the configuration file. 

!!! note
    Addition of a new organization has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

<a name = "create_config_file"></a>
## Create Configuration File

Refer [this guide](../networkyaml-corda.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organization` details along with the network service information about the networkmap and doorman service.

!!! note
    Make sure the doorman and networkmap service certificates are in plain text and not encoded in base64 or any other encoding scheme, along with correct paths to them mentioned in network.yaml.

For reference, sample `network.yaml` file [here] (https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda/configuration/samples/network-cordav2.yaml) but always check the latest `network.yaml` file.

```yaml
--8<-- "platforms/r3-corda/configuration/samples/network-cordav2.yaml:1:223"
```

<a name = "run_network"></a>
## Run playbook

The [add-new-organization.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/shared/configuration/add-new-organization.yaml) playbook is used to add a new organization to the existing network. This can be done using the following command

```
ansible-playbook platforms/shared/configuration/add-new-organization.yaml --extra-vars "@path-to-network.yaml"
```

!!! note
    If you have CorDapps and applications, please deploy them as well.
