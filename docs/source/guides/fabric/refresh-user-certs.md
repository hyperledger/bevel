[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "refresh-certificates-to-existing-network-in-fabric"></a>
# Refresh certificates in Hyperledger Fabric

- [Prerequisites](#prerequisites)
- [Run playbook](#run-playbook)


<a name = "prerequisites"></a>
## Prerequisites
To refresh certificates a fully configured Fabric network must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels). The corresponding crypto materials should also be present in their respective Hashicorp Vault. 

---
**NOTE**:The process of refreshing certificates has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team. The process must be carried out before the expiration of the certificates

---

<a name = "run_network"></a>
## Run playbook

The same configuration files can be used to refresh the certificates. This can be done using the following command

```
ansible-playbook platforms/hyperledger-fabric/configuration/refresh-certificates.yaml --extra-vars "@path-to-network.yaml"
```
