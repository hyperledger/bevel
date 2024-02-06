[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "install-instantiate-chaincode-fabric"></a>
# Installing and instantiating chaincode in Bevel deployed Hyperledger Fabric Network

- [Pre-requisites](#pre-requisites)
- [Modifying configuration file](#modifying-configuration-file)
- [Chaincode Operations in Bevel for the deployed Hyperledger Fabric network](#chaincode-operations-in-bevel-for-the-deployed-hyperledger-fabric-network)

<a name = "pre_req"></a>
## Pre-requisites
Hyperledger Fabric network deployed and network.yaml configuration file already set.

<a name = "create_config_file"></a>
## Modifying configuration file

Refer [this guide](../networkyaml-fabric.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organizations.services.peers.chaincodes` section, which is consumed when the chaincode-ops playbook is run

For reference, following snippet shows that section of `network.yaml`

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:241:248"
      ..
      ..
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:297:297"
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:304:338"
```

<a name = "run_network"></a>
## Chaincode Operations in Bevel for the deployed Hyperledger Fabric network

The playbook [chaincode-ops.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/chaincode-ops.yaml) is used to install and instantiate chaincode for the existing fabric network.
For Fabric v2.2 and 2.5 multiple operations such as approve, commit and invoke the chaincode are available in the same playbook. 
This can be done by using the following command

```
ansible-playbook platforms/hyperledger-fabric/configuration/chaincode-ops.yaml --extra-vars "@path-to-network.yaml"
```

---
**NOTE:** The same process is executed for installing and instantiating multiple chaincodes