[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)
# Run Bevel

Once your [pre-requisites](./prerequisites.md) are [configured](./configure-prerequisites.md), it's time to take the next step. Fork the [Hyperledger Bevel GitHub](https://github.com/hyperledger/bevel) repository and unlock the potential of this powerful tool for your Distributed Ledger Technology (DLT) deployment.

Now, let's explore two user-friendly methods for using Hyperledger Bevel: 

- [Using the **bevel-build** Docker container as Ansible controller.](#bevel-build)
- [Using your own machine as Ansible controller.](#own-machine)

<a name = "bevel-build"></a>
## Using Docker container

Follow [this tutorial](../tutorials/docker-deploy.md) for how to deploy from the docker container.

<a name = "own-machine"></a>
## Using Own machine

Using own machine as Ansible Controller needs these [additional pre-requisites](./prerequisites-machine.md).

!!! tip

    All the instructions are for an **Ubuntu** machine, but configurations can be changed for other machines. Although it is best to use the Docker container if you do not have an Ubuntu machine.


### Update Configuration File

Once all the pre-requisites have been configured, it is time to update Hyperledger Bevel configuration file. Depending on your platform of choice, there can be some differences in the configuration file. Please follow platform specific links below to learn more on updating the configuration file.

* [R3 Corda Configuration File](../guides/networkyaml-corda.md)
* [Hyperledger Fabric Configuration File](../guides/networkyaml-fabric.md)
* [Hyperledger Indy Configuration File](../guides/networkyaml-indy.md)
* [Quorum Configuration File](../guides/networkyaml-quorum.md)
* [Hyperledger Besu Configuration File](../guides/networkyaml-besu.md)
* [Substrate Configuration File](../guides/networkyaml-substrate.md)

### Deploy the Network

After the configuration file is updated and saved on the **Ansible Controller**, run the provisioning script to deploy the network using the following command.

```bash
# go to bevel
cd bevel
# Run the provisioning scripts
ansible-playbook  platforms/shared/configuration/site.yaml -e "@/path/to/network.yaml"
```

For more detailed instructions to set up a network, check [Setting up a DLT/Blockchain network Tutorial](../tutorials/machine-deploy.md).

For instructions on how to troubleshoot network, read [our troubleshooting guide](../references/troubleshooting.md)
