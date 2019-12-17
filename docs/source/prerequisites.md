Prerequisites
=============

Before we begin, if you haven't already done so, you may wish to check that
you have all the prerequisites below installed on the platform(s)
on which you'll be deploying blockchain networks from and/or operating
the Blockchain Automation Framework.

## Kubernetes
The Blockchain Automation Framework (BAF) deploys the DLT network on [Kubernetes](https://kubernetes.io/) clusters; so to use BAF, at least one Kubernetes cluster should be available.
BAF recommends one Kubernetes cluster per organization for production-ready projects. 
Also, a user needs to make sure that the Kubernetes clusters can support the number of pods and persistent volumes that will be created by BAF.

---
**NOTE:** For the current release, BAF has been tested on Amazon EKS with Kubernetes version 1.12. 

---

Please follow [Amazon instructions](https://aws.amazon.com/eks/getting-started/) to set-up your required Kubernetes cluster(s).
To connect to Kubernetes cluster(s), you would also need kubectl Command Line Interface (CLI). Please refer [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/) for installation instructions, although the Blockchain Automation Framework configuration code (Ansible scripts) installs this automatically.

## HashiCorp Vault
In this current release, [Hashicorp Vault](https://www.vaultproject.io/) is mandatory for the Blockchain Automation Framework (BAF) as the certificate and key storage solution; so to use BAF, at least one Vault server should be available. BAF recommends one Vault per organization for production-ready projects. 

Follow [official instructions](https://www.vaultproject.io/docs/install/) to deploy Vault in your environment. 

---
**NOTE:** Recommended approach is to create one Vault deployment on one VM and configure the backend as a cloud storage.

---

## Ansible

The Blockchain Automation Framework configuration is essentially Ansible scripts, so install Ansible on the machine from which you will deploy the DLT network. This can be a local machine as long as Ansible commands can run on it.

Please note that this machine (also called **Ansible Controller**) should have connectivity to the Kubernetes cluster(s) and the Hashicorp Vault service(s).

---
**NOTE:** The Blockchain Automation Framework requires minimum **Ansible version 2.8.1**

---

Follow [official instructions](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) to install Ansible in a new environment.

## Docker

The Blockchain Automation Framework does not provision any pre-built docker images, instead, various Dockerfiles are provisioned, so a user is free to change them for whatever new demands they have. This means a user needs to install [Docker CLI](https://docs.docker.com/install/) to make sure the environment has the capbility of building these Dockerfiles to generate various docker images.

---
**NOTE:** The Blockchain Automation Framework uses minimum Docker version 18.03.0

---

You can check the version of Docker you have installed with the following
command from a terminal prompt:
```
    docker --version
```

Also, the user needs to provision their own docker registry, username and password for storing these docker images. Information such as registry url etc. need to be configured in a [network.yaml file](./operations/fabric_networkyaml.md).

## Git Repository
As you may have read in the [key concepts](keyconcepts), the Blockchain Automation Framework (BAF) uses GitOps method for deployment to Kubernetes clusters. So, a Git repository is needed for BAF (this can be a [GitHub](https://github.com/) repository as well).

The Operator should have full access to the Git Repository. 
And it is essential to install the [git client](https://git-scm.com/download) on the Ansible Controller.

## Internet Domain
As you may have read in the [Kubernetes key concepts](keyConcepts/kubernetes), the Blockchain Automation Framework uses [Ambassador](https://www.getambassador.io/about/why-ambassador/) for inter-cluster communication. So, for the Kubernetes services to be available outside the specific cluster, at least one DNS Domain is required. This domain name can then be sub-divided across multiple clusters and the domain-resolution configured for each.
Although for production implementations, each organization (and thereby each cluster), must have one domain name.

---
**NOTE:** If single cluster is being used for all organizations in a dev/POC environment, then domain name is not needed.

---

## Platform Specific
Also install any required platform specific pre-requisites (some may be common).
* [R3 Corda 4.0](https://docs.corda.net/releases/release-V4.0/)

* [Hyperlegder Fabric 1.4.0](https://hyperledger-fabric.readthedocs.io/en/release-1.4/)

## Jenkins

Jenkins is *optional* for the Blockchain Automation Framework (BAF), though there are some sample automation pipelines available in the source code which makes configuring BAF for dev and test environments easier.

Install Jenkins as per [Cloudbees documentation](https://www.cloudbees.com/jenkins/about).