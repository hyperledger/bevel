[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "install-instantiate-chaincode-fabric"></a>
# Installing and instantiating chaincode in Bevel deployed Hyperledger Fabric Network

- [Pre-requisites](#pre_req)
- [Modifying configuration file](#create_config_file)
- [Chaincode Operations in Bevel for the deployed Hyperledger Fabric network](#run_network)

<a name = "pre_req"></a>
## Pre-requisites
Hyperledger Fabric network deployed and network.yaml configuration file already set.

<a name = "create_config_file"></a>
## Modifying configuration file

Refer [this guide](./fabric_networkyaml.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organizations.services.peers.chaincode` section, which is consumed when the chaincode-ops playbook is run

For reference, following snippet shows that section of `network.yaml`

```
---
network:
  ..
  ..
  organizations:
    - organization:
      name: manufacturer
      ..
      .. 
      services:
        peers:
        - peer:
          name: peer0          
          ..
          chaincode:
            name: "chaincode_name" #This has to be replaced with the name of the chaincode
            version: "chaincode_version" # This has to be different than the current version
            maindirectory: "chaincode_main"  #The main directory where chaincode is needed to be placed
            repository:
              username: "git_username"          # Git Service user who has rights to check-in in all branches
              password: "git_password"
              url: "github.com/hyperledger/bevel.git"
              branch: develop
              path: "chaincode_src"   #The path to the chaincode 
            arguments: 'chaincode_args' #Arguments to be passed along with the chaincode parameters
            endorsements: "" #Endorsements (if any) provided along with the chaincode
```

<a name = "run_network"></a>
## Chaincode Operations in Bevel for the deployed Hyperledger Fabric network

The playbook [chaincode-ops.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/chaincode-ops.yaml) is used to install and instantiate chaincode for the existing fabric network.
For Fabric v2.2 multiple operations such as approve, commit and invoke the chaincode are available in the same playbook. 
This can be done by using the following command

```
    ansible-playbook platforms/hyperledger-fabric/configuration/chaincode-ops.yaml --extra-vars "@path-to-network.yaml"
```

---
**NOTE:** The same process is executed for installing and instantiating multiple chaincodes