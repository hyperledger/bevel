[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Configuration file specification: Hyperledger-Fabric
A network.yaml file is the base configuration file designed in Hyperledger Bevel for setting up a Fabric DLT network. This file contains all the information related to the infrastructure and network specifications. Below shows its structure.
![](./../_static/TopLevelClass-Fabric.png)

Before setting up a Fabric DLT/Blockchain network, this file needs to be updated with the required specifications.

A sample configuration file is provided in the repo path:  
`platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml` 

A json-schema definition is provided in `platforms/network-schema.json` to assist with semantic validations and lints. You can use your favorite yaml lint plugin compatible with json-schema specification, like `redhat.vscode-yaml` for VSCode. You need to adjust the directive in template located in the first line based on your actual build directory:

`# yaml-language-server: $schema=../platforms/network-schema.json`

The configurations are grouped in the following sections for better understanding.

* type

* version

* docker

* frontend

* env

* consensus

* orderers

* channels

* organizations

Here is the snapshot from the sample configuration file

![](./../_static/NetworkYamlFabric1.png)

The sections in the sample configuration file are:  

`type` defines the platform choice like corda/fabric, here in the example its Fabric

`version` defines the version of platform being used. The current Fabric version support is 1.4.8, 2.2.2 & 2.5.4

`frontend` is a flag which defines if frontend is enabled for nodes or not. Its value can only be enabled/disabled. This is only applicable if the sample Supplychain App is being installed.

`env` section contains the environment type. Value for proxy field under this section can be 'none' or 'haproxy'

The snapshot of the `env` section with example value is below
```yaml 
  env:
    type: "dev"              # tag for the environment. Important to run multiple flux on single cluster
    proxy: haproxy                  # values can be 'haproxy' or 'none'
    retry_count: 100                # Retry count for the checks
    external_dns: enabled           # Should be enabled if using external-dns for automatic route configuration
    annotations:              # Additional annotations that can be used for some pods (ca, ca-tools, orderer and peer nodes)
      service: 
       - example1: example2
      deployment: {} 
      pvc: {}
```
The fields under `env` section are 

| Field      | Description                                 |
|------------|---------------------------------------------|
| type       | Environment type. Can be like dev/test/prod.|
| proxy      | Choice of the Cluster Ingress controller. Currently supports 'haproxy' for production/inter-cluster and 'none' for single cluster |
| retry_count       | Retry count for the checks. |
|external_dns       | If the cluster has the external DNS service, this has to be set `enabled` so that the hosted zone is automatically updated. |
|annotations| Use this to pass additional annotations to the `service`, `deployment` and `pvc` elements of Kubernetes|

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
| username | Username credential required for login |
| password | Password credential required for login |

---
**NOTE:** Please follow [these instructions](../operations/configure_prerequisites.html#docker) to build and store the docker images before running the Ansible playbooks.

---

`consensus` section contains the consensus service that uses the orderers provided in the following `orderers` section.

```yaml
  consensus:
    name: raft
```
The fields under the each `consensus` are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name                     | Name of the Consensus service. Can be `raft` or `kafka`.      |

`orderers` section contains a list of orderers with variables which will expose it for the network.

The snapshot of the `orderers` section with example values is below
```yaml
  # Remote connection information for orderer (will be blank or removed for orderer hosting organization)
  orderers:
    - orderer:
      type: orderer
      name: orderer1
      org_name: supplychain               #org_name should match one organization definition below in organizations: key            
      uri: orderer1.org1ambassador.blockchaincloudpoc.com:443   # Must include port, Can be external or internal URI for orderer which should be reachable by all peers
      certificate: /home/bevel/build/orderer1.crt           # Ensure that the directory exists
    - orderer:
      type: orderer
      name: orderer2
      org_name: supplychain               #org_name should match one organization definition below in organizations: key            
      uri: orderer2.org1ambassador.blockchaincloudpoc.com:443   # Must include port, Can be external or internal URI for orderer which should be reachable by all peers
      certificate: /home/bevel/build/orderer2.crt           # Ensure that the directory exists
    - orderer:
      type: orderer
      name: orderer3
      org_name: supplychain               #org_name should match one organization definition below in organizations: key            
      uri: orderer3.org1ambassador.blockchaincloudpoc.com:443   # Must include port, Can be external or internal URI for orderer which should be reachable by all peers
      certificate: /home/bevel/build/orderer3.crt           # Ensure that the directory exists
```
The fields under the each `orderer` are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name        | Name of the orderer service                                  |
| type        | For Fabric, `orderer` is the only valid type of orderers.   |
| org_name    | Name of the organization to which this orderer belongs to |
| uri         | Orderer URL which is accessible by all Peers. This must include the port even when running on 443                                              |
| certificate | Path to orderer certificate. For inital network setup, ensure that the directory is present, the file need not be present. For adding a new organization, ensure that the file is the crt file of the orderer of the existing network. |

The `channels` sections contains the list of channels mentioning the participating peers of the organizations.

The snapshot of channels section with its fields and sample values is below

```yaml
    # The channels defined for a network with participating peers in each channel
  channels:
  - channel:
    consortium: SupplyChainConsortium
    channel_name: AllChannel
    osn_creator_org: 
      name: supplychain
    chaincodes:
      - "chaincode_name"
    orderers: 
      - supplychain
    participants:
    - organization:
      name: carrier
      type: creator       # creator organization will create the channel and instantiate chaincode, in addition to joining the channel and install chaincode
      org_status: new
      peers:
      - peer:
        name: peer0
        gossipAddress: peer0.carrier-net.org3ambassador.blockchaincloudpoc.com:443  # Must include port, External or internal URI of the gossip peer
        peerAddress: peer0.carrier-net.org3ambassador.blockchaincloudpoc.com:443 # Must include port, External URI of the peer
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:443             # Must include port, External or internal URI of the orderer
    - organization:      
      name: store
      type: joiner        # joiner organization will only join the channel and install chaincode
      org_status: new
      peers:
      - peer:
        name: peer0
        gossipAddress: peer0.store-net.org4ambassador.blockchaincloudpoc.com:443
        peerAddress: peer0.store-net.org4ambassador.blockchaincloudpoc.com:443 # Must include port, External URI of the peer
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:443
    - organization:
      name: warehouse
      type: joiner
      org_status: new
      peers:
      - peer:
        name: peer0
        gossipAddress: peer0.warehouse-net.org5ambassador.blockchaincloudpoc.com:443
        peerAddress: peer0.warehouse-net.org5ambassador.blockchaincloudpoc.com:443 # Must include port, External URI of the peer
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:443
    - organization:
      name: manufacturer
      type: joiner
      org_status: new
      peers:
      - peer:
        name: peer0
        gossipAddress: peer0.manufacturer-net.org2ambassador.blockchaincloudpoc.com:443
        peerAddress: peer0.manufacturer-net.org2ambassador.blockchaincloudpoc.com:443 # Must include port, External URI of the peer
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:443
    endorsers:
      # Only one peer per org required for endorsement
    - organization:
      name: carrier
      peers:
      - peer:
        name: peer0
        corepeerAddress: peer0.carrier-net.org3ambassador.blockchaincloudpoc.com:443
        certificate: "/path/ca.crt" # certificate path for peer
    - organization:
      name: warehouse
      peers:
      - peer:
        name: peer0
        corepeerAddress: peer0.warehouse-net.org5ambassador.blockchaincloudpoc.com:443
        certificate: "/path/ca.crt" # certificate path for peer
    - organization:
      name: manufacturer
      peers:
      - peer:
        name: peer0
        corepeerAddress: peer0.manufacturer-net.org2ambassador.blockchaincloudpoc.com:443
        certificate: "/path/ca.crt" # certificate path for peer
    - organization:
      name: store
      peers:
      - peer:
        name: peer0
        corepeerAddress: peer0.store-net.org4ambassador.blockchaincloudpoc.com:443
        certificate: "/path/ca.crt" # certificate path for peer     
    genesis:
      name: OrdererGenesis
```
The fields under the `channel` are

| Field                           | Description                                                |
|---------------------------------|------------------------------------------------------------|
| consortium                      | Name of the consortium, the channel belongs to             |
| channel_name                    | Name of the channel                                        |
| osn_creator_org.name            | Name of the organization whose orderers will create the channel                                 |
| chaincodes                      | Contains list of chaincodes for the channel                |
| genesis.name                    | Name of the genesis block                                  |
| orderers                        | List of names of the organizations providing ordering service           |
| participants                    | Contains list of organizations participating in the channel|
| endorsers                       | Contains list of organizations (v2.2+)                     |
| channel_status                  | Mainly needed to add channel to existing org. Possible values are `new` or `existing`|

Each `organization` field under `participants` field of the channel contains the following fields

| Field                           | Description                                                |
|---------------------------------|------------------------------------------------------------|
| name               | Organization name of the peer participating in the channel |
| type               | This field can be creator/joiner of channel                |
| org_status         | `new` (for inital setup) or `existing` (for add new org) | 
| ordererAddress     | URL of the orderer this peer connects to, including port                  |
| peer.name          | Name of the peer                                           |
| peer.gossipAddress | Gossip address of the peer, including port                               |
| peer.peerAddress | External address of the peer, including port                                  |

Each `organization` field under `endorsers` field of the channel contains the following fields

| Field                           | Description                                                |
|---------------------------------|------------------------------------------------------------|
| name                 | Endorser name                                                         |
| peer.name            | Name of the peer                                                      |
| peer.corepeerAddress | Endorsers addresses, including port                                                    |
| peer.certificate     | Certificate path for peer                                             |

The `organizations` section contains the specifications of each organization.  

In the sample configuration example, we have five organization under the `organizations` section

The snapshot of an organization field with sample values is below
```yaml
  organizations:
    # Specification for the 1st organization. Each organization maps to a VPC and a separate k8s cluster
    - organization:
      name: supplychain
      country: UK
      state: London
      location: London
      subject: "O=Orderer,L=51.50/-0.13/London,C=GB"
      type: orderer
      external_url_suffix: org1ambassador.blockchaincloudpoc.com
      org_status: new
      ca_data:
        url: ca.supplychain-net:7054
        certificate: file/server.crt        # This has not been implemented 
      cloud_provider: aws   # Options: aws, azure, gcp, digitalocean, minikube
```
Each `organization` under the `organizations` section has the following fields. 

| Field                                    | Description                                 |
|------------------------------------------|-----------------------------------------------------|
| name                                        | Name of the organization                                                                                         |
| country                                     | Country of the organization                                                                                      |
| state                                       | State of the organization                                                                                        |
| location                                    |  Location of the organization                                                                                    |
| subject                                     | Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
| type                                        | This field can be orderer/peer            |
| external_url_suffix                         | Public url suffix of the cluster.         |
| org_status         | `new` (for inital setup) or `existing` (for add new org) |
| orderer_org        |  Ordering service provider. It should only be added to peer organizations |  
| ca_data                                     | Contains the certificate authority url (dont include port if running on 443) and certificate path; this has not been implemented yet |
| cloud_provider                              | Cloud provider of the Kubernetes cluster for this organization. This field can be aws, azure, gcp or minikube |
| aws                                         | When the organization cluster is on AWS |
| k8s                                         | Kubernetes cluster deployment variables.|
| vault                                       | Contains Hashicorp Vault server address and root-token in the example |
| gitops                                      | Git Repo details which will be used by GitOps/Flux. |
| services                                    | Contains list of services which could ca/peer/orderers/concensus based on the type of organization |

For the aws and k8s field the snapshot with sample values is below
```yaml
      aws:
        access_key: "<aws_access_key>"    # AWS Access key, only used when cloud_provider=aws
        secret_key: "<aws_secret>"        # AWS Secret key, only used when cloud_provider=aws
  
      # Kubernetes cluster deployment variables.
      k8s:        
        region: "<k8s_region>"
        context: "<cluster_context>"
        config_file: "<path_to_k8s_config_file>"
```

The `aws` field under each organization contains: (This will be ignored if cloud_provider is not 'aws')

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| access_key                              | AWS Access key  |
| secret_key                              | AWS Secret key  |

The `k8s` field under each organization contains

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| region                                  | Region where the Kubernetes cluster is deployed, e.g : eu-west-1        |
| context                                 | Context/Name of the cluster where the organization entities should be deployed                                   |
| config_file                             | Path to the kubernetes cluster configuration file                                                                |

For gitops fields the snapshot from the sample configuration file with the example values is below
```yaml
      # Git Repo details which will be used by GitOps/Flux.
      gitops:
        git_protocol: "https" # Option for git over https or ssh
        git_url: "https://github.com/<username>/bevel.git" # Gitops htpps or ssh url for flux value files
        branch: "<branch_name>"                                                  # Git branch where release is being made
        release_dir: "platforms/hyperledger-fabric/releases/dev" # Relative Path in the Git repo for flux sync per environment. 
        chart_source: "platforms/hyperledger-fabric/charts"      # Relative Path where the Helm charts are stored in Git repo
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
| password                             | Password of the user which has access rights to read/write on repository (Optional for ssh; Required for https)        |
| email                                | Email of the user to be used in git config                                                                       |
| private_key                          | Path to the private key file which has write-access to the git repo (Optional for https; Required for ssh)       |

For Hyperledger Fabric, you can also generate different user certificates and pass the names and attributes in the specific section for `users`. This is only applicable if using Fabric CA. An example is below:
```yaml
      # Generating User Certificates with custom attributes using Fabric CA in BAF for Peer Organizations
      users:
      - user:
        identity: user1
        attributes:
          - key: "hf.Revoker"
            value: "true"
```
The fields under `user` are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| identity          | The name of the user        |
| attribute   | key value pair for the different attributes supported in Fabric, details about the attribues are [here](https://hyperledger-fabric-ca.readthedocs.io/en/latest/users-guide.html#attribute-based-access-control) |


The services field for each organization under `organizations` section of Fabric contains list of `services` which could be ca/orderers/consensus/peers based on if the type of organization. 

Each organization will have a CA service under the service field. The snapshot of CA service with example values is below
```yaml
      # Services maps to the pods that will be deployed on the k8s cluster
      # This sample is an orderer service and includes a zk-kafka consensus
      services:
        ca:
          name: ca
          subject: "/C=GB/ST=London/L=London/O=Orderer/CN=ca.supplychain-net"
          type: ca
          grpc:
            port: 7054
```
The fields under `ca` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name                             | Certificate Authority service name        |
| subject                         | Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
| type | Type must be `ca` for certification authority |
| grpc.port                       | Grpc port number |


Each organization with type as peer will have a peers service. The snapshot of peers service with example values is below
```yaml
        peers:
        - peer:
          name: peer0          
          type: anchor    # This can be anchor/nonanchor. Atleast one peer should be anchor peer.         
          gossippeeraddress: peer0.manufacturer-net:7051 # Internal Address of the other peer in same Org for gossip, same peer if there is only one peer 
          peerAddress: peer0.carrier-net.org3ambassador.blockchaincloudpoc.com:443 # Must include port, External URI of the peer
          certificate: /path/manufacturer/peer0.crt # Path to peer Certificate
          cli: disabled      # Creates a peer cli pod depending upon the (enabled/disabled)
          configpath: /path/to/peer0-core.yaml  # path to custom core.yaml tag.         
          grpc:
            port: 7051         
          events:
            port: 7053
          couchdb:
            port: 5984
          restserver:           # This is for the rest-api server
            targetPort: 20001
            port: 20001 
          expressapi:           # This is for the express api server
            targetPort: 3000
            port: 3000
          chaincodes:
            - name: "chaincode_name" #This has to be replaced with the name of the chaincode
              version: "chaincode_version" #This has to be replaced with the version of the chaincode
              maindirectory: "chaincode_main"  #The main directory where chaincode is needed to be placed
              repository:
                username: "git_username"          # Git Service user who has rights to check-in in all branches
                password: "git_access_token"
                url: "github.com/hyperledger/bevel.git"
                branch: develop
                path: "chaincode_src"   #The path to the chaincode 
              arguments: 'chaincode_args' #Arguments to be passed along with the chaincode parameters
              endorsements: "" #Endorsements (if any) provided along with the chaincode
          metrics:
            enabled: true     # Enable/disable metrics collector for prometheus
            port: 9443        # metrics port - internal to the cluster 
```
The fields under `peer` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name                          | Name of the peer. Must be of the format `peer0` for the first peer, `peer1` for the second peer and so on.       |
| type                          | Type can be `anchor` and `nonanchor` for Peer                                                                    |
| gossippeeraddress             | Gossip address of another peer in the same Organization, including port. If there is only one peer, then use that peer address. Can be internal if the peer is hosted in the same Kubernetes cluster. |
| peerAddress             | External address of this peer, including port. Must be the HAProxy qualified address. If using single cluster, this can be internal address. |
| certificate | Path where the Peer's CA certificate will be stored. |
| cli             | Optional field. If `enabled` will deploy the CLI pod for this Peer. Default is `disabled`. |
| configpath | This field is mandatory for using external chaincode. This is the path where a custom core.yaml will be used for the peer. |
| grpc.port                     | Grpc port                                                                                                        |
| events.port                   | Events port                                                                                                      |
| couchdb.port                  | Couchdb port                                                                                                     |
| restserver.targetPort         | Restserver target port                                                                                           |
| restserver.port               | Restserver port                                                                                                  |
| expressapi.targetPort         | Express server target port                                                                                       |
| expressapi.port               | Express server port                                                                                              |
| metrics.enabled               | Enable metrics (ensure serviceMonitor CRD is present before enabling metrics)                                    |
| metrics.port                  | Metrics Port                                                                                                     |

The chaincodes section contains the list of chaincode for the peer, the fields under each chaincode are below

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name                | Name of the chaincode                                                                                            |
| version             | Version of the chaincode. Please do not use . (dot) in the version.    |
| external_chaincode | This is mandatory to be `true` when using external chaincode |
| maindirectory       | Path of main.go file, optional for external_chaincode                        |
| lang                | The language in which the chaincode is written ( golang/ java), optional for external_chaincode                |
| repository.username | Username which has access to the git repo containing chaincode, optional for external_chaincode    |
| repository.password | Password of the user which has access to the git repo containing chaincode, optional for external_chaincode|
| repository.url      | URL of the git repository containing the chaincode, optional for external_chaincode  |
| repository.branch   | Branch in the repository where the chaincode resides, optional for external_chaincode |
| repository.path     | Path of the chaincode in the repository branch, optional for external_chaincode    |
| arguments           | Init Arguments to the chaincode, mandatory for both chaincode types     |
| endorsements        | Endorsements (if any) provided along with the chaincode, optional for external_chaincode |
| tls | Mandatory for external_chaincode, marks the chaincode as tls enabled |
| buildpack_path | Mandatory for external_chaincode, Path from where the buildpack will be uploaded to the peer, ensure the core.yaml has been also updated correctly |
| image | Mandatory for external_chaincode, the container from docker registry applicable for this chaincode. For private registry, ensure password is passed in `network.docker` section |
| crypto_mount_path | Required only when `tls: true`, the path where the crypto materials will be stored |

The organization with orderer type will have concensus service. The snapshot of consensus service with example values is below
```yaml
        consensus:
          name: raft
          type: broker        #This field is not consumed for raft consensus
          replicas: 4         #This field is not consumed for raft consensus
          grpc:
            port: 9092        #This field is not consumed for raft consensus
```
The fields under `consensus` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name                     | Name of the Consensus service. Can be `raft` or `kafka`.      |
| type                      | Only for `kafka`. Consensus service type, only value supported is `broker` currently  |
| replicas                  | Only for `kafka`. Replica count of the brokers  |
| grpc.port                 | Only for `kafka`. Grpc port of consensus service |

The organization with orderer type will have orderers service. The snapshot of orderers service with example values is below
```yaml
        orderers:
        # This sample has multiple orderers as an example.
        # You can use a single orderer for most production implementations.
        - orderer:
          name: orderer1
          type: orderer
          consensus: raft
          grpc:
            port: 7050
          ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:443
        - orderer:
          name: orderer2
          type: orderer
          consensus: raft
          grpc:
            port: 7050
          ordererAddress: orderer2.org1ambassador.blockchaincloudpoc.com:443
        - orderer:
          name: orderer3
          type: orderer
          consensus: raft
          grpc:
            port: 7050
          ordererAddress: orderer3.org1ambassador.blockchaincloudpoc.com:443
          metrics:
            enabled: true     # Enable/disable metrics collector for prometheus
            port: 9443        # metrics port - internal to the cluster 
```
The fields under `orderer` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name                        | Name of the Orderer service                                                                                                     |
| type          | This type must be `orderer`  |
| consensus                   | Consensus type, for example: `kafka`, `raft`                                                                               |
| status                   | (Only needed to add new orderer). Possible values are `new` or `existing`                                                                                             |
| grpc.port                   | Grpc port of orderer                                                                                             |
|ordererAddress| Accessible address of the Orderer, including port |
| metrics.enabled               | Enable metrics (ensure serviceMonitor CRD is present before enabling metrics)                                    |
| metrics.port                  | Metrics Port                                                                                                     |
