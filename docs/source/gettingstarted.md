[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)
# Getting Started

## Install and Configure Prerequisites
Follow instructions to [install](./prerequisites.md) and [configure](./operations/configure_prerequisites.md) common prerequisites first. Once you have the prerequisites installed and configured, you are ready to fork the GitHub repository and start using Hyperledger Bevel.

There are two ways in which you can start using Hyperledger Bevel for your DLT deployment. 

1. Using the **bevel-build** Docker container as Ansible controller.
2. Using your own machine as Ansible controller.

## Using Docker container

Follow [these instructions](./developer/docker-build.md) for how to use docker container as Ansible controller.

## Using Own machine

---
**NOTE** All the instructions are for an **Ubuntu** machine, but configurations can be changed for other machines. Although it is best to use the Docker container if you do not have an Ubuntu machine.

---

### Install additional Prerequisites
Install [additional prerequisites](./prerequisites_machine.md).

## Update Configuration File
Once all the prerequisites have been configured, it is time to update Hyperledger Bevel configuration file. Depending on your platform of choice, there can be some differences in the configuration file. Please follow platform specific links below to learn more on updating the configuration file.
* [R3 Corda Configuration File](./operations/corda_networkyaml.md)
* [Hyperledger Fabric Configuration File](./operations/fabric_networkyaml.md)
* [Hyperledger Indy Configuration File](./operations/indy_networkyaml.md)
* [Quorum Configuration File](./operations/quorum_networkyaml.md)
* [Hyperledger Besu Configuration File](./operations/besu_networkyaml.md)

## Deploy the Network

After the configuration file is updated and saved on the **Ansible Controller**, run the provisioning script to deploy the network using the following command.

```bash
# go to bevel
cd bevel
# Run the provisioning scripts
ansible-playbook  platforms/shared/configuration/site.yaml -e "@/path/to/network.yaml" 
```

For more detailed instructions to set up a network, read [Setting up a DLT/Blockchain network](./operations/setting_dlt.md).
For instructions on how to verify or troubleshoot network, read [How to debug a Bevel deployment](./operations/bevel_verify.md)
