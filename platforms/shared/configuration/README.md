[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Playbooks

## Getting started
This folder contains ansible playbooks and their corresponding roles.
These playbooks enables creation of value files and felicitate deployment of the chosen DLT Network.

## Prerequisites for Running Playbooks
- Ansible is required to be setup on the machine.
- In Hyperledger Bevel we only connect to kubernetes cluster through our ansible and do not modify or connect to any other machine directly hence we have everything running on ansible controller . Hence the ansible host file has localhost setting. Check configuration [sample](../../shared/inventory/ansible_provisioners) inventory settings.

- A **network.yaml** file must be presented. This file is platform specific so far.
1. For Hyperledger Fabric, this file is in the below path. Click on the below link to go to this file.<br>
[platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml](../../hyperledger-fabric/configuration/samples/network-fabricv2.yaml)

2. For R3 Corda, this file is in the below path. Click on the below link to go to this file.<br>
[platforms/r3-corda/configuration/samples/network-cordav2.yaml](../../r3-corda/configuration/samples/network-cordav2.yaml)<br>

To run the playbooks, following are the pre-requisites.
1. Ansible 2.8.2 with jmespath installed (sample docker image can be made from this [Dockerfile](../../shared/images/ansibleAgent.Dockerfile)).
2. Ansible controller configured like this [sample](../../shared/inventory) inventory settings.
3. One Managed Kubernetes cluster for each organization (currently EKS tested so you need AWS cli credentials).
4. A Hashicorp Vault installation for each organization which is initiated and unsealed. The Vault IP Address should be accessible from this machine (where the playbook is run), and the Vault root token is available.
5. A Git User with write access to all the branches in the chosen Git repository. This user should be a service user and not a federated user.
6. Edited and saved network.yaml with all fields populated according to your requirements (as per guidance above). 

### Vault setup
Refer to the [Getting Started](https://learn.hashicorp.com/vault/getting-started/install) guide to install Vault. Make sure that your Vault server has been [initialized and unsealed](https://learn.hashicorp.com/vault/getting-started/deploy). Make a note of vault address and initialization token.     

### Private Key for GitOps
For synchronizing the Git repo with the cluster, Hyperledger Bevel configures Flux for each cluster. The authentication is via SSH key, so this key should be generated before you run the playbooks. 
Run the following command to generate a private-public key pair named **gitops**.

```
ssh-keygen -q -N "" -f ./gitops
```

The above command generates an SSH key-pair: **gitops** (private key) and **gitops.pub** (public key).

Use the path to the private key (**gitops**) in the `gitops.private_key` section of the **network.yaml**.

And add the public key contents (starts with **ssh-rsa**) as an Access Key (with read-write permissions) in your Github repository by following [this guide](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account).

## Execution 

**NOTE**: If you are running the playbooks independently i.e. not using platforms/shared/configuration/site.yaml, then use the same network.yaml as input for each playbook.

### Step 1
Ensure that the `network.yaml` is edited properly and saved. Follow the guidance in the comments and readme.

### Step 2
To deploy everything from scratch, be run by the following command from the root of the project. 
```
ansible-playbook platforms/shared/configuration/site.yaml -e "@./platforms/hyperledger-fabric/configuration/network.yaml"
```
The [site.yaml](./site.yaml) is the main playbook which does basic environment setup, kubernetes environment setup and the calls platform specific deployment playbooks.

## Miscellenous
#### Playbook description
`setup-enviorment.yaml` : This playbook takes a properly formatted network.yaml as the input. This playbook will set up the ansible machine with all the pre-requisites as needed by the subsequent playbooks. It will also install specific tools for Cloud Provider like AWS-cli in case AWS-EKS Cluster is used. 

`setup-k8s-enviorment.yaml` : This playbook takes a properly formatted network.yaml as the input. This playbook will set up the Kubernetes cluster pre-requisites like Flux and Ambassador on the provided Kubernetes clusters.

`site.yaml` : This playbook is the all encompassing playbook. This playbook takes a properly formatted network.yaml as the input. This playbook does the environment, kuebernetes setup and then calls respective DLT Platform deploy-network.yaml depending on the choice of platform to deploy the complete network.

To execute all the playbooks sequentially, run the following command after editing the correct network.yaml in the same folder as the playbook site.yaml
```
ansible-playbook site.yaml -e "@./network.yaml"
```
To reset the deployed network, run the following command after editing the correct network.yaml in the same folder as the playbook site.yaml
```
ansible-playbook site.yaml -e "@./network.yaml" -e "reset=true"
```

Individual playbooks can be run as
```
ansible-playbook setup-enviorment.yaml -e "@./network.yaml"
```
