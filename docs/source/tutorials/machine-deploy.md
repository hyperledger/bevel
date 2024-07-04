[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# DLT Blockchain Network deployment using own Machine
## Pre-requisites
To create a Production DLT/Blockchain network, ensure you have the following:

1. One running Kubernetes Cluster and the Config file (default ~/.kube.config) per Organization.
1. One running Hashicorp Vault server per Organization. Unsealed and configured as per [guidance here](../getting-started/configure-prerequisites.md#unseal-hashicorp-vault).
1. Domain Name(s) configured as per [tutorial here](../tutorials/dns-settings.md).
1. Git user details per Organization as per [pre-requisites](../getting-started/configure-prerequisites.md#gitops-authentication).
1. Ansible controller configured as per [guidance here](../getting-started/prerequisites-machine.md).
1. If using SSH for Git, Private key file per Organization for GitOps with write-access to the Git repo as per [guidance here](../getting-started/configure-prerequisites.md#gitops-authentication).

!!! important
        
    All commands are executed from the `bevel` directory which is the default directory created when you clone our Git repo.

## Prepare build folder
If not already done, clone the git repository on your Ansible controller.
```bash
git clone https://github.com/<your username>/bevel.git
```
Create a folder called `build` inside `bevel`.
```bash
cd bevel
mkdir build
```
Copy the following files into the `build` folder:

* All the Kubernetes config files (config, kubeconfig.yaml).
* All the private key files (if using SSH for git).
    
## Edit the configuration file
Depending on your choice of DLT/Blockchain Platform, select a network.yaml and copy it to `build` folder.
```bash
# eg for Fabric
cp platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml build/network.yaml
```
Open and update the `network.yaml` according to the following Platform specific guides.

- [Hyperledger-Fabric](../guides/networkyaml-fabric.md)
- [R3-Corda](../guides/networkyaml-corda.md)    
- [Hyperledger-Indy](../guides/networkyaml-indy.md)
- [Quorum](../guides/networkyaml-quorum.md) 
- [Hyperledger-Besu](../guides/networkyaml-besu.md)
- [Substrate](../guides/networkyaml-substrate.md)

In summary, you will need to update the following:

1. `docker` url, username and password.
1. `external_url_suffix` depending on your Domain Name(s).
1. All DNS addresses depending on your Domain Name(s).
1. `cloud_provider`
1. `k8s` section depending on your Kubernetes zone/cluster name/config filepath.
1. `vault`
1. `gitops` section depending on your git username, tokens and private key filepath.

## Execute provisioning script

After all the configurations are updated in the `network.yaml`, execute the following to create the DLT network
```bash
# Run the provisioning scripts
ansible-playbook platforms/shared/configuration/site.yaml -e "@./build/network.yaml" 

```
The `site.yaml` playbook, in turn calls various playbooks depending on the configuration file and sets up your DLT/Blockchain network.

## Verify successful configuration

For instructions on how to troubleshoot network, read [our troubleshooting guide](../references/troubleshooting.md)

## Deleting an existing network
The above mentioned playbook [site.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/site.yaml) ([ReadMe](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/)) can be run to reset the network using the network configuration file having the specifications which was used to setup the network using the following command:
```bash
ansible-playbook platforms/shared/configuration/site.yaml -e "@./build/network.yaml" -e "reset=true"
```
