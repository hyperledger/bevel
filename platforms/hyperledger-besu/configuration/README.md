# Playbooks

## Getting started
This folder contains ansible playbooks and their corresponding roles which are used to deploy Hyperledger Besu on Managed Kubernetes Cluster(s).


## Prerequisites

To run the playbooks, following are the pre-requisites.
1. Ansible 2.8.2 with jmespath installed (a docker image can be made from this [Dockerfile](../../shared/images/ansibleSlave.Dockerfile)), or use the dockerfile given in the root.
2. Ansible controller configured like this [sample](../../shared/inventory) inventory settings.
3. One Managed Kubernetes cluster for each organization (currently tested on EKS so you need **AWS cli** credentials).
4. A Hashicorp Vault installation for each organization which is initiated and unsealed. The Vault Address should be accessible from this machine (where the playbook is run) and the Kubernetes cluster, and also, the Vault root token is available.
5. A Git User with write access to all the branches in the chosen Git repository. This user should be a service user and not a federated user.
6. Edited and saved network.yaml with all fields populated according to your requirements. A Sample network.yaml can be found [here](./samples/network-besu.yaml)

## Execution 

**NOTE**: If you are running the playbooks independently i.e. not using platforms/shared/configuration/site.yaml, then use the same network.yaml as input for each playbook.

### Step 1
Ensure that the `network.yaml` is edited properly and saved. Follow the guidance in the comments and readme.

### Step 2
Ideally, the configuration should be run by the following command from the root of the project. The [platforms/shared/configuration/site.yaml](../../shared/configuration/site.yaml) is the master playbook which does basic environment setup, kubernetes environment setup and then calls platform specific deployment playbooks.
```
ansible-playbook platforms/shared/configuration/site.yaml -e "@./platforms/samples/network-besu.yaml"
```
Ensure that you have added an **SSH Key** with read-write permission to your git repository before executing the playbook. Follow steps in [README](../../shared/configuration/README.md).<br>
If you just want to run this deploy-network.yaml playbook, then, from the *platforms/Hyperledger Besu/configuration* directory, run the following command for deploying the network
```
ansible-playbook deploy-network.yaml -e "@./samples/network-besu.yaml"
```
(Above command assumes that network-besu.yaml is present in samples directory).<br>
The playbook will create resources in the Kubernetes cluster(s) and will intermittently wait for resources to be created before proceeding. You may want to check the cluster(s) for any errors.
<br>

### Step 3
After deploy-network.yaml has run successfully, your nodes or the participants in the Hyperledger Besu network should be up and running.

## Miscellaneous

1. openssl.conf: This is the configuration file used to generate the Root CA certificates for Hyperledger Besu-CA.

2. If you want to reset the network, i.e. delete all created resources while setting up the Hyperledger Besu network like pods as well as the Flux deployment, then run the following command (from the platforms/Hyperledger Besu/configuration/ directory)
```
ansible-playbook reset-network.yaml -e "@./samples/network-besu.yaml"
```
You can maintain separate `network-besu.yaml` for separate environments.
