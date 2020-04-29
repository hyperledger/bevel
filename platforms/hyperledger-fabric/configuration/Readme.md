# Playbooks

## Getting started
This folder contains ansible playbooks and their corresponding roles which are used to deploy Hyperledger Fabric on Managed Kubernetes Cluster(s).


## Prerequisites

To run the playbooks, following are the pre-requisites.
1. Ansible 2.8.2 with jmespath installed (a docker image can be made from this [Dockerfile](../../shared/images/ansibleSlave.Dockerfile)).
2. Ansible controller configured like this [sample](../../shared/inventory) inventory settings.
3. One Managed Kubernetes cluster for each organization (currently EKS tested so you need **AWS cli** credentials).
4. A Hashicorp Vault installation for each organization which is initiated and unsealed. The Vault IP Address should be accessible from this machine (where the playbook is run), and the Vault root token is available.
5. A Git User with write access to all the branches in the chosen Git repository. This user should be a service user and not a federated user.
6. Edited and saved network.yaml with all fields populated according to your requirements. A Sample network.yaml can be found [here](./samples/network-fabricv2.yaml)

## Execution

**NOTE**: If you are running the playbooks independently i.e. not using platforms/shared/configuration/site.yaml, then use the same network.yaml as input for each playbook.

### Step 1
Ensure that the `network.yaml` is edited properly and saved. Follow the guidance in the comments and readme.
To help with this, here is a [preparation script template](prepare.sh.template).
Copy it locally, fill the values from its first section and run against the mentioned version of network.yaml.

### Step 2
Ideally, the configuration should be run by the following command from the root of the project. The [platforms/shared/configuration/site.yaml](../../shared/configuration/site.yaml) is the master playbook which does basic environment setup, kubernetes environment setup and then calls platform specific deployment playbooks.
```
ansible-playbook platforms/shared/configuration/site.yaml -e "@./platforms/hyperledger-fabric/configuration/network.yaml"
```
Ensure that you have added an **SSH Key** with read-write permission to your git repository before executing the playbook. Follow steps in [README](../../shared/configuration/README.md).<br>
If you just want to run this deploy-network.yaml playbook, then, from the *platforms/hyperledger-fabric/configuration* directory, run the following command for deploying the network
```
ansible-playbook deploy-network.yaml -e "@./network.yaml" -e "add_new_org='false'"
```
(Above command assumes that network.yaml is present in current directory).<br>
The playbook will create resources in the Kubernetes cluster(s) and will intermittently wait for resources to be created before proceeding. You may want to check the cluster(s) about any errors.
<br>
**NOTE**: The playbook has a wait for 5 minutes, this is needed so that the client certificates are valid. Read about the issue [here](https://eprint.iacr.org/2013/538.pdf)

### Step 3
After deploy-network.yaml has run successfully and your Fabric orderer(s) and peer(s) are all running, and channels are created. To install and instantiate a chaincode, run the following command (from the platforms/hyperledger-fabric/configuration directory) using the same network.yaml (with chaincode sections updated)
```
ansible-playbook chaincode-install-instantiate.yaml -e "@./network.yaml" -e "add_new_org='false'"
```
This playbook will deploy the Kubernetes jobs which will install the chaincode for all peers and instantiate the chaincode from the Creator participant.

## Miscellaneous

1. openssl.conf: This is the configuration file used to generate the Root CA Certificates for Fabric-CA.

2. In case you had to stop the deploy-network.yaml playbook after the crypto files were generated, or you already have existing crypto files, to deploy network from existing crypto files, run the following command (the crypto files should be in Hashicorp Vault)
```
ansible-playbook generate-artifacts-deploy.yaml -e "@./network.yaml" -e "add_new_org='false'"
```

3. If you want to reset the network, i.e. delete all created pods as well as the Flux deployment. Then run the following command (from the platforms/hyperledger-fabric/configuration/build directory)
```
ansible-playbook reset-network.yaml -e "@./network.yaml"
```

4. If you want to add an organization into existing network, then, from the *platforms/hyperledger-fabric/configuration* directory, run the following command 
```
ansible-playbook add-organization.yaml -e "@./network.yaml" -e "add_new_org='true'"
```
Follow steps in [README](https://github.com/hyperledger-labs/blockchain-automation-framework/docs/source/operations/adding_new_org_fabric.md).

(Above command assumes that network.yaml is present in current directory with org_status tag and new organization details).<br>

5. After adding a new organization, if you want to explicitly install chaincode for new orgnization, then run the following command from the *platforms/hyperledger-fabric/configuration* directory
```
ansible-playbook chaincode-install-instantiate.yaml -e "@./network.yaml" -e "add_new_org='true'"
```
The playbook will create resources in the Kubernetes cluster(s) and will intermittently wait for resources to be created before proceeding. You may want to check the cluster(s) about any errors.

You can maintain separate `network.yaml` for separate environments.
