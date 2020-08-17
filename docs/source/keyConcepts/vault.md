# **HashiCorp Vault**

[HashiCorp Vault](https://www.vaultproject.io/) provisions a secure approach to store and gain secret information such as tokens, passwords and certificates.

The Blockchain Automation Framework relies on Vaults for managing certificates used in each node of a DLT/Blockchain network during the lifecycle of a deployment, and it is a prerequisite that the Vault is installed and unsealed prior to deployment of a DLT/Blockchain network.

## Installation

There are two approaches to installing Vault:

 - Using a [precompiled binary](https://www.vaultproject.io/docs/install/#precompiled-binaries)

 - Installing from [source](https://www.vaultproject.io/docs/install/#compiling-from-source)

Downloading a precompiled binary is easiest and provides downloads over TLS along with SHA256 sums to verify the binary. Hashicorp also distributes a PGP signature with the SHA256 sums that should be verified.

## Securing RPC Communication with TLS Encryption
Securing your cluster with TLS encryption is an important step for production deployments. The recomended tool for vault certificate management is Consul. Hashicorp Consul is a networking tool that provides a fully featured service-mesh control plane, service discovery, configuration, and segmentation. 

Consul supports using TLS to verify the authenticity of servers and clients. To enable TLS, Consul requires that all servers have certificates that are signed by a single Certificate Authority (CA). Clients should also have certificates that are authenticated with the same CA.

After generating the necessary client and server certificates, the values.yaml file `tls` field can be populated with the `ca.cert` certificates. Populating this field will enable or disable TLS for vault communication if a value present.  

The latest documentation on generating tls material with consul can be found at: 
https://learn.hashicorp.com/consul/security-networking/certificates
