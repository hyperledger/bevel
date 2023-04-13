[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Install Common Pre-requisites

Following are the common pre-requiste software/client/platforms etc. needed before you can start deploying/operating blockchain networks using Hyperledger Bevel.

## Git Repository
GitOps is a [key concept](keyconcepts) for Hyperledger Bevel, so a Git repository is needed for Bevel (this can be a [GitHub](https://github.com/) repository as well).
Fork or import the [Bevel GitHub repo](https://github.com/hyperledger/bevel) to this Git repository.

The Operator should have a user created on this repo with read-write access to the Git Repository.

---
**NOTE:** Install Git Client Version > **2.31.0**

---

## Kubernetes
Hyperledger Bevel deploys the DLT/Blockchain network on [Kubernetes](https://kubernetes.io/) clusters; hence, at least one Kubernetes cluster should be available.
Bevel recommends one Kubernetes cluster per organization for production-ready projects. 
Also, a user needs to make sure that the Kubernetes clusters can support the number of pods and persistent volumes that will be created by Bevel.

---
**NOTE:** For the current release Bevel has been tested on Amazon EKS with Kubernetes version **1.19**.

Bevel has been tested on Kubernetes >= 1.19 and <= 1.22

Also, install kubectl Client version **v1.19.8**

---

Please follow [Amazon instructions](https://aws.amazon.com/eks/getting-started/) to set-up your required Kubernetes cluster(s).
To connect to Kubernetes cluster(s), you will also need kubectl Command Line Interface (CLI). Refer [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/) for installation instructions, although Hyperledger Bevel configuration code (Ansible scripts) installs this automatically.

## HashiCorp Vault
In this current release, [Hashicorp Vault](https://www.vaultproject.io/) is mandatory for Hyperledger Bevel as the certificate and key storage solution; hence, at least one Vault server should be available. Bevel recommends one Vault per organization for production-ready projects. 

Follow [official instructions](https://www.vaultproject.io/docs/install/) to deploy Vault in your environment. 

---
**NOTE:** Recommended approach is to create one Vault deployment on one VM and configure the backend as a cloud storage.

Vault version should be **1.7.1**

---

## Internet Domain
Hyperledger Bevel uses [Ambassador](https://www.getambassador.io/about/why-ambassador/) or [HAProxy Ingress Controller](https://www.haproxy.com/documentation/hapee/1-9r1/traffic-management/kubernetes-ingress-controller/) for inter-cluster communication. So, for the Kubernetes services to be available outside the specific cluster, at least one DNS Domain is required. This domain name can then be sub-divided across multiple clusters and the domain-resolution configured for each.
Although for production implementations, each organization (and thereby each cluster), must have one domain name.

---
**NOTE:** If single cluster is being used for all organizations in a dev/POC environment, then domain name is not needed.

---

## Docker

Hyperledger Bevel provides pre-built docker images which are available on [GitHub Repo](https://github.com/orgs/hyperledger/packages?repo_name=bevel). If specific changes are needed in the Docker images, then you can build them locally using the Dockerfiles provided. A user needs to install [Docker CLI](https://docs.docker.com/install/) to make sure the environment has the capability of building these Dockerfiles to generate various docker images. Platform specific docker image details are mentioned [here](./operations/configure_prerequisites.md).

---
**NOTE:** Hyperledger Bevel uses minimum Docker version **18.03.0**

---

You can check the version of Docker you have installed with the following
command from a terminal prompt:
```
    docker --version
```

For storing private docker images, a private docker registry can be used. Information such as registry url, username, password, etc. can be configured in the configuration file like [Fabric configuration file](./operations/fabric_networkyaml.md).
