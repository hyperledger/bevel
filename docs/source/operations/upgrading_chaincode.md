<a name = "upgrading-chaincode"></a>
# Upgrading chaincode in Hyperledger Fabric

- [Pre-requisites](#pre_req)
- [Modifying configuration file](#create_config_file)
- [Running playbook to upgrade chaincode to new version in Hyperledger Fabric network](#run_network)

<a name = "pre_req"></a>
## Pre-requisites
Hyperledger Fabric network deployed, network.yaml configuration file already set and chaincode is installed and instantiated.

<a name = "create_config_file"></a>
## Modifying configuration file

Refer [this guide](./fabric_networkyaml.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organizations.services.peers.chaincode.arguments`, `network.organizations.services.peers.chaincode.version` and `network.organizations.services.peers.chaincode.name` variables which are used as arguments while upgrading the chaincode.

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
              url: "github.com/hyperledger-labs/blockchain-automation-framework.git"
              branch: develop
              path: "chaincode_src"   #The path to the chaincode 
            arguments: 'chaincode_args' #Arguments to be passed along with the chaincode parameters
            endorsements: "" #Endorsements (if any) provided along with the chaincode
```

<a name = "run_network"></a>
## Run playbook

The playbook [chaincode-upgrade.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/chaincode-upgrade.yaml) is used to upgrade chaincode to a new version in the existing fabric network.
This can be done by using the following command

```
    ansible-playbook platforms/hyperledger-fabric/configuration/chaincode-upgrade.yaml --extra-vars "@path-to-network.yaml"
```

---
**NOTE:** The Chaincode should be upgraded for all participants of the channel.