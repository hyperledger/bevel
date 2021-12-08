[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# **Hyperledger Bevel's Features**

## **Multi-Cloud service providers support**
Hyperledger Bevel's scripts do not stick to any one of the Cloud service provider. On the contrary, they can be used on any Cloud platform as long as all the [prerequisites](../gettingstarted.md) are met.

## **Multi-DLT/Blockchain platforms support**
Hyperledger Bevel supports an environment of multi-clusters for the spin-up of a DLT/Blockchain network (e.g. Hyperledger Fabric or R3 Corda). Regardless of unique components (e.g. channels and orderers in Fabric, and Doorman, Notary in Corda) designed in each platform which make the DLT/Blockchain ecosystems become heterogeneous, Hyperledger Bevel does remove this complexity and challenge by leveraing a uniquely-designed [network.yaml](../operations/fabric_networkyaml.md) file, which enables the set-up of a DLT/Blockchain network on either platform to be consistent.

## **No dependency on managed K8s services**
Setting up a DLT network does not depend on a managed K8s services, which means non-managed K8s clusters can be used to make a DLT network set-up happen.

## **One touch/command deployment**
A single Ansible playbook called [**site.yaml**](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration) can spin up an entire DLT network and a substantial amount of time can be reduced which is involved in configuring and managing the network components of a Corda or Fabric DLT network.

## **Security through Vault**
HashiCorp Vault is used to provide identity-based security. When it comes to managing secrets with machines in a multi-cloud environment, the dynamic nature of HashiCorp Vault becomes very useful. Vault enables Hyperledger Bevel to securely store and tightly control access to tokens, passwords, certificates, and encryption keys for protecting machines, applications, and sensitive data.

## **Sharing a Network.yaml file without disclosing any confidentiality**
Hyperledger Bevel allows an organization to use a configured network.yaml file to set up an initial DLT/Blockchain network and a first node in the network, and allows this file to be shared by new organizations that will have to join this DLT/Blockchain network to reuse this network.yaml file, but without revealing any confidential data of the first organization.
