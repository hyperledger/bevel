[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "adding-new-validator-node-to-existing-org-in-besu"></a>
# Adding a new validator node in Besu

  - [Prerequisites](#prerequisites)
  - [Create Configuration File](#create-configuration-file)
  - [Run playbook](#run-playbook)

<a name = "prerequisites"></a>
## Prerequisites
To add a new node in Besu, an existing besu network should be running, enode information of all existing nodes present in the network should be available, genesis file should be available in base64 encoding and the information of transaction manager nodes and existing validator nodes should be available. The new node account should be unlocked prior adding the new node to the existing besu network. 

---
**NOTE**: Addition of a new validator node has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

---

<a name = "create_config_file"></a>
## Create Configuration File

Refer [this guide](./besu_networkyaml.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organization` details along with the tessera transaction manager node details and existing validator and member node details.

---
**NOTE**: Make sure that the genesis flie is provided in base64 encoding. Also, if you are adding node to the same cluster as of another node, make sure that you add the ambassador ports of the existing node present in the cluster to the network.yaml

---
For reference, sample `network.yaml` file looks like below for IBFT consensus (but always check the latest network-besu-new-validatornode.yaml at `platforms/hyperledger-besu/configuration/samples`):

```
---
# This is a sample configuration file to add a new validator node to existing network.
# This DOES NOT support proxy=none
# All text values are case-sensitive
network:
# Network level configuration specifies the attributes required for each organization to join an existing network.
  type: besu
  version: 21.10.6  #this is the version of Besu docker image that will be deployed.

#Environment section for Kubernetes setup
  env:
    type: "dev"                     # tag for the environment. Important to run multiple flux on single cluster
    proxy: ambassador               # value has to be 'ambassador' as 'haproxy' has not been implemented for besu
    ## Any additional Ambassador ports can be given below, this is valid only if proxy='ambassador'
    #  These ports are enabled per cluster, so if you have multiple clusters you do not need so many ports
    # This sample uses a single cluster, so we have to open 4 ports for each Node. 
    # These ports are again specified for each organization below
    ambassadorPorts:
      portRange:                    # For a range of ports 
        from: 15010 
        to: 15043
    # ports: 15020,15021            # For specific ports 
    retry_count: 20                 # Retry count for the checks on Kubernetes cluster
    external_dns: enabled           # Should be enabled if using external-dns for automatic route configuration
  
  # Docker registry details where images are stored. This will be used to create k8s secrets
  # Please ensure all required images are built and stored in this registry. 
  # Do not check-in docker_password.
  docker:
    url: "ghcr.io/hyperledger"
    username: "docker_username"
    password: "docker_password"
  
  # Following are the configurations for the common Besu network
  config:    
    consensus: "ibft"                     # Options are "ibft", "ethash" and "clique".
    ## Certificate subject for the root CA of the network. 
    # This is for development usage only where we create self-signed certificates 
    # and the truststores are generated automatically.
    # Production systems should generate proper certificates and configure truststores accordingly.
    subject: "CN=DLT Root CA,OU=DLT,O=DLT,L=London,C=GB"
    transaction_manager: "tessera"    # Transaction manager is "tessera"
    # This is the version of "tessera" docker image that will be deployed
    tm_version: "21.7.3"               
    # TLS can be True or False for the tessera tm
    tm_tls: True
    # Tls trust value
    tm_trust: "ca-or-tofu"                # Options are: "ca-or-tofu", "ca", "tofu"
    ## File location where the base64 encoded genesis file is located.
    genesis: "/home/user/bevel/build/besu_genesis"   
    ## Transaction Manager nodes public addresses should be provided.
    #  - "https://node.test.besu.blockchain-develop.com"
    # The above domain name is formed by the (http or https)://(peer.name).(org.external_url_suffix):(ambassador tm node port)
    tm_nodes: 
      - "https://carrier.test.besu.blockchaincloudpoc-develop.com"
      - "https://manufacturer.test.besu.blockchaincloudpoc-develop.com"
      - "https://store.test.besu.blockchaincloudpoc-develop.com"
      - "https://warehouse.test.besu.blockchaincloudpoc-develop.com"
    # Besu rpc public address list for existing validator and member nodes 
    #  - "http://noderpc.test.besu.blockchaincloudpoc-develop.com"
    # The above domain name is formed by the (http)://(peer.name)rpc.(org.external_url_suffix):(ambassador node rpc port)
    besu_nodes:
      - "http://validator1rpc.test.besu.blockchaincloudpoc-develop.com"
      - "http://validator2rpc.test.besu.blockchaincloudpoc-develop.com"
      - "http://validator3rpc.test.besu.blockchaincloudpoc-develop.com"
      - "http://validator4rpc.test.besu.blockchaincloudpoc-develop.com"
      - "https://carrierrpc.test.besu.blockchaincloudpoc-develop.com"
      - "https://manufacturerrpc.test.besu.blockchaincloudpoc-develop.com"
      - "https://storerpc.test.besu.blockchaincloudpoc-develop.com"
      - "https://warehouserpc.test.besu.blockchaincloudpoc-develop.com"

  # Allows specification of one or many organizations that will be connecting to a network.
  organizations:
  # Specification for the 1st organization. Each organization should map to a VPC and a separate k8s cluster for production deployments
    - organization:
      name: supplychain
      type: validator
      # Provide the url suffix that will be added in DNS recordset. Must be different for different clusters
      # This is not used for Besu as Besu does not support DNS hostnames currently. Here for future use
      external_url_suffix: test.besu.blockchaincloudpoc-develop.com
      cloud_provider: aws   # Options: aws, azure, gcp
      aws:
        access_key: "aws_access_key"        # AWS Access key, only used when cloud_provider=aws
        secret_key: "aws_secret_key"        # AWS Secret key, only used when cloud_provider=aws
        region: "aws_region"                # AWS Region where cluster and EIPs are created
      # Kubernetes cluster deployment variables. The config file path and name has to be provided in case
      # the cluster has already been created.
      k8s:
        context: "cluster_context"
        config_file: "cluster_config"
      # Hashicorp Vault server address and root-token. Vault should be unsealed.
      # Do not check-in root_token
      vault:
        url: "vault_addr"
        root_token: "vault_root_token"
        secret_path: "secretsv2"
      # Git Repo details which will be used by GitOps/Flux.
      # Do not check-in git_access_token
      gitops:
        git_protocol: "https" # Option for git over https or ssh
        git_url: "https://github.com/<username>/bevel.git"  # Gitops https or ssh url for flux value files 
        branch: "develop"                                                             # Git branch where release is being made
        release_dir: "platforms/hyperledger-besu/releases/dev"                        # Relative Path in the Git repo for flux sync per environment. 
        chart_source: "platforms/hyperledger-besu/charts"                             # Relative Path where the Helm charts are stored in Git repo
        git_repo: "github.com/<username>/bevel.git"         # Gitops git repository URL for git push 
        username: "git_username"                              # Git Service user who has rights to check-in in all branches
        password: "git_access_token"                          # Git Server user access token (Optional for ssh; Required for https)
        email: "git_email"                                    # Email to use in git config
        private_key: "path_to_private_key"                    # Path to private key file which has write-access to the git repo (Optional for https; Required for ssh)
      # As this is a validator org, it is hosting a few validators as services
      services:
        validators:
        - validator:
          name: validator1
          status: existing        # needed to know which  validator node exists
          bootnode: true          # true if the validator node is used also a bootnode for the network
          p2p:
            port: 30303
            ambassador: 15020     #Port exposed on ambassador service (use one port per org if using single cluster)
          rpc:
            port: 8545
            ambassador: 15021     #Port exposed on ambassador service (use one port per org if using single cluster)
          ws:
            port: 8546
        - validator:
          name: validator2
          status: existing        # needed to know which  validator node exists
          bootnode: true          # true if the validator node is used also a bootnode for the network
          p2p:
            port: 30303
            ambassador: 15012     #Port exposed on ambassador service (use one port per org if using single cluster)
          rpc:
            port: 8545
            ambassador: 15013     #Port exposed on ambassador service (use one port per org if using single cluster)
          ws:
            port: 8546          
        - validator:
          name: validator3
          status: existing        # needed to know which  validator node exists        
          bootnode: false         # true if the validator node is used also a bootnode for the network
          p2p:
            port: 30303
            ambassador: 15014     #Port exposed on ambassador service (use one port per org if using single cluster)
          rpc:
            port: 8545
            ambassador: 15015     #Port exposed on ambassador service (use one port per org if using single cluster)
          ws:
            port: 8546          
        - validator:
          name: validator4
          status: existing        # needed to know which  validator node exists        
          bootnode: false         # true if the validator node is used also a bootnode for the network
          p2p:
            port: 30303
            ambassador: 15016     #Port exposed on ambassador service (use one port per org if using single cluster)
          rpc:
            port: 8545
            ambassador: 15017     #Port exposed on ambassador service (use one port per org if using single cluster)
          ws:
            port: 8546
        - validator:
          name: validator5
          status: new             # needed to know which  validator node exists        
          bootnode: false         # true if the validator node is used also a bootnode for the network
          p2p:
            port: 30303
            ambassador: 15018     #Port exposed on ambassador service (use one port per org if using single cluster)
          rpc:
            port: 8545
            ambassador: 15019     #Port exposed on ambassador service (use one port per org if using single cluster)
          ws:
            port: 8546

```
Three new sections are added to the network.yaml   

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| tm_nodes | Existing network's transaction manager nodes' public addresses with nodeport.|
| besu_nodes | Existing network's besu nodes' public addresses with rpc port.|
| genesis | Path to existing network's genesis.json in base64.|


<a name = "run_network"></a>
## Run playbook

The [add-validator.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-besu/configuration/add-validator.yaml) playbook is used to add a new validator node to an existing organization in a running network. This can be done using the following command

```
ansible-playbook platforms/hyperledger-besu/configuration/add-validator.yaml --extra-vars "@path-to-network.yaml"
```
