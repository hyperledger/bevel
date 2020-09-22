# R3 Corda Configuration
This configuration folder contains Ansible playbooks and their corresponding roles, which are used to deploy R3 Corda on Managed Kubernetes Cluster(s).


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
4. The network configuration file (`network.yaml`) which has been filled in according to your requirements. Sample `network.yaml`s for R3 Corda can be found in [this folder](./samples/).

For other general pre-quisites, such as Docker images, Ambassador and DNS setup, please refer to the ['Configure Pre-requisites' guide](https://blockchain-automation-framework.readthedocs.io/en/latest/operations/configure_prerequisites.html).

## Execution 
### Step 1
Ensure that the `network.yaml` is edited properly and saved. Follow the guidance on our [docs for R3 Corda `network.yaml`](https://blockchain-automation-framework.readthedocs.io/en/latest/operations/corda_networkyaml.html).

### Step 2
Execute the playbook by running the command below - executed from the root of the project:
```
ansible-playbook platforms/shared/configuration/site.yaml -e "@/path/to/network-corda.yaml"
```
The [platforms/shared/configuration/site.yaml](../../shared/configuration/site.yaml) is the master playbook which does basic environment setup, configures the Kubernetes cluster and then calls platform specific deployment playbooks.

You can also only run the platform specific deployment playbooks by running the command below (after the prerequisites have been installed) - executed from the root of the project:
```
ansible-playbook platforms/r3-corda/deploy-network.yaml -e "@/path/to/network-corda.yaml"
```
**NOTE**: The playbook has a wait for 5 minutes, this is needed so that the client certificates are valid. Read about the issue [here](https://eprint.iacr.org/2013/538.pdf)

### Step 3
After the `deploy-network.yaml` has run successfully and your `doorman`, `mongodb-doorman`, `networkmap`, `mongodb-networkmap` and participating nodes should be up and running.

### Step 4
After your Ansible command has completed. your nodes or the participants in the R3 Corda network should be up and running. We are working on a verification document for R3 Corda .

## Miscellaneous

1. openssl.conf: This is the configuration file used to generate the Root CA Certificates for Corda Doorman and Networkmap.

2. If you want to reset the network, i.e. delete all created resources while setting up the R3 Corda network, you can run one of two following commands from the root folder of the project:
    ```
    # Call the shared playbook with `reset=true` which will first clean up the configuration (Helm, Kubernetes, Vault) and then reset the network
    ansible-playbook platforms/shared/configuration/site.yaml -e "@/path/to/network-corda.yaml" -e "reset=true"  
    ```
    ```
    # Directly call the platform-specific reset playbook
    ansible-playbook platforms/r3-corda/reset-network.yaml -e "@/path/to/network-corda.yaml" 
    ```
3. You can maintain separate `network.yaml`'s for separate environments (different amount of organizations, different configuration, etc.).
