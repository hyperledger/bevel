# Configuration file specification: Hyperledger-Fabric
A network.yaml file is the base configuration file designed in the Blockchain Automation Framework for setting up a Fabric DLT network. This file contains all the information related to the infrastructure and network specifications. Below shows its structure.
![](./../_static/TopLevelClass.png)

Before setting up a Fabric DLT network, this file needs to be updated with the required specifications.
A sample configuration file is provide in the repo path:  
`platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml` 

The configurations are grouped in the following sections for better understanding.

* type

* version

* docker

* frontend

* env

* orderers

* channels

* organizations

Here is the snapshot from the sample configuration file

![](./../_static/NetworkYamlFabric1.png)

The sections in the sample configuration file are  

`type` defines the platform choice like corda/fabric, here in the example its Fabric

`version` defines the version of platform being used. The current Fabric version support is 1.4.0

`frontend` is a flag which defines if frontend is enabled for nodes or not. Its value can only be enabled/disabled. This is only applicable if the sample Supplychain App is being installed.

`env` section contains the environment type and additional (other than 8443) Ambassador port configuration. Vaule for proxy field under this section can be 'ambassador' or 'haproxy'

The snapshot of the `env` section with expample value is below
```yaml 
  env:
    type: "env_type"              # tag for the environment. Important to run multiple flux on single cluster
    proxy: haproxy                  # values can be 'haproxy' or 'ambassador'
    ambassadorPorts: 15010,15020    # is valid only if proxy='ambassador'
    retry_count: 100                # Retry count for the checks
    external_dns: enabled           # Should be enabled if using external-dns for automatic route configuration
```
The fields under `env` section are 

