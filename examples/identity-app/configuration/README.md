# Playbooks

## Getting started
This folder contains Ansible playbooks and their corresponding roles which are used to deploy Identity App of Aries Demo for Hyperledger Indy on Managed Kubernetes Cluster(s).


## Prerequisites

To run the playbooks, following are the pre-requisites.
1. Ansible 2.8.2 with jmespath installed (You can use [hyperledgerlabs/baf-build](https://hub.docker.com/repository/docker/hyperledgerlabs/baf-build) image from Docker Hub).
2. Ansible controller configured like this [sample](../../../platforms/shared/inventory) inventory settings.
3. A running Hyperledger Indy network created by Blockchain Automation Framework on a cluster or Minukube.
4. A running Hashicorp Vault.
5. A Git User with write access to all the branches in the chosen Git repository. This user should be a service user and not a federated user.
6. Edited and saved network.yaml with all fields populated according to your requirements. A Sample network.yaml can be found [here](../../../platforms/hyperledger-indy/configuration/samples/network-indyv3-aries.yaml)

## Execution

### Step 1
Ensure that the `network.yaml` is edited properly and saved. Follow the guidance in the comments and readme.
Sample of `network.yaml` is in `../../../platforms/hyperledger-indy/configuration/samples/` - there are for aws `network-indyv3-aries.yaml` and Minikube `network-minikube-aries.yaml`.

### Step 2
Ideally, the configuration should be run by the following command from the root of the project.
```
ansible-playbook examples/identity-app/configuration/deploy-identity-app.yaml -e "@./path/to/your/network.yaml"
```
For minikube, pass additional parameter minikube_ip:
```
ansible-playbook examples/identity-app/configuration/deploy-identity-app.yaml -e "@./path/to/your/network.yaml" -e "minikube_ip='192.x.x.x'"
```
Ensure the public key counterpart of your private key specified in the network.yaml has been added to your GitHub repository with read/write access.<br>
