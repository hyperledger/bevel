# Playbooks

## Getting started
This folder contains ansible playbooks and their corresponding roles which are used to deploy R3 Corda on Managed Kubernetes Cluster(s).


## Prerequisites

To run the playbooks, following are the pre-requisites.
1. Ansible 2.8.2 with jmespath installed (a docker image can be made from this [Dockerfile](../../shared/images/ansibleSlave.Dockerfile)).
2. Ansible controller configured like this [sample](../../shared/inventory) inventory settings.
3. One Managed Kubernetes cluster for each organization (currently EKS tested so you need **AWS cli** credentials).
4. A Hashicorp Vault installation for each organization which is initiated and unsealed. The Vault IP Address should be accessible from this machine (where the playbook is run), and the Vault root token is available.
5. A Git User with write access to all the branches in the chosen Git repository. This user should be a service user and not a federated user.
6. Edited and saved network.yaml with all fields populated according to your requirements. A Sample network.yaml can be found [here](./samples/network-cordav2.yaml)

## Execution 

**NOTE**: If you are running the playbooks independently i.e. not using platforms/shared/configuration/site.yaml, then use the same network.yaml as input for each playbook.

### Step 1
Ensure that the `network.yaml` is edited properly and saved. Follow the guidance in the comments and readme.

### Step 2
Ideally, the configuration should be run by the following command from the root of the project. The [platforms/shared/configuration/site.yaml](../../shared/configuration/site.yaml) is the master playbook which does basic environment setup, kubernetes environment setup and then calls platform specific deployment playbooks.
```
ansible-playbook platforms/shared/configuration/site.yaml -e "@./platforms/samples/network-cordav2.yaml"
```
Ensure that you have added an **SSH Key** with read-write permission to your git repository before executing the playbook. Follow steps in [README](../../shared/configuration/README.md).<br>
If you just want to run this deploy-network.yaml playbook, then, from the *platforms/r3-corda/configuration* directory, run the following command for deploying the network
```
ansible-playbook deploy-network.yaml -e "@./samples/network-cordav2.yaml"
```
(Above command assumes that network-cordav2.yaml is present in samples directory).<br>
The playbook will create resources in the Kubernetes cluster(s) and will intermittently wait for resources to be created before proceeding. You may want to check the cluster(s) about any errors.
<br>
**NOTE**: The playbook has a wait for 5 minutes, this is needed so that the client certificates are valid. Read about the issue [here](https://eprint.iacr.org/2013/538.pdf)

### Step 3
After deploy-network.yaml has run successfully and your doorman, mongodb-doorman, networkmap, mongodb-networkmap and participating nodes should be up and running.

### Step 4
If NMS and Doorman is already up that is we only want to bring notary and nodes up then we can skip step 3 and run this step. To deploy notary and nodes run deploy-nodes.yaml playbook. If you want to run the playbook from the *platforms/r3-corda/configuration* directory, run the following command for deploying the network
```
ansible-playbook deploy-nodes.yaml -e "@./samples/network-cordav2.yaml"
```
(Above command assumes that network-cordav2.yaml is present in samples directory).<br>
The playbook will create resources in the Kubernetes cluster(s) and will intermittently wait for resources to be created before proceeding. You may want to check the cluster(s) about any errors.
<br>
**NOTE**: For Notary to be up Either Doorman or NETWORKMAP should be up and running. (Atleast NMS should be up)


### Step 5
After deploy-node.yaml has run successfully your notary and nodes should be up and running.

## Miscellenous

1. openssl.conf: This is the configuration file used to generate the Root CA Certificates for Corda doorman and networkamp.

2. If you want to reset the network, i.e. delete all created pods as well as the Flux deployment. Then run the following command (from the platforms/r3-corda/configuration/build directory)
```
ansible-playbook reset-network.yaml -e "@./samples/network-cordav2.yaml"
```
You can maintain separate `network-cordav2.yaml` for separate environments.