| Field      | Description                                 |
|------------|---------------------------------------------|
| type       | Environment type. Can be like dev/test/prod.|
| proxy      | Choice of the Cluster Ingress controller. Currently supports 'ambassador' or 'haproxy' |
| ambassadorPorts   | Any additional Ambassador ports can be given here; must be comma-separated without spaces like `10010,10020`. This is only valid if `proxy: ambassador`     |
| retry_count       | Retry count for the checks.|
|external_dns       | If the cluster has the external DNS service, this has to be set `enabled` so that the hosted zone is automatically updated. |

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
**NOTE:** Please follow [these instructions](../operations/configure_prerequisites.md#docker) to build and store the docker images before running the Ansible playbooks.

---

`orderers` section contains a list of orderers with variables which will expose it for the network.

The snapshot of the `orderers` section with example values is below
```yaml
  # Remote connection information for orderer (will be blank or removed for orderer hosting organization)
  orderers:
    - orderer:
      type: orderer
      name: orderer1
      org_name: supplychain               #org_name should match one organization definition below in organizations: key            
      uri: orderer1.org1ambassador.blockchaincloudpoc.com:8443   # Can be external or internal URI for orderer which should be reachable by all peers
      certificate: directory/file1.cert
    - orderer:
      type: orderer
      name: orderer2
      org_name: supplychain               #org_name should match one organization definition below in organizations: key            
      uri: orderer2.org1ambassador.blockchaincloudpoc.com:8443   # Can be external or internal URI for orderer which should be reachable by all peers
      certificate: directory/file1.cert
```
The fields under the `orderers` section are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name        | Name of the orderer service                                  |
| type        | For Fabric, `orderer` is the only valid type of orderers.   |
| org_name    | Name of the organization to which this orderer belong to |
| uri         | Orderer URL                                              |
| certificate | Path to orderer certificate for connection by external organizations |

`channels` sections contains the list of channels mentioning the participating peers of the organizations.

The snapshot of channels section with its fields and sample values is below

```yaml
    # The channels defined for a network with participating peers in each channel
  channels:
  - channel:
    consortium: SupplyChainConsortium
    channel_name: AllChannel
    orderer: 
      name: supplychain
    participants:
    - organization:
      name: carrier
      type: creator       # creator organization will create the channel and instantiate chaincode, in addition to joining the channel and install chaincode
      peers:
      - peer:
        name: peer0
        type: validating
        gossipAddress: peer0.carrier-net.org3ambassador.blockchaincloudpoc.com:8443  # External or internal URI of the gossip peer
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:8443             # External or internal URI of the orderer
    - organization:      
      name: store
      type: joiner        # joiner organization will only join the channel and install chaincode
      peers:
      - peer:
        name: peer0
        type: validating
        gossipAddress: peer0.store-net.org3ambassador.blockchaincloudpoc.com:8443
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:8443
    - organization:
      name: warehouse
      type: joiner
      peers:
      - peer:
        name: peer0
        type: validating
        gossipAddress: peer0.warehouse-net.org2ambassador.blockchaincloudpoc.com:8443
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:8443
    - organization:
      name: manufacturer
      type: joiner
      peers:
      - peer:
        name: peer0
        type: validating
        gossipAddress: peer0.manufacturer-net.org2ambassador.blockchaincloudpoc.com:8443
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:8443
    genesis:
      name: OrdererGenesis
```
The fields under the channel are

| Field                           | Description                                                |
|---------------------------------|------------------------------------------------------------|
| consortium                      | Name of the consortium, the channel belongs to             |
| channel_name                    | Name of the channel                                        |
| genesis.name                    | Name of the genesis block                                  |
| orderer.name                    | Organization name to which the orderer belongs             |
| organization.name               | Organization name of the peer participating in the channel |
| organization.type               | This field can be creator/joiner of channel                |
| organization.peer.name          | Name of the peer                                           |
| organization.peer.type          | This field can be validating/non-validating*               |
| organization.peer.gossipAddress | Gossip address of the peer                                 |

`organizations` section contains the specifications of each organization.  
In the sample configuration example we have five organization under the `organizations` section

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
      cloud_provider: aws   # Options: aws, azure, gcp
```
Each organization under the `organizations` section has the following fields. 

| Field                                    | Description                                 |
|------------------------------------------|-----------------------------------------------------|
| name                                        | Name of the organization                                                                                         |
| country                                     | Country of the organization                                                                                      |
| state                                       | State of the organization                                                                                        |
| location                                    |  Location of the organization                                                                                    |
| subject                                     | Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
| type                                        | This field can be orderer/peer            |
| external_url_suffix                         | Public url suffix of the cluster.         |
| ca_data                                     | Contains the certificate authority url and certificate path; This has not been implemented yet |
| cloud_provider                              | Cloud provider of the Kubernetes cluster for this organization. This field can be aws, azure or gcp |
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

The aws field under each organisation contains

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| aws.access_key                              | AWS Access key  |
| aws.secret_key                              | AWS Secret key  |

The k8s field under each organisation contains

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| k8s.region                                  | Region where the Kubernetes cluster is deployed, e.g : eu-west-1        |
| k8s.context                                 | Context/Name of the cluster where the organization entities should be deployed                                   |
| k8s.config_file                             | Path to the kubernetes cluster configuration file                                                                |

For gitops fields the snapshot from the sample configuration file with the example values is below
```yaml
      # Git Repo details which will be used by GitOps/Flux.
      gitops:
        git_ssh: "git@github.com:<username>/blockchain-automation-framework.git" # Gitops ssh url for flux value files
        branch: "<branch_name>"                                                  # Git branch where release is being made
        release_dir: "platforms/hyperledger-fabric/releases/dev" # Relative Path in the Git repo for flux sync per environment. 
        chart_source: "platforms/hyperledger-fabric/charts"      # Relative Path where the Helm charts are stored in Git repo
        git_push_url: "github.com/<username>/blockchain-automation-framework.git"
        username: "<username>"          # Git Service user who has rights to check-in in all branches
        password: "<password>"          # Git Server user password/personal token
        private_key: "<path to gitops private key>"
```

The gitops field under each organization contains

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| gitops.git_ssh                              | SSH url of the repository where flux should be synced                                                            |
| gitops.branch                               | Branch of the repository where the Helm Charts and value files are stored                                        |
| gitops.release_dir                          | Relative path where flux should sync files                                                                       |
| gitops.chart_source                         | Relative path where the helm charts are stored                                                                   |
| gitops.git_push_url                         | Gitops https URL for git push like "github.com/hyperledger-labs/blockchain-automation-framework.git"             |
| gitops.username                             | Username which has access rights to read/write on repository                                                     |
| gitops.password                             | Password of the user which has access rights to read/write on repository                                         |
| gitops.private_key                          | Path to the private key file which has write-access to the git repo                                              |

The services field for each organization under `organizations` section of Fabric contains list of services which could be ca,concensus and orderers or ca and peers based on if the organisation is an orderer or peer type

The snapshot of ca service with example values is below
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
The fields under ca service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
|services.ca.name                             | Certificate Authority service name        |
| services.ca.subject                         | Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
| services.ca.type | Type must be `ca` for certification authority |
| services.ca.grpc.port                       | Grpc port number |


The snapshot of peer service with example values is below
```yaml
        peers:
        - peer:
          name: peer0          
          type: peer          
          gossippeeraddress: peer0.manufacturer-net:7051 # Internal Address of the other peer in same Org for gossip, same peer if there is only one peer          
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
          chaincode:
            name: "chaincode_name" #This has to be replaced with the name of the chaincode
            version: "chaincode_version" #This has to be replaced with the version of the chaincode
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
The fields under peer service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
|services.peers.peer.name                          | Name of the peer                                                                                                 |
| services.peers.peer.type                          | Type is always `peer` for Peer                                                                    |
| services.peers.peer.gossippeeraddress             | Gossip address of the peer                                                                                       |
| services.peers.peer.grpc.port                     | Grpc port                                                                                                        |
| services.peers.peer.events.port                   | Events port                                                                                                      |
| services.peers.peer.couchdb.port                  | Couchdb port                                                                                                     |
| services.peers.peer.restserver.targetPort         | Restserver target port                                                                                           |
| services.peers.peer.restserver.port               | Restserver port                                                                                                  |
| services.peers.peer.expressapi.targetPort         | Express server target port                                                                                       |
| services.peers.peer.expressapi.port               | Express server port                                                                                              |
| services.peers.peer.chaincode.name                | Name of the chaincode                                                                                            |
| services.peers.peer.chaincode.version             | Version of the chaincode                                                                                         |
| services.peers.peer.chaincode.maindirectory       | Path of main.go file                                                                                             |
| services.peers.peer.chaincode.repository.username | Username which has access to the git repo containing chaincode                                                   |
| services.peers.peer.chaincode.repository.password | Password of the user which has access to the git repo containing chaincode                                       |
| services.peer.chaincode.repository.url      | URL of the git repository containing the chaincode                                                               |
| services.peers.peer.chaincode.repository.branch   | Branch in the repository where the chaincode resides                                                             |
| servcies.peers.peer.chaincode.repository.path     | Path of the chaincode in the repository branch                                                                   |
| services.peers.peer.chaincode.arguments           | Arguments to the chaincode                                                                                       |
| services.peers.peer.chaincode.endorsements        | This could be anchor/non-anchor ** |

The snapshot of consensus service with example values is below
```yaml
        consensus:
          name: kafka
          type: broker
          replicas: 4
          grpc:
            port: 9092
```
The fields under consensus service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
|services.consensus.name                     | Name of the Consensus service                                                                            |
| service.consensus.type                      | Consensus service type, for example: broker                                                                                 |
| service.consensus.replicas                  | Replica count of the brokers                                                                                     |
| service.consensus.grpc.port                 | Grpc port of consensus service |

The snapshot of orderer service with example values is below
```yaml
        orderers:
        # This sample has multiple orderers as an example.
        # You can use a single orderer for most production implementations.
        - orderer:
          name: orderer1
          type: orderer
          consensus: kafka
          grpc:
            port: 7050
        - orderer:
          name: orderer2
          type: orderer
          consensus: kafka
          grpc:
            port: 7050 
```
The fields under orderer service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
|service.orderers.orderer.name                        | Name of the Orderer service                                                                                                     |
|service.orderers.orderer.type | This type must be `orderer`  |
| service.orderers.orderer.consensus                   | Consensus type, for example: kafka                                                                               |
| service.orderers.orderer.grpc.port                   | Grpc port of orderer                                                                                             |
| service.orderers.orderer.ca_data.url                 | Orderer url                                                                                                      |
| service.orderers.orderer.ca_data.certificate         | Path to CA certificate ***  |
