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
* [Hyperledger Besu Configuration File](./operations/besu_networkyaml.md)


## Deploy the Network

After the configuration file is updated and saved on the **Ansible Controller**, run the provisioning script to deploy the network using the following command.

```bash
# go to blockchain-automation-framework
cd blockchain-automation-framework
# Run the provisioning scripts
ansible-playbook  platforms/shared/configuration/site.yaml -e "@/path/to/network.yaml" 
```

For more detailed instructions to set up a network, read [Setting up a DLT/Blockchain network](./operations/setting_dlt.md).
