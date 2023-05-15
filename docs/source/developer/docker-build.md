[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# DLT Blockchain Network deployment using Docker

Hyperledger Bevel is targeted for Production systems, but for quick developer deployments, you can create the containerized Ansible controller to deploy the dev DLT/Blockchain network.  

## Prerequisites

Follow instructions to [install](https://hyperledger-bevel.readthedocs.io/en/latest/developer/docker-build.html#prerequisites) and [configure](https://hyperledger-bevel.readthedocs.io/en/latest/operations/configure_prerequisites.html) common prerequisites. In summary, you should have details of the following:

1. A machine (aka host machine) on which you can run docker commands i.e. which has docker command line installed and is connected to a docker daemon.
2. At least one Kubernetes cluster (with connectivity to the host machine).
3. At least one Hashicorp Vault server (with connectivity to the host machine).
4. Read-write access to the Git repo (either ssh private key or https token).

## Steps to use the bevel-build container

1.  Clone the git repo to host machine, call this the project folder

    ```
    git clone https://github.com/hyperledger/bevel

    ```
1. Depending on your platform of choice, there can be some differences in the configuration file. Please follow platform specific links below to learn more on updating the configuration file.
    * [R3 Corda Configuration File](../operations/corda_networkyaml.md)
    * [Hyperledger Fabric Configuration File](../operations/fabric_networkyaml.md)
    * [Hyperledger Indy Configuration File](../operations/indy_networkyaml.md)
    * [Quorum Configuration File](../operations/quorum_networkyaml.md)
    * [Hyperledger Besu Configuration File](../operations/besu_networkyaml.md)

1. Create a build folder in the project folder; this build folder should have the following files:

    a) K8s config file as config  
    b) Network specific configuration file as network.yaml  
    c) If using SSH for Gitops, Private key file which has write-access to the git repo

    Screen shot of the folder structure is below:   

    ![](./../_static/DockerBuildFolder.png)

1. Ensure the configuration file (`./build/network.yaml`) has been updated with the DLT network that you want to configure.

1. Run the following command to run the provisioning scripts, the command needs to be run from the project folder. The command also binds and mounts a volume, in this case it binds the repository 

    ```bash
    docker run -it -v $(pwd):/home/bevel/ --network="host" ghcr.io/hyperledger/bevel-build:latest

    # For Corda use jdk8 version
    docker run -it -v $(pwd):/home/bevel/ --network="host" ghcr.io/hyperledger/bevel-build:jdk8-latest
    ```
1. In case you have failures and need to debug, login to the bash shell

    ```bash
    docker run -it -v $(pwd):/home/bevel/ --network="host" ghcr.io/hyperledger/bevel-build:latest bash

    # go to bevel directory
    cd bevel
    # Run the provisioning scripts
    ansible-playbook  platforms/shared/configuration/site.yaml -e "@./build/network.yaml" 

    ```
1. For instructions on how to verify or troubleshoot network, read [How to debug a Bevel deployment](../operations/bevel_verify.md)
