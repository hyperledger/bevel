[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# DLT Blockchain Network deployment using Docker

!!! important
    
    Hyperledger Bevel is targeted for Production systems, but for quick developer deployments, you can use the containerized Ansible controller to deploy the dev DLT/Blockchain network.  

## Pre-requisites

Follow instructions to [install](../getting-started/prerequisites.md) and [configure](../getting-started/configure-prerequisites.md) common pre-requisites. In summary, you should have details of the following:

1. A machine (aka host machine) on which you can run docker commands i.e. which has docker command line installed and is connected to a docker daemon.
2. At least one Kubernetes cluster (with connectivity to the host machine).
3. At least one Hashicorp Vault server (with connectivity to the host machine).
4. Read-write access to the Git repo (either ssh private key or https access token).

## Prepare build folder
Clone the git repository on host machine, call this the project folder.
```bash
git clone https://github.com/<your username>/bevel

```
Create a folder called `build` inside `bevel`.
```bash
cd bevel
mkdir build
```
Copy the following files into the `build` folder:

* The Kubernetes config file for your cluster (config).
* The private key file (gitops, if using SSH for git).

## Edit the configuration file
Depending on your chosen DLT platform, select a sample `network.yaml` (e.g. For Fabric, choose from [this sample](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml)) and copy to `build` folder.
```bash
# eg for Fabric
cp platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml build/network.yaml
```

Open and update the `network.yaml` according to the following Platform specific guides.

* [R3 Corda Configuration File](../guides/networkyaml-corda.md)
* [Hyperledger Fabric Configuration File](../guides/networkyaml-fabric.md)
* [Hyperledger Indy Configuration File](../guides/networkyaml-indy.md)
* [Quorum Configuration File](../guides/networkyaml-quorum.md)
* [Hyperledger Besu Configuration File](../guides/networkyaml-besu.md)
* [Substrate Configuration File](../guides/networkyaml-substrate.md)

In summary, you will need to update the following:

1. `docker` url, username and password.
1. `external_url_suffix` depending on your Domain Name(s).
1. All DNS addresses depending on your Domain Name(s).
1. `cloud_provider`
1. `k8s` section depending on your Kubernetes zone/cluster name/config filepath.
1. `vault`
1. `gitops` section depending on your git username, tokens and private key filepath.

Now, the `build` folder should have the following files:

- K8s config file as config.
- Network specific configuration file as network.yaml.
- If using SSH for Gitops, [private key file](../getting-started/configure-prerequisites.md#gitops-authentication) which has write-access to the git repo.

Screen shot of the folder structure is below:   

![](./../_static/DockerBuildFolder.png)

## Execute provisioning script

Run the following command to run the provisioning scripts, the command needs to be run from the `bevel` folder. The command also binds and mounts a volume, in this case it binds the repository 

```bash
cd bevel

docker run -it -v $(pwd):/home/bevel/ --network="host" ghcr.io/hyperledger/bevel-build:latest

# For Corda use jdk8 version
docker run -it -v $(pwd):/home/bevel/ --network="host" ghcr.io/hyperledger/bevel-build:jdk8-latest
```

In case you have failures and need to debug, login to the bash shell

```bash
docker run -it -v $(pwd):/home/bevel/ --network="host" ghcr.io/hyperledger/bevel-build:latest bash

# go to bevel directory
cd bevel
# Run the provisioning scripts
ansible-playbook  platforms/shared/configuration/site.yaml -e "@./build/network.yaml" 
```

## Verify successful configuration

For instructions on how to verify or troubleshoot network, read [How to debug a Bevel deployment](../references/troubleshooting.md).

## Deleting an existing network
The above mentioned playbook [site.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/site.yaml) ([ReadMe](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/)) can be run to reset the network using the network configuration file having the specifications which was used to setup the network using the following command:
```bash
docker run -it -v $(pwd):/home/bevel/ --network="host" ghcr.io/hyperledger/bevel-build:latest bash
cd bevel
ansible-playbook platforms/shared/configuration/site.yaml -e "@./build/network.yaml" -e "reset=true"
```
