[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)
# Run Bevel

Once your [pre-requisites](./prerequisites.md) are [configured](./configure-prerequisites.md), it's time to take the next step.

There are three user-friendly methods for using Hyperledger Bevel: 

- [Using Helm Charts](#using-helm-charts)
- [Using the **bevel-build** Docker container as Ansible controller.](#using-docker-container)
- [Using your own machine as Ansible controller.](#using-own-machine)

## Using Helm Charts

Release 1.1 onwards, Bevel can be used without Ansible automation. If you want to create a small development network, using the Helm charts will be simpler and faster. For production-ready networks or complex networks with multiple organisations, the below two options are recommended.

Follow the respective Helm chart documentation to setup your network:

* [R3 Corda Opensource Charts](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda/charts)
* [R3 Corda Enterprise Charts](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts)
* [Hyperledger Fabric Charts](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/charts)
* [Hyperledger Indy Charts](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-indy/charts)
* [Quorum Charts](https://github.com/hyperledger/bevel/tree/main/platforms/quorum/charts)
* [Hyperledger Besu Charts](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-besu/charts)
* [Substrate Charts](https://github.com/hyperledger/bevel/tree/main/platforms/substrate/charts)

## Using Docker container

Follow [this tutorial](../tutorials/docker-deploy.md) for how to deploy from the docker container.

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
