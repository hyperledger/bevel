[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# HashiCorp Vault

[HashiCorp Vault](https://www.vaultproject.io/) is an open-source tool designed to manage secrets and protect sensitive data in modern computing environments. It provides a secure and centralized way to store, access, and distribute secrets such as passwords, API keys, encryption keys, and other confidential information. Vault is especially useful in cloud-native and distributed systems where securing secrets is crucial.

!!! tip

    With 1.1 Release, Hahsicorp Vault is optional for development environments, and Cloud KMS integration is on the roadmap.

Hyperledger Bevel relies on Hashicorp Vault for managing all secrets like public and private certificates, passwords to repos or databases etc. which are used in a DLT/Blockchain network during the lifecycle of a deployment, and it is a prerequisite that the Vault is installed and unsealed prior to deployment of a DLT/Blockchain network.

## Core Features

1. Secrets Management: Vault provides a secure and encrypted storage backend to store and manage secrets. These secrets can be versioned, rotated, and revoked, offering enhanced security.

1. Dynamic Secrets: Vault can generate dynamic secrets for various services like databases, cloud providers, and SSH, reducing the need to store long-lived credentials.

1. Encryption as a Service (EaaS): Vault can act as a centralized service to encrypt and decrypt data, ensuring data privacy without requiring applications to handle encryption themselves.

1. Identity and Access Management: Vault supports various authentication methods, including tokens, LDAP, Kubernetes, and more. It also offers fine-grained access control through policies.

1. Auditing and Logging: Vault maintains detailed logs of all operations, providing an audit trail for security and compliance purposes.

## Use Cases

1. Secrets Management: Vault helps securely manage and distribute secrets across applications, infrastructure, and services.

1. Encryption: It can be used to encrypt sensitive data in applications, databases, and storage systems.

1. Database Credentials Management: Vault can dynamically generate short-lived database credentials, reducing the risk of exposure.

1. Cloud Access: Vault can generate and manage temporary access credentials for cloud providers.

1. Certificate Management: Vault can handle the lifecycle of X.509 certificates, including generation, renewal, and revocation.

## Installation

There are two approaches to installing Vault:

 - Using a [precompiled binary](https://developer.hashicorp.com/vault/docs/install#precompiled-binaries)

 - Installing from [source](https://developer.hashicorp.com/vault/docs/install#compiling-from-source)

Downloading a precompiled binary is easiest and provides downloads over TLS along with SHA256 sums to verify the binary. Hashicorp also distributes a PGP signature with the SHA256 sums that should be verified.

## Securing RPC Communication with TLS Encryption
Securing your cluster with TLS encryption is an important step for production deployments. The recomended tool for vault certificate management is Consul. Hashicorp Consul is a networking tool that provides a fully featured service-mesh control plane, service discovery, configuration, and segmentation. 

Consul supports using TLS to verify the authenticity of servers and clients. To enable TLS, Consul requires that all servers have certificates that are signed by a single Certificate Authority (CA). Clients should also have certificates that are authenticated with the same CA.

After generating the necessary client and server certificates, the values.yaml file `tls` field can be populated with the `ca.cert` certificates. Populating this field will enable or disable TLS for vault communication if a value present.  

The latest documentation on generating tls material with consul can be found at: https://developer.hashicorp.com/consul/tutorials/security/tls-encryption-secure
