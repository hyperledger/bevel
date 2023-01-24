[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Quorum Configuration
This configuration folder contains Ansible playbooks and their corresponding roles, which are used to deploy Quorum on Managed Kubernetes Cluster(s).


## Approaches
There are two approaches to deploy a DLT network using Hyperledger Bevel:
- Use a machine to deploy and manage the DLT network. This is recommended for production environments, and requires manual setup of Ansible, and other required libraries/tools for setting up the controller machine. More info on setting up this machine is found [here](https://hyperledger-bevel.readthedocs.io/en/latest/operations/configure_prerequisites.html#ansible-inventory-file).
- Use the 'Hyperledger Bevel Build container' to create a containerized Ansible controller from which to deploy/manage your networks. This is recommended for development instances, as it is an easy way to build the required base environment for Hyperledger Bevel deployment. More info can be found [here](https://hyperledger-bevel.readthedocs.io/en/latest/developer/docker-build.html).

## Installation pre-requisites
Hyperledger Bevel requires tools such as Kubernetes, Git (repository), Vault and more to be installed.
For more information on the installation pre-requisites, please refer to [this guide](https://hyperledger-bevel.readthedocs.io/en/latest/prerequisites.html).

## Configuration pre-requisites
For each organization in the DLT network you need to set up the following:
1. One Managed Kubernetes cluster; Hyperledger Bevel is currently tested on Amazon EKS, which means you will need AWS CLI set up as well.
2. A Hashicorp Vault installation for each organization which is initialized and unsealed. The Vault Address should be accessible from this machine (where the playbook is run) and the Kubernetes cluster. The Vault root token is used in the network configuration, so this should be available as well.
3. A Git User with write access to all the branches in the chosen Git repository; as well as an access token.
4. The network configuration file (`network.yaml`) which has been filled in according to your requirements. A sample `network.yaml` for Quorum can be found in [this folder](./samples/).

For other general pre-quisites, such as Docker images, Ambassador and DNS setup, please refer to the ['Configure Pre-requisites' guide](https://hyperledger-bevel.readthedocs.io/en/latest/operations/configure_prerequisites.html).

## Execution
### Step 1
Ensure that the `network.yaml` is edited properly and saved. Follow the guidance on our [docs for Quorum `network.yaml`](https://hyperledger-bevel.readthedocs.io/en/latest/operations/quorum_networkyaml.html).


### Step 2
Execute the playbook by running the command below - executed from the root of the project:
```
ansible-playbook platforms/shared/configuration/site.yaml -e "@/path/to/network-quorum.yaml"
```
The [platforms/shared/configuration/site.yaml](../../shared/configuration/site.yaml) is the main playbook which does basic environment setup, configures the Kubernetes cluster and then calls platform specific deployment playbooks.

You can also only run the platform specific deployment playbooks by running the command below (after the prerequisites have been installed) - executed from the root of the project:
```
ansible-playbook platforms/quorum/deploy-network.yaml -e "@/path/to/network-quorum.yaml"
```

### Step 3
After your Ansible command has completed. your nodes or the participants in the quorum network should be up and running. We are working on a verification document for Quorum.

## Miscellaneous

1. `./openssl.conf`: This is the configuration file used to generate the Root CA certificates for Quorum-CA.

2. If you want to reset the network, i.e. delete all created resources while setting up the Quorum network, you can run one of two following commands from the root folder of the project:
   ```
    # Call the shared playbook with `reset=true` which will first clean up the configuration (Flux,Helm, Kubernetes, Vault) and then reset the network
    ansible-playbook platforms/shared/configuration/site.yaml -e "@/path/to/network-quorum.yaml" -e "reset=true"
    ```
    ```
    # Directly call the platform-specific reset playbook
    ansible-playbook platforms/quorum/reset-network.yaml -e "@/path/to/network-quorum.yaml"
    ```
3. You can maintain separate `network.yaml`'s for separate environments (different amount of organizations, different configuration, etc.).
