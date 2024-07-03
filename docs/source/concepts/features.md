[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Hyperledger Bevel Features

## Multi-Cloud service providers support
With adaptability is at its core, our scripts aren't tied to any specific Cloud service provider. They gracefully work on any Cloud platform, as long as you've got the [basics covered](../getting-started/prerequisites.md). With Hyperledger Bevel, choose the Cloud that suits you best.

## Multi-DLT/Blockchain platforms support
Bevel can manage multi-cluster environments in the rapid establishment of Distributed Ledger Technology (DLT) or Blockchain networks, whether it be Hyperledger Fabric or R3 Corda. Despite the inherent diversity in components, such as channels and orderers in Fabric, and Doorman and Notary in Corda, Hyperledger Bevel gracefully navigates this complexity.

How? Through its ingenious use of a specially crafted [network.yaml](../guides/networkyaml-fabric.md) file. This file acts as the universal key, ensuring that the setup of a DLT/Blockchain network remains consistent, regardless of the underlying platform.

## No dependency on managed K8s services
The setup of a Distributed Ledger Technology (DLT) network doesn't hinge on managed Kubernetes (K8s) services alone. Non-managed K8s clusters can seamlessly come into play, turning the vision of a DLT network setup into reality. Flexibility meets functionality with Hyperledger Bevel.

## One touch/command deployment
With just one Ansible playbook — aptly named [site.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/site.yaml), you can orchestrate the creation of an entire Distributed Ledger Technology (DLT) network. Brace yourself for efficiency gains as this streamlined process significantly slashes the time typically spent configuring and managing the network components of Corda, Besu, Fabric or other supported DLT networks. 

## Security through Vault (Optional)
In the realm of identity-based security, HashiCorp Vault takes centre stage within Hyperledger Bevel. Especially in the complex terrain of managing secrets across multiple clouds, the dynamic capabilities of HashiCorp Vault shine through. With Vault at its core, Hyperledger Bevel ensures the secure storage and precise control of access to critical elements like tokens, passwords, certificates, and encryption keys. This robust approach safeguards machines, applications, and sensitive data within a multi-cloud environment. Now **optional** for development environments.

## Sharing a Network.yaml file without disclosing any confidentiality
Unlocking a new level of efficiency, Hyperledger Bevel empowers organizations to initiate a Distributed Ledger Technology (DLT) or Blockchain network swiftly. Leveraging a configured [network.yaml](../guides/networkyaml-fabric.md) file, the setup process is not only streamlined but sets the stage for seamless collaboration.

Here's the game-changer: this [network.yaml](../guides/networkyaml-fabric.md) file can be easily shared with new organizations looking to join the DLT/Blockchain network. The brilliance lies in the ability to reuse this file without compromising the confidentiality of the initial organization's sensitive data.

## Helm Chart Support
Simplifies deployment of DLT networks with Helm charts. Specially for development environments, only `helm install` commands can be used to setup a DLT network in few minutes.

## GitOps Optionality
Provides flexibility by making GitOps deployment optional for development environments. This gives the developers a faster access to the DLT environment without the complexities of configuring GitOps.

## How is it different from other BaaS?
- Hyperledger Bevel deployment scripts can be reused across cloud providers like AWS, Azure, GCP, DigitalOcean and OpenShift
- Can deploy networks and smart contracts across different DLT/Blockchain platforms
- Supports heterogeneous deployments in a multi-cloud, multi-owner model where each node is completely owned and managed by separate organizations
- Bring Your Own Infrastructure (BYOI) - You provide GIT, Kubernetes cluster(s), and Hashicorp Vault services provisioned to meet your specific requirements and enterprise standards
- No network size limit
- Specifies only the number of organizations and the number of nodes per organization in a [network.yaml file](../guides/networkyaml-fabric.md) uniquely designed in Hyperledger Bevel for a new DLT/Blockchain network set-up and its future maintenance
- Provides [sample applications](https://github.com/hyperledger/bevel-samples) which runs on multiple DLT/Blockchain platforms that can be used as a reference pattern for how to safely abstract application logic from the underlying DLT/Blockchain platform.
