[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Frequently Asked Questions

## Getting Started

### Who are the target users?
The target users are DLT Network Operators and DLT smartcontract developers. 

A network operator is someone who would use Bevel to deploy and manage different operations like adding new nodes, updating certificates, adding new organizations, upgrading to newer versions, monitoring etc.

A Smartcontract Developer is someone who would use Bevel to quickly start a production-worthy DLT network so that they can focus on the smartcontract development and automate the smartcontract deployment process.

### What is Hyperledger Bevel and how could it help me?
Hyperledger Bevel is an accelerator to help organizations set up a production-scale DLT network with a single configuration file like for [Fabric](guides/networkyaml-fabric.md) or [Corda](guides/networkyaml-corda.md) or [Besu](guides/networkyaml-besu.md). It can deploy the supported DLT network on any Kubernetes Cluster(s) including managed and non-managed Kubernetes Clusters.

### How much would Hyperledger Bevel cost? 
Hyperledger Bevel is an open-source product, and as such, there is no cost associated with using the framework. It is freely accessible, allowing users to leverage its capabilities without any licensing fees.

### How much would it cost to run Hyperledger Bevel on a cloud platform?
While Hyperledger Bevel itself is free, running it on a cloud platform may incur costs associated with the usage of cloud services. The specific costs will depend on the cloud platform you choose and the services you utilize within that platform. Cloud providers often charge for resources such as computing power, storage, and network usage. Users are encouraged to review the pricing details of their chosen cloud platform to understand the potential costs involved.

It's important to note that the expenses incurred by running Hyperledger Bevel on a cloud platform are related to the cloud services themselves and not directly tied to the Hyperledger Bevel framework, which remains open source and cost-free.

### Who can support me during this process and answer my questions?

* Early Stages:
During the initial stages, questions can be raised directly on [Hyperledger’s Discord server](https://discord.gg/hyperledger) at #bevel channel. The dedicated maintainers of Hyperledger Bevel are committed to providing the best support and guidance to users as they navigate through the framework.

* Community Growth:
As the open community around Hyperledger Bevel continues to mature, users can anticipate receiving support from a broader network of community members. Engaging with the community allows for shared insights, experiences, and collaborative problem-solving.

### Is there any training provided? If so, what kind of training will be included?
Current tutorials are [here](tutorials/index.md). Additionally, multiple meetups and workshop recordings are available on [this YouTube playlist](https://www.youtube.com/playlist?list=PLxjlD8kRvTIiThGQvRvEQP364-xp5AijF).  

### Can I add/remove one or more organizations as DLT nodes in a running DLT/Blockchain network by using Hyperledger Bevel?
Yes, you can add additional nodes to a running DLT/Blockchain network using Hyperledger Bevel. Removing nodes in a running DLT/Blockchain network is only supported for Hyperledger Fabric. Check the guides [here](guides/fabric/remove-org.md).

### Does Hyperledger Bevel support multiple versions of Fabric and Corda? What are the minimum versions for Fabric and Corda supported in Hyperledger Bevel?
Hyperledger Bevel is updated constantly to support the stable versions. Please check the [latest releases](https://github.com/hyperledger/bevel/releases) for version upgrades and deprecation.

## Operation Guides

### What is the minimal infrastructure set-up required to run Hyperledger Bevel?
To deploy a DLT network using Hyperledger Bevel, you need to have a managed/non-managed Kubernetes clusters ready as well as an unsealed Hashicorp Vault service available. More details on pre-requisites are [here](getting-started/prerequisites.md).

### What would be the recommended/required cloud service?
We recommend to use Cloud Services such as Amazon Web Services (AWS), Microsoft Azure, Google Cloud Platform (GCP) and DigitalOcean (DO) as their managed Kubernetes cluster services have been tested.

### Do I have to use AWS? 
No, AWS is not mandatory. Hyperledger Bevel is independent of any cloud platforms as long as a Kubernetes Cluster service is provisioned. Although, some minor code changes may need to be done to support any Kubernetes environment that has not been tested.

### Are there any pre-requisites to run Hyperledger Bevel?
Yes, you can find them on [this page](getting-started/prerequisites.md).

### How to configure HashiCorp Vault and Kubernetes?
Please see [this page](./getting-started/configure-prerequisites.md) for details.

### I'm using Windows machine, can I run Hyperledger Bevel on it?
Hyperledger Bevel relies a lot on using [Ansible](./concepts/ansible.md), which might not work in Windows machines. Please check Ansible website for more information.

### How do I configure a DLT/Blockchain network?
Please follow our [Getting Started guide](./getting-started/run-bevel.md).

### How can I test whether my DLT/Blockchain network are configured and deployed correctly?
Please check the [troubleshooting guide](./references/troubleshooting.md) for details.

### How/Where can I request for new features, bugs and get feedback?
Please follow our [contributing guidelines](./contributing/how-to-contribute.md) for this.

### Are CI/CD pipeline tools a mandatory to use Hyperledger Bevel?
No, CI/CD pipeline tools like Jenkins are not mandatory, but it could help a user automate the set-up or testing of a new DLT/Blockchain network in different environments, once a user has a good understanding of using it.

### Is it required to run Ansible in a particular machine like AWS EC2?
No, a user should be able to run the Ansible command on any machine as long as Ansible command CLI is installed.

### Is there an example ansible_hosts file?
Yes, you can find an example ansible_hosts file [here](https://github.com/hyperledger/bevel/tree/main/platforms/shared/inventory/ansible_provisioners). The configuration in this file means that all Ansible commands will be run in the same machine that works as both an Ansible client and server machine.

### Can I specify the tools versions such as kubectl, helm in this project?
Yes, you can specify tools versions like kubectl, helm, HashiCorp Vault, AWS-Authenticator in the playbook [setup-environment.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/setup-environment.yaml).

### How would system react if we plan to update tools versions (e.g. kubectl, helm)?
The latest version Hyperledger Bevel has been tested on specific client versions of the tools. see [versions supported](./references/tool-versions.md) for latest.

It is assumed that newer versions of these tools would be backward compatible. You can raise a new ticket to Hyperledger Bevel GitHub repository, if any major updates would break the system.
