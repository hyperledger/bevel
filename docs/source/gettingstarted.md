Getting Started
===============

Before we begin, if you haven't already done so, you may wish to check that
you have all the [prerequisites](prerequisites) installed on the platform(s)
on which you'll be deploying blockchain networks from and/or operating
the Blockchain Automation Framework.

Once you have the prerequisites installed, you are ready to fork this repository and start using the Blockchain Automation Framework. 

## Configure Prerequisites
After installation of the [prerequisites](./prerequisites.md), some of them will need to be configured as per the Blockchain Automation Framework. Follow [these instructions](./operations/configure_prerequisites.md) to configure the pre-requistes and setting up of your environment.

## Update Configuration File
Once all the prerequisites have been configured, it is time to update the Blockchain Automation Framework configuration file. Depending on your platform of choice, there can be some differences in the configuration file. Please follow platform specific links below to learn more on updating the configuration file.
* [R3 Corda Configuration File](./operations/corda_networkyaml.md)
* [Hyperledger Fabric Configuration File](./operations/fabric_networkyaml.md)
* [Hyperledger Indy Configuration File](./operations/indy_networkyaml.md)
* [Quorum Configuration File](./operations/quorum_networkyaml.md)


## Deploy the Network

After the configuration file is updated, saved and the **Ansible Controller** is built using docker build as given in [prerequisites](prerequisites), run the provisioning script to deploy the network using the following command.

Read [DLT Network deployment using docker build](./developer/docker-build.md)

```
# Run the provisioning scripts
docker run -it -v $(pwd):/home/blockchain-automation-framework/ hyperledgerlabs/baf-build bash
$ ./home/blockchain-automation-framework/run.sh
```

For detailed instructions, read [Setting up a DLT network](./operations/setting_dlt.md).