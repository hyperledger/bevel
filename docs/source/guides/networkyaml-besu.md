[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Configuration file specification: Hyperledger Besu
A network.yaml file is the base configuration file designed in Hyperledger Bevel for setting up a Hyperledger Besu DLT/Blockchain network. This file contains all the configurations related to the network that has to be deployed. Below shows its structure.
![](./../_static/TopLevelClass-Besu.png)

Before setting up a Hyperledger Besu DLT/Blockchain network, this file needs to be updated with the required specifications.  
A sample configuration file is provided in the repo path:  
`platforms/hyperledger-besu/configuration/samples/network-besu.yaml` 

A json-schema definition is provided in `platforms/network-schema.json` to assist with semantic validations and lints. You can use your favorite yaml lint plugin compatible with json-schema specification, like `redhat.vscode-yaml` for VSCode. You need to adjust the directive in template located in the first line based on your actual build directory:

`# yaml-language-server: $schema=../platforms/network-schema.json`

The configurations are grouped in the following sections for better understanding.

* type

* version

* env

* docker

* config

* organizations

Here is the snapshot from the sample configuration file

![](./../_static/NetworkYamlBesu.png)

The sections in the sample configuration file are  

`type` defines the platform choice like corda/fabric/indy/quorum/besu, here in the example its **besu**.

`version` defines the version of platform being used. The current Hyperledger Besu version support is for **21.10.6** and **22.10.2**.

`permissioning` section contains the flag to enable permissioning in the network
```yaml
   permissioning:
     enabled: false
```

`env` section contains the environment type and additional (other than 443) Ambassador port configuration. Vaule for proxy field under this section can be 'ambassador' as 'haproxy' has not been implemented for Besu.

The snapshot of the `env` section with example value is below
```yaml 
  env:
    type: "env-type"              # tag for the environment. Important to run multiple flux on single cluster
    proxy: ambassador               # value has to be 'ambassador' as 'haproxy' has not been implemented for Hyperledger Besu
    #  These ports are enabled per cluster, so if you have multiple clusters you do not need so many ports
    #  This sample uses a single cluster, so we have to open 4 ports for each Node. These ports are again specified for each organization below
    ambassadorPorts:                # Any additional Ambassador ports can be given here, this is valid only if proxy='ambassador'
      portRange:              # For a range of ports 
        from: 15010 
        to: 15043
    # ports: [15020, 15021]      # For specific ports, needs to be an array or list
    loadBalancerSourceRanges: # (Optional) Default value is '0.0.0.0/0', this value can be changed to any other IP adres or list (comma-separated without spaces) of IP adresses, this is valid only if proxy='ambassador'
    retry_count: 50                # Retry count for the checks
    external_dns: enabled           # Should be enabled if using external-dns for automatic route configuration
    labels:
      service: {}
      pvc: {}
      deployment: {}
```
The fields under `env` section are 

| Field      | Description                                 |
|------------|---------------------------------------------|
| type       | Environment type. Can be like dev/test/prod.|
| proxy      | Choice of the Cluster Ingress controller. Currently supports 'ambassador' only as 'haproxy' has not been implemented for Hyperledger Besu |
| ambassadorPorts   | Any additional Ambassador ports can be given here. This is only valid if `proxy: ambassador`. These ports are enabled per cluster, so if you have multiple clusters you do not need so many ports to be opened on Ambassador. Our sample uses a single cluster, so we have to open 4 ports for each Node. These ports are again specified in the `organization` section.     |
| loadBalancerSourceRanges | (Optional) Restrict inbound access to a single or list of IP adresses for the public Ambassador ports to enhance Bevel network security. This is only valid if `proxy: ambassador`.  |
| retry_count       | Retry count for the checks. Use a high number if your cluster is slow. |
|external_dns       | If the cluster has the external DNS service, this has to be set `enabled` so that the hosted zone is automatically updated. |
| namespace         | (Optional) K8s Namespace on which proxy will be installed. Default value is `default`|
| labels.service    | (Optional) Labels to be added to kubernetes services |
| labels.pvc    | (Optional) Labels to be added to kubernetes pvc |
| labels.deployment    | (Optional) Labels to be added to kubernetes deployment/statefulset/pod |

`docker` section contains the credentials of the repository where all the required images are built and stored.

The snapshot of the `docker` section with example values is below
```yaml
  # Docker registry details where images are stored. This will be used to create k8s secrets
  # Please ensure all required images are built and stored in this registry.
  # Do not check-in docker_password.
  docker:
    url: "docker_url"
    username: "docker_username"
    password: "docker_password"
```
The fields under `docker` section are

| Field    | Description                            |
|----------|----------------------------------------|
| url      | Docker registry url                    |
| username | Username required for login to docker registry|
| password | Password required for login to docker registry|


`config` section contains the common configurations for the Hyperledger Besu network.

The snapshot of the `config` section with example values is below
```yaml
  config:    
    consensus: "ibft"                 # Options are "ibft", "ethash", "clique"
    chain_id: 2018                    # Custom chain ID, Optional field - default value is 2018
    ## Certificate subject for the root CA of the network. 
    #  This is for development usage only where we create self-signed certificates and the truststores are generated automatically.
    #  Production systems should generate proper certificates and configure truststores accordingly.
    subject: "CN=DLT Root CA,OU=DLT,O=DLT,L=London,C=GB"
    transaction_manager: "tessera"    # Transaction manager can be "tessera"
    # This is the version of transaction_manager docker image that will be deployed
    # Supported versions #
    # tessera: 21.7.3(for besu 21.10.6)
    tm_version: "21.7.3"
    # TLS can be True or False for the transaction manager
    tm_tls: True
    # Tls trust value
    tm_trust: "tofu"                  # Options are: "ca-or-tofu", "ca", "tofu"
    ## File location for saving the genesis file should be provided.
    genesis: "/home/user/bevel/build/besu_genesis"   # Location where genesis file will be saved
    ## At least one Transaction Manager nodes public addresses should be provided.
    #  - "https://node.test.besu.blockchaincloudpoc-develop.com" for tessera
    # The above domain name is formed by the (http or https)://(peer.name).(org.external_url_suffix):(ambassador tm_nodeport)
    tm_nodes: 
      - "https://carrier.test.besu.blockchaincloudpoc-develop.com"

```
The fields under `config` are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| consensus   | Currently supports `ibft`,`qbft`, `ethash` and `clique`. Please update the remaining items according to the consensus chosen as not all values are valid for all the consensus.                                 |
| chain_id    | Custom chain Id, default value is `2018` |
| subject     | This is the subject of the root CA which will be created for the Hyperledger Besu network. The root CA is for development purposes only, production networks should already have the root certificates.   |
| transaction_manager    | Supports `tessera`. |
| tm_version         | This is the version of transaction manager docker image that will be deployed. Supported versions: `21.7.3` for `tessera`. |
| tm_tls | Options are `True` and `False`. This enables TLS for the transaction manager and Besu node. `False` is not recommended for production. |
| tm_trust | Options are: `ca-or-tofu`, `ca`, `tofu`. This is the trust relationships for the transaction managers. More details [on modes here]( https://docs.tessera.consensys.net/en/stable/HowTo/Configure/TLS/#trust-modes ).|
| genesis | This is the path where `genesis.json` will be stored for a new network; for adding new node, the existing network's genesis.json should be available in json format in this file. |
| tm_nodes | This is an array. Provide at least one tessera node details which will act as bootstrap for other tessera nodes |


The `organizations` section contains the specifications of each organization.  

In the sample configuration example, we have four organization under the `organizations` section.

The snapshot of an organization field with sample values is below
```yaml
  organizations:
    # Specification for the 1st organization. Each organization maps to a VPC and a separate k8s cluster
    - organization:
      name: carrier
      type: member
      # Provide the url suffix that will be added in DNS recordset. Must be different for different clusters
      external_url_suffix: test.besu.blockchaincloudpoc.com 
      cloud_provider: aws   # Options: aws, azure, gcp, minikube
```
Each `organization` under the `organizations` section has the following fields. 

| Field                                    | Description                                 |
|------------------------------------------|-----------------------------------------------------|
| name                                        | Name of the organization     |
| type | Can be `member` for peer/member organization and `validator` for Validator organization.|
| external_url_suffix                         | Public url suffix for the cluster. This is used to discover nodes between different clusters and to establish communication between nodes         |
| cloud_provider                              | Cloud provider of the Kubernetes cluster for this organization. This field can be aws, azure, gcp or minikube |
| aws                                         | Contains the AWS CLI credentials when the organization cluster is on AWS |
| k8s                                         | Kubernetes cluster deployment variables.|
| vault                                       | Contains Hashicorp Vault server address and root-token |
| gitops                                      | Git Repo details which will be used by GitOps/Flux. |
| services                                    | Contains list of services which could be validator/peer based on the type of organization |

For the `aws` and `k8s` field the snapshot with sample values is below
```yaml
      aws:
        access_key: "<aws_access_key>"    # AWS Access key, only used when cloud_provider=aws
        secret_key: "<aws_secret>"        # AWS Secret key, only used when cloud_provider=aws
        region: "<aws_region>"                # AWS Region where cluster and EIPs are created
      # Kubernetes cluster deployment variables.
      k8s:
        context: "<cluster_context>"
        config_file: "<path_to_k8s_config_file>"
```

The `aws` field under each organization contains: (This will be ignored if cloud_provider is not `aws`)

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| access_key                              | AWS Access key  |
| secret_key                              | AWS Secret key  |
| region            | The AWS region where K8s cluster and the EIPs reside |

The `k8s` field under each organization contains

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| context                                 | Context/Name of the cluster where the organization entities should be deployed                                   |
| config_file                             | Path to the kubernetes cluster configuration file                                                                |

For gitops fields the snapshot from the sample configuration file with the example values is below
```yaml
      # Git Repo details which will be used by GitOps/Flux.
      gitops:
        git_protocol: "https" # Option for git over https or ssh
        git_url: "https://github.com/<username>/bevel.git" # Gitops htpps or ssh url for flux value files
        branch: "<branch_name>"                                                  # Git branch where release is being made
        release_dir: "platforms/hyperledger-besu/releases/dev" # Relative Path in the Git repo for flux sync per environment. 
        chart_source: "platforms/hyperledger-besu/charts"      # Relative Path where the Helm charts are stored in Git repo
        git_repo: "github.com/<username>/bevel.git" # without https://
        username: "<username>"          # Git Service user who has rights to check-in in all branches
        password: "<password>"          # Git Server user password/personal token (Optional for ssh; Required for https)
        email: "<git_email>"              # Email to use in git config
        private_key: "<path to gitops private key>" # Path to private key (Optional for https; Required for ssh)
```

The gitops field under each organization contains

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| git_protocol | Option for git over https or ssh. Can be `https` or `ssh` |
| git_url                              | SSH or HTTPs url of the repository where flux should be synced                                                            |
| branch                               | Branch of the repository where the Helm Charts and value files are stored                                        |
| release_dir                          | Relative path where flux should sync files                                                                       |
| chart_source                         | Relative path where the helm charts are stored                                                                   |
| git_repo                         | Gitops git repo URL https URL for git push like "github.com/hyperledger/bevel.git"             |
| username                             | Username which has access rights to read/write on repository                                                     |
| password                             | Password of the user which has access rights to read/write on repository (Optional for ssh; Required for https)  |
| email                                | Email of the user to be used in git config                                                                       |
| private_key                          | Path to the private key file which has write-access to the git repo (Optional for https; Required for ssh)       |

The services field for each organization under `organizations` section of Hyperledger Besu contains list of `services` which could be peers or validators.

Each organization with type as `member` will have a peers service. The snapshot of peers service with example values is below
```yaml
        peers:
        - peer:
          name: carrier
          subject: "O=Carrier,OU=Carrier,L=51.50/-0.13/London,C=GB" # This is the node subject. L=lat/long is mandatory for supplychain sample app
          geth_passphrase: "12345"  # Passphrase to be used to generate geth account
          lock: true        # (for future use) Sets Besu node to lock or unlock mode. Can be true or false
          p2p:
            port: 30303
            ambassador: 15010       #Port exposed on ambassador service (use one port per org if using single cluster)
          rpc:
            port: 8545
            ambassador: 15011       #Port exposed on ambassador service (use one port per org if using single cluster)
          ws:
            port: 8546
          db:
            port: 3306        # Only applicable for tessra where mysql db is used
          tm_nodeport:
            port: 8888         
            ambassador: 15013   # Port exposed on ambassador service (Transaction manager node port)
          tm_clientport:
            port: 8080             
```
The fields under `peer` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name            | Name of the peer                |
| subject     | This is the alternative identity of the peer node    |
| geth_passphrase | This is the passphrase used to generate the geth account. |
| lock   | (for future use). Sets Besu node to lock or unlock mode. Can be true or false|
| p2p.port   | P2P port for Besu|
| p2p.ambassador | The P2P Port when exposed on ambassador service|
| rpc.port   | RPC port for Besu|
| rpc.ambassador | The RPC Port when exposed on ambassador service|
| ws.port   | Webservice port for Besu|
| db.port   | Port for MySQL database which is only applicable for `tessera`|
| tm_nodeport.port   | Port used by Transaction manager `tessera`. |
| tm_nodeport.ambassador | The tm port when exposed on ambassador service. |
| tm_clientport.port   | Client Port used by Transaction manager `tessera`. This is the port where Besu nodes connect to their respective transaction manager. |

The peer in an organization with type as `member` can be used to deploy the smarcontracts with additional field `peer.smart_contract`. The snapshot of peers service with example values is below
```yaml
        peers:
        - peer:
          name: carrier
          subject: "O=Carrier,OU=Carrier,L=51.50/-0.13/London,C=GB" # This is the node subject. L=lat/long is mandatory for supplychain sample app
          geth_passphrase: "12345"  # Passphrase to be used to generate geth account
          p2p:
            port: 30303
            ambassador: 15010       #Port exposed on ambassador service (use one port per org if using single cluster)
          rpc:
            port: 8545
            ambassador: 15011       #Port exposed on ambassador service (use one port per org if using single cluster)
          ws:
            port: 8546
          tm_nodeport:
            port: 8888         
            ambassador: 15013   # Port exposed on ambassador service (Transaction manager node port)
          tm_clientport:
            port: 8080       
          geth_url: "http://manufacturerrpc.test.besu.blockchaincloudpoc.com"  # geth url of the node
          # smartcontract to be deployed only from one node (should not be repeated in other nodes)
          smart_contract:
            name: "General"           # Name of the smart contract or Name of the main Smart contract Class
            deployjs_path: "examples/supplychain-app/besu/smartContracts" # location of folder containing deployment script from Bevel directory
            contract_path: "../../besu/smartContracts/contracts"       # Path of the smart contract folder relative to deployjs_path
            iterations: 200           # Number of Iteration of execution to which the gas and the code is optimised
            entrypoint: "General.sol" # Main entrypoint solidity file of the contract 
            private_for: "hPFajDXpdKzhgGdurWIrDxOimWFbcJOajaD3mJJVrxQ=,7aOvXjjkajr6gJm5mdHPhAuUANPXZhJmpYM5rDdS5nk=" # Node public keys for the privateFor         
```
The additional fields under `peer` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| geth_url  | RPC url for the `besu` node  |
| smart_contract.name | Name of the main smartcontract class  |
| smart_contract.deployjs_path | location of folder containing deployment script relative to Bevel directory  |
| smart_contract.contract_path | Path of the smart contract folder relative to deployjs_path  |
| smart_contract.iterations | Number of Iteration of executions for which the gas and the code is optimised  |
| smart_contract.entrypoint | Main entrypoint solidity file of the smart contract   |
| smart_contract.private_for | Comma seperated string of `tessera` Public keys for the `privateFor`  |

Each organization with type as `validator` will have a validator service. The snapshot of validator service with example values is below
```yaml
      validators:
        - validator:
          name: validator1
          bootnode: true          # true if the validator node is used also a bootnode for the network
          p2p:
            port: 30303
            ambassador: 15010       #Port exposed on ambassador service (use one port per org if using single cluster)
          rpc:
            port: 8545
            ambassador: 15011       #Port exposed on ambassador service (use one port per org if using single cluster)
          ws:
            port: 8546          
            
```
The fields under `validator` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name            | Name of the validator                |
| bootnode     | `true` if the validator node is used also a bootnode for the network ***    |
| p2p.port   | P2P port for Besu|
| p2p.ambassador | The P2P Port when exposed on ambassador service|
| rpc.port   | RPC port for Besu|
| rpc.ambassador | The RPC Port when exposed on ambassador service|
| ws.port   | Webservice port for Besu|
| metrics.enabled | Enable metrics for Besu node |
| metrics.port | Metrics port for Besu |

*** feature is in future scope
