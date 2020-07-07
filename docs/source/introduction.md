# Introduction

At its core, Blockchain is a new type of data system that maintains and records data in a way that
allows multiple stakeholders to confidently share access to the same data and information. A
blockchain is a type of Distributed Ledger Technology (DLT), meaning it is a data ledger that is
shared by multiple entities operating on a distributed network.

This technology operates by
recording and storing every transaction across the network in a cryptographically linked block
structure that is replicated across network participants. Every time a new data block is created, it
is appended to the end of the existing chain formed by all previous transactions, thus creating a
chain of blocks called the blockchain. This blockchain format contains records of all transactions
and data starting from the inception of that data structure.

Setting up a new DLT/Blockchain network or maintaining an existing DLT/Blockchain network in a production-scale environment is not straightforward. For the existing DLT/Blockchain platforms, each has its own architecture, which means the same way of setting up one DLT/Blockchain network cannot be applied to others. 

Therefore, when blockchain developers are asked to use an unfamiliar DLT/Blockchain platform, it requires a great deal of effort for even experienced technicians to properly setup the DLT/Blockchain network. This is especially true in large-scale production projects across heterogeneous corporate environments which require other key aspects such as security and service availability.

Being aware of the potential difficulty and complexity of getting a production-scale DLT/Blockchain network ready, cloud vendors such as AWS and Azure have provisioned their own managed Blockchain services (aka Blockchain as a Service or BaaS) to help alleviate various pain-points during the process. However, limitations can still be identified in their BaaS solutions, e.g. limited network size, locked to all nodes on a single cloud provider, or limited choice of DLT/Blockchain platform, etc.

## **The Blockchain Automation Framework (BAF) Platform**
The objective of BAF is to provide a consistent means by which developers can deploy production-ready distributed networks across public and private cloud providers. This enables developers to focus on building business applications quickly, knowing the framework upon which they are building can be adopted by an enterprise IT production operations organization. BAF is not intended solely to quickly provision development environments which can be done more efficiently with other projects/scripts. Likewise, Blockchain Automation Framework is not intended to replace BaaS offerings in the market, but instead, BAF is an alternative when existing BaaS offerings do not support a consortium's current set of requirements. 

![](../images/blockchain-automation-framework-overview.png)

## **How is it different from other BaaS?**
- The Blockchain Automation Framework deployment scripts can be reused across cloud providers like AWS, Azure, GCP, and OpenShift
- Can deploy networks and smart contracts across different DLT/Blockchain platforms
- Supports heterogeneous deployments in a multi-cloud, multi-owner model where each node is completely owned and managed by separate organizations
- Bring Your Own Infrastructure (BYOI) - You provide GIT, Kubernetes cluster(s), and Hashicorp Vault services provisioned to meet your specific requirements and enterprise standards
- No network size limit
- Specify only the number of organizations and the number of nodes per organization in a [network.yaml file](./operations/fabric_networkyaml.md) uniquely designed in the Blockchain Automation Framework for a new DLT/Blockchain network set-up and its future maintenance
- Provides a sample supply chain application which runs on multiple DLT/Blockchain platforms that can be used as a reference pattern for how to safely abstract application logic from the underlying DLT/Blockchain platform

### What next?
 We have been actively searching for partners who need  and understand the value of Blockchain Automation Framework, who share the vision of building and owning well architect-ed solutions . We wish to work together so as to identify the market needs for those partners, to further reduce the barriers in adoption.