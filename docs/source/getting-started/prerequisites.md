[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Install Common Pre-requisites

Following are the common prerequisite software/client/platforms etc. needed before you can start deploying/operating blockchain networks using Hyperledger Bevel.

## Helm

[Helm](../concepts/helm.md) is a crucial tool for managing Kubernetes applications, simplifying the deployment and management of Kubernetes manifests. For Hyperledger Bevel, Helm charts are used to streamline the deployment of DLT networks, ensuring consistency and efficiency.

To install Helm, follow the official [Helm installation guide](https://helm.sh/docs/intro/install/). Ensure the version is compatible with your Kubernetes setup.

!!! tip

    Install Helm Version > **v3.6.2**

## Kubernetes

Hyperledger Bevel deploys the DLT/Blockchain network on [Kubernetes](https://kubernetes.io/) clusters; hence, at least one Kubernetes cluster should be available.

Bevel recommends one Kubernetes cluster per organization for production-ready projects. Also, a user needs to make sure that the Kubernetes clusters can support the number of pods and persistent volumes that will be created by Bevel.

!!! tip

    For the current release Bevel has been tested on Amazon EKS with Kubernetes version **1.28**.

    Bevel has been tested on Kubernetes >= 1.19 and <= 1.28

    !!! warning Icon Filename
        Also, install kubectl Client version as per Kubernetes version **v1.28.0**

Please follow respective Cloud provider instructions, like [for Amazon](https://aws.amazon.com/eks/getting-started/) to set-up your required Kubernetes cluster(s).
To connect to Kubernetes cluster(s), you will also need kubectl Command Line Interface (CLI). Refer [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/) for installation instructions, although Hyperledger Bevel configuration code (Ansible scripts) installs this automatically.

## Git Repository

Release 1.1 onwards, [GitOps](../concepts/gitops.md) is a optional concept for Hyperledger Bevel. Although, for Production-ready deployment with Ansible automation, GitOps is needed for Bevel.

Fork or import the [Bevel GitHub repo](https://github.com/hyperledger/bevel) to your own Git repository. The Operator should have a user created on this repo with read-write access to the Git Repository.

!!! tip

    Install Git Client Version > **2.31.0**

## HashiCorp Vault

Release 1.1 onwards, [Hashicorp Vault](https://www.vaultproject.io/) is optional for Hyperledger Bevel as the certificate and key storage solution. But, for Production-ready deployment with Ansible automation, at least one Vault server should be available. Bevel recommends one Vault per organization for production-ready projects. 

Follow [official instructions](https://developer.hashicorp.com/vault/docs/install) to deploy Vault in your environment. 

!!! tip

    The recommended approach is to create one Vault deployment on one VM and configure the backend as cloud storage.

    !!! warning 

        Vault version should be  <= **1.15.2**


## Internet Domain

Hyperledger Bevel uses [Ambassador Edge Stack](https://www.getambassador.io/products/edge-stack/api-gateway) or [HAProxy Ingress Controller](https://haproxy-ingress.github.io/) for inter-cluster communication. So, for the Kubernetes services to be available outside the specific cluster, at least one DNS Domain is required. This domain name can then be sub-divided across multiple clusters and the domain-resolution configured for each.
Although for production implementations, each organization (and thereby each cluster), must have one domain name.

!!! note

    If single cluster is being used for all organizations in a dev/POC environment, then domain name is not needed.


## Docker

Hyperledger Bevel provides pre-built docker images which are available on [GitHub Repo](https://github.com/orgs/hyperledger/packages?repo_name=bevel). If specific changes are needed in the Docker images, then you can build them locally using the Docker files provided. A user needs to install [Docker CLI](https://docs.docker.com/install/) to make sure the environment has the capability of building these Docker files to generate various docker images. Platform specific docker image details are mentioned [here](../getting-started/configure-prerequisites.md).

!!! tip

    Hyperledger Bevel uses minimum Docker version **18.03.0**


You can check the version of Docker you have installed with the following
command from a terminal prompt:

```bash
docker --version
```

For storing private docker images, a private docker registry can be used. Information such as registry url, username, password, etc. can be configured in the configuration file like [Fabric configuration file](../guides/networkyaml-fabric.md).
