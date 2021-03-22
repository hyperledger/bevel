# Hyperledger Fabric Configuration
This configuration folder contains Ansible playbooks and their corresponding roles, which are used to deploy Hyperledger Fabric on Managed Kubernetes Cluster(s).


## Approaches
There are two approaches to deploy a DLT network using BAF: 
- Use a machine to deploy and manage the DLT network. This is recommended for production environments, and requires manual setup of Ansible, and other required libraries/tools for setting up the controller machine. More info on setting up this machine is found [here](https://blockchain-automation-framework.readthedocs.io/en/latest/operations/configure_prerequisites.html#ansible-inventory-file).
- Use the 'BAF Build container' to create a containerized Ansible controller from which to deploy/manage your networks. This is recommended for development instances, as it is an easy way to build the required base environment for BAF deployment. More info can be found [here](https://blockchain-automation-framework.readthedocs.io/en/latest/developer/docker-build.html).

## Installation pre-requisites
BAF requires tools such as Kubernetes, Git (repository), Vault and more to be installed.
For more information on the installation pre-requisites, please refer to [this guide](https://blockchain-automation-framework.readthedocs.io/en/latest/prerequisites.html).

## Configuration pre-requisites
For each organization in the DLT network you need to set up the following:
1. One Managed Kubernetes cluster; BAF is currently tested on Amazon EKS, which means you will need AWS CLI set up as well.
2. A Hashicorp Vault installation for each organization which is initialized and unsealed. The Vault Address should be accessible from this machine (where the playbook is run) and the Kubernetes cluster. The Vault root token is used in the network configuration, so this should be available as well.
3. A Git User with write access to all the branches in the chosen Git repository; as well as an access token.
4. The network configuration file (`network.yaml`) which has been filled in according to your requirements. A sample `network.yaml` for Hyperledger Fabric can be found in [this folder](./samples/).

For other general pre-quisites, such as Docker images, Ambassador and DNS setup, please refer to the ['Configure Pre-requisites' guide](https://blockchain-automation-framework.readthedocs.io/en/latest/operations/configure_prerequisites.html).

## Execution 
### Step 1
Ensure that the `network.yaml` is edited properly and saved. Follow the guidance on our [docs for Hyperledger Fabric `network.yaml`](https://blockchain-automation-framework.readthedocs.io/en/latest/operations/fabric_networkyaml.html).

### Step 2
Execute the playbook by running the command below - executed from the root of the project:
```
ansible-playbook platforms/shared/configuration/site.yaml -e "@/path/to/network-Fabricv3.yaml"
```
The [platforms/shared/configuration/site.yaml](../../shared/configuration/site.yaml) is the master playbook which does basic environment setup, configures the Kubernetes cluster and then calls platform specific deployment playbooks.

You can also only run the platform specific deployment playbooks by running the command below (after the prerequisites have been installed) - executed from the root of the project:
```
ansible-playbook platforms/hyperledger-fabric/deploy-network.yaml -e "@/path/to/network-fabricv2.yaml"
```


### Step 3
After `deploy-network.yaml` has run successfully and your Fabric orderer(s) and peer(s) are all running, and channels are created. To install and instantiate a chaincode, run the following command (from the `platforms/hyperledger-fabric/configuration` directory) using the same `network.yaml`, but with the `chaincode` sections updated.
```
ansible-playbook chaincode-ops.yaml -e "@./network.yaml" -e "add_new_org='false'"
```
This playbook will deploy the Kubernetes jobs which will install the chaincode for all peers and instantiate the chaincode from the Creator participant.

We are working on a verification document for Hyperledger Fabric.

## Miscellaneous

1. openssl.conf: This is the configuration file used to generate the Root CA Certificates for Fabric-CA.

2. In case you had to stop the deploy-network.yaml playbook after the crypto files were generated, or you already have existing crypto files, to deploy network from existing crypto files, run the following command (the crypto files should be in Hashicorp Vault)
    ```
    ansible-playbook generate-artifacts-deploy.yaml -e "@/path/to/network-fabric.yaml" -e "add_new_org='false'"
    ```

3. If you want to reset the network, i.e. delete all created pods as well as the Flux deployment. Then run the following command (from the platforms/hyperledger-fabric/configuration/build directory)
    ```
    # Call the shared playbook with `reset=true` which will first clean up the configuration (Helm, Kubernetes, Vault) and then reset the network
    ansible-playbook platforms/shared/configuration/site.yaml -e "@/path/to/network-fabric.yaml" -e "reset=true"  
    ```
    ```
    # Directly call the platform-specific reset playbook
    ansible-playbook platforms/hyperledger-fabric/reset-network.yaml -e "@/path/to/network-fabric.yaml" 
    ```
4. If you want to add an organization into existing network, then, from the *platforms/hyperledger-fabric/configuration* directory, run the following command: 
    ```
    ansible-playbook add-organization.yaml -e "@/path/to/network-fabric.yaml" -e "add_new_org='true'"
    ```
    Follow steps in [README](https://blockchain-automation-framework.readthedocs.io/en/latest/operations/adding_new_org_fabric.html).

    (Above command assumes that network.yaml is present in current directory with org_status tag and new organization details).<br>

5. After adding a new organization, if you want to explicitly install chaincode for new orgnization, then run the following command from the `platforms/hyperledger-fabric/configuration` directory
    ```
    ansible-playbook chaincode-ops.yaml -e "@/path/to/network-fabric.yaml" -e "add_new_org='true'"
    ```
    The playbook will create resources in the Kubernetes cluster(s) and will intermittently wait for resources to be created before proceeding. You may want to check the cluster(s) about any errors.

6. If you want to add a peer in existing organization which is a part of existing network, then, from the *platforms/hyperledger-fabric/configuration* directory, run the following command: 
    ```
    ansible-playbook add-peer.yaml -e "@/path/to/network-fabric.yaml" -e "add_new_org='false'" -e "add_peer='true'"
    ```
    Follow steps in [README](https://github.com/hyperledger-labs/blockchain-automation-framework/docs/source/operations/adding_new_peer_fabric.md).

    (Above command assumes that network.yaml is present in current directory with org_status tag and new organization details).<br>

7. If you want to add an orderer in existing network with raft cluster, then, from the *platforms/hyperledger-fabric/configuration* directory, run the following command: 
    ```
    ansible-playbook add-orderer.yaml -e "@/path/to/network-fabric.yaml"
    ```
    Follow steps in [README](https://github.com/hyperledger-labs/blockchain-automation-framework/docs/source/operations/adding_new_orderer_fabric.md).

    (Above command assumes that network.yaml is present in current directory with status tag in orderers under orderer organization and minimum three raft orderers running in the network ).<br>

8. You can maintain separate `network.yaml`s for separate environments (different amount of organizations, different configuration, etc.).