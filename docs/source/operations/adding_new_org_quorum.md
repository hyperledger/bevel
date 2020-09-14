<a name = "adding-new-org-to-existing-network-in-quorum"></a>
# Adding a new node in Quorum

  - [Prerequisites](#prerequisites)
  - [Create Configuration File](#create-configuration-file)
  - [Run playbook](#run-playbook)

<a name = "prerequisites"></a>
## Prerequisites
To add a new organization in Quorum, an existing quorum network should be running, enode information of all existing nodes present in the network should be available, genesis block should be available in base64 encoding and the geth information of a node should be available and that node account should be unlocked prior adding the new node to the existing quorum network. 

---
**NOTE**: Addition of a new organization has been tested on an existing network which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.

---

<a name = "create_config_file"></a>
## Create Configuration File

Refer [this guide](./quorum_networkyaml.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organization` patch along with the enode information, genesis block in base64 encoding and geth account details

---
**NOTE**: Make sure that the genesis block information is given in base64 encoding. Also, if you are adding node to the same cluster as of another node, make sure that you add the ambassador ports of the existing node present in the cluster to the network.yaml

---
For reference, sample `network.yaml` file looks like below for RAFT consensus (but always check the latest network-quorum-newnode.yaml at `platforms/quourm/configuration/samples`):

```
---
# This is a sample configuration file for Quorum network which has 4 nodes.
# All text values are case-sensitive
network:
  # Network level configuration specifies the attributes required for each organization
  # to join an existing network.
  type: quorum
  version: 2.5.0  #this is the version of Quorum docker image that will be deployed. older version 2.1.1 is not compatible with supplychain contracts

  #Environment section for Kubernetes setup
  env:
    type: "dev"              # tag for the environment. Important to run multiple flux on single cluster
    proxy: ambassador               # value has to be 'ambassador' as 'haproxy' has not been implemented for Quorum
    ## Any additional Ambassador ports can be given below, must be comma-separated without spaces, this is valid only if proxy='ambassador'
    #  These ports are enabled per cluster, so if you have multiple clusters you do not need so many ports
    #  This sample uses a single cluster, so we have to open 4 ports for each Node. These ports are again specified for each organization below
    ambassadorPorts: 15010,15011,15012,15013,15020,15021,15022,15023,15030,15031,15032,15033,15040,15041,15042,15043  
    retry_count: 20                 # Retry count for the checks on Kubernetes cluster
    external_dns: enabled           # Should be enabled if using external-dns for automatic route configuration
  
  # Docker registry details where images are stored. This will be used to create k8s secrets
  # Please ensure all required images are built and stored in this registry. 
  # Do not check-in docker_password.
  docker:
    url: "index.docker.io/hyperledgerlabs"
    username: "docker_username"
    password: "docker_password"
  
  # Following are the configurations for the common Quorum network
  config:    
    consensus: "raft"                 # Options are "raft" and "ibft"
    ## Certificate subject for the root CA of the network. 
    #  This is for development usage only where we create self-signed certificates and the truststores are generated automatically.
    #  Production systems should generate proper certificates and configure truststores accordingly.
    subject: "CN=DLT Root CA,OU=DLT,O=DLT,L=London,C=GB"
    transaction_manager: "tessera"    # Options are "tessera" and "constellation"
    # This is the version of "tessera" or "constellation" docker image that will be deployed
    # Supported versions #
    # constellation: 0.3.2 (For all versions of quorum)
    # tessera: 0.10.4 (for quorum 2.5.0)
    tm_version: "0.10.4"               
    tm_tls: "strict"                  # Options are "strict" and "off"
    tm_trust: "tofu"                  # Options are: "whitelist", "ca-or-tofu", "ca", "tofu"
    ## Transaction Manager nodes public addresses should be provided.
    #  For "tessera", all participating nodes should be provided
    #  For "constellation", only one is bootnode should be provided
    #
    # For constellation, use following. This will be the bootnode for all nodes
    #  - "http://carrier.test.quorum.blockchaincloudpoc.com:15012/"  #NOTE the end / is necessary and should not be missed
    # The above domain name is formed by the http://(peer.name).(org.external_url_suffix):(ambassador constellation port)/
    # In the example (for tessera ) below, the domain name is formed by the https://(peer.name).(org.external_url_suffix):(ambassador default port)
    tm_nodes: 
      - "https://carrier.test.quorum.blockchaincloudpoc.com:8443"
      - "https://manufacturer.test.quorum.blockchaincloudpoc.com:8443"
      - "https://store.test.quorum.blockchaincloudpoc.com:8443"
      - "https://warehouse.test.quorum.blockchaincloudpoc.com:8443"
    ##### Following keys are used only to add new Node(s) to existing network.
    staticnodes:                # Existing network static nodes need to be provided like below
    # The below urls are formed by the enode://(peerid)@(peer.name).(org.external_url_suffix):(ambassador p2p port)?discport=0&raftport=(ambassador RAFT port)
    # peerid is generated in the automation
      - enode://293ce022bf114b14520ad97349a1990180973885cc2afb6f4196b490397e164fabc87900736e4b685c5f4cf31479021ba0d589e58bd0ea6792ebbfd5eb0348af@carrier.test.quorum.blockchaincloudpoc.com:15011?discport=0&raftport=15012
      - enode://4e7a1a15ef6a9bbf30f8b2a6b927f4941c9e80aeeeed14cfeeea619f93256b41ef9994b9a8af371f394c2a6de9bc6930e142c0350399a22081c518ab2d27f92a@manufacturer.test.quorum.blockchaincloudpoc.com:15021?discport=0&raftport=15022
    genesis:                    # Existing network's genesis.json file in base64 format like below
    #     ewogICAgImFsbG9jIjogewogICAgICAgICIwOTg2Nzk2ZjM0ZDhmMWNkMmI0N2M3MzQ2YTUwYmY2
    #     OWFhOWM1NzcyIjogewogICAgICAgICAgICAiYmFsYW5jZSI6ICIxMDAwMDAwMDAwMDAwMDAwMDAw
    #     MDAwMDAwMDAwIgogICAgICAgIH0sCiAgICAgICAgImY2MjkyNTQ1YWVjNTkyMDU4MzQ
    # geth account details
    # make sure that the account is unlocked prior to adding a new node
    bootnode:
      #name of the node 
      name: carrier
      #ambassador url of the node
      url: carrier.test.quorum.blockchaincloudpoc.com
      #rpc port of the node
      rpcport: 15011
      #id of the node.
      nodeid: 1
  
  # Allows specification of one or many organizations that will be connecting to a network.
  organizations:
    # Specification for the 1st organization. Each organization should map to a VPC and a separate k8s cluster for production deployments
    - organization:
      name: neworg
      external_url_suffix: test.quorum.blockchaincloudpoc.com   # This is the url suffix that will be added in DNS recordset. Must be different for different clusters
      cloud_provider: aws   # Options: aws, azure, gcp
      aws:
        access_key: "aws_access_key"        # AWS Access key, only used when cloud_provider=aws
        secret_key: "aws_secret_key"        # AWS Secret key, only used when cloud_provider=aws
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
      # Git Repo details which will be used by GitOps/Flux.
      # Do not check-in git_access_token
      gitops:
        git_ssh: "ssh://git@github.com/<username>/blockchain-automation-framework.git"         # Gitops ssh url for flux value files 
        branch: "develop"           # Git branch where release is being made
        release_dir: "platforms/quorum/releases/dev" # Relative Path in the Git repo for flux sync per environment. 
        chart_source: "platforms/quorum/charts"     # Relative Path where the Helm charts are stored in Git repo
        git_push_url: "github.com/<username>/blockchain-automation-framework.git"   # Gitops https URL for git push 
        username: "git_username"          # Git Service user who has rights to check-in in all branches
        password: "git_access_token"          # Git Server user password
        email: "git_email"                # Email to use in git config
        private_key: "path_to_private_key"          # Path to private key file which has write-access to the git repo
      # The participating nodes are named as peers
      services:
        peers:
        - peer:
          name: neworg
          subject: "O=Neworg,OU=Neworg,L=51.50/-0.13/London,C=GB" # This is the node subject. L=lat/long is mandatory for supplychain sample app
          type: validator         # value can be validator or non-validator, only applicable if consensus = 'ibft'
          geth_passphrase: 12345  # Passphrase to be used to generate geth account
          p2p:
            port: 21000
            ambassador: 15010       #Port exposed on ambassador service (use one port per org if using single cluster)
          rpc:
            port: 8546
            ambassador: 15011       #Port exposed on ambassador service (use one port per org if using single cluster)
          transaction_manager:
            port: 8443          # use port: 9001 when transaction_manager = "constellation"
            ambassador: 8443    # use ambassador: 15012 when transaction_manager = "constellation"
          raft:                     # Only used if consensus = 'raft'
            port: 50401
            ambassador: 15013
          db:                       # Only used if transaction_manager = "tessera"
            port: 3306
           

```
Three new sections are added to the network.yaml
| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| staticnodes | Existing network's static nodes need to be provided as an array.|
| genesis | Existing network's genesis.json needs to be provided in base64.|
| bootnode | Bootnode account details.|


The `network.config.bootnode` field contains:

| Field                            | Description                                        |
|----------------------------------|----------------------------------------------------|
| name                             | Name of the bootnode                               |
| url                              | URL of the bootnode, generally the ambassador URL  |
| rpcport                          | RPC port of the bootnode                           |
| nodeid                           | Node ID of the bootnode                            |

<a name = "run_network"></a>
## Run playbook

The [site.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/site.yaml) playbook is used to add a new organization to the existing network. This can be done using the following command

```
ansible-playbook platforms/shared/configuration/site.yaml --extra-vars "@path-to-network.yaml"
```


