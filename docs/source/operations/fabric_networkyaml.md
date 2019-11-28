# Configuration file specification: Hyperledger-Fabric
A network.yaml file is the base configuration file designed in the Blockchain Automation Framework for setting up a Fabric DLT network. This file contains all the information related to the infrastructure and network specifications. Below shows its structure.
![](./../_static/TopLevelClass.png)

Before setting up a Fabric DLT network, this file needs to be updated with the required specifications.
The configurations are grouped in the following sections for better understanding.

* type

* version

* docker

* frontend

* orderers

* channels

* organizations

`type` defines the platform information viz corda/fabric.
`version` defines the version of platform being used.
`frontend` is a flag which defines if frontend is enabled for nodes or not. Its value can only be enabled/disabled.

`docker` section contains the credentials of the repository where all the required images are built and stored.

| Field    | Description                            |
|----------|----------------------------------------|
| url      | Docker registry url                    |
| username | Username credential required for login |
| password | Password credential required for login |

`orderers` section contains a list of orderers with variables which will expose it for the network.

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name        | Name of the orderer                                      |
| org_name    | Name of the organization to which this orderer belong to |
| uri         | Orderer URL                                              |
| certificate | Path to orderer certificate for connection by external organizations |

`channels` sections contains the list of channels mentioning the participating peers of the organizations.

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

| Field                                       | Description                                                                                                      |
|---------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| name                                        | Name of the organization                                                                                         |
| country                                     | Country of the organization                                                                                      |
| state                                       | State of the organization                                                                                        |
| location                                    |  Location of the organization                                                                                    |
| subject                                     | Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
| type                                        | This field can be orderer/peer                                                                                   |
| external_url_suffix                         | Public url of the cluster                                                                                        |
| ca_data.url                            | Certificate Authority url                                                                                                  |
| ca_data.certificate                    | Path to public certificate of CA ***                                                                                            |
| cloud_provider                              | This field can be aws,azure or gcp                                                                               |
| aws.access_key                              | Access key when the organization is based on aws cluster                                                         |
| aws.secret_key                              | Secret key when the organization is based on aws cluster                                                         |
| k8s.provider                                | This field can be EKS/AKS/GKE                                                                                    |
| k8s.region                                  | Region where the cluster has been deployed                                                                           |
| k8s.context                                 | Context of the cluster where the organization entities should be deployed                                        |
| k8s.config_file                             | Path to the kubernetes cluster configuration file                                                                |
| vault.url                                   | Unsealed Hashicorp Vault URL                                                                                     |
| vault.root_token                            | Unsealed Hashicorp Vault root token                                                                              |
| gitops.git_ssh                              | SSH url of the repository where flux should be synced                                                            |
| gitops.branch                               | Branch of the repository where the Helm Charts and value files are stored                                        |
| gitops.release_dir                          | Relative path where flux should sync files                                                                       |
| gitops.chart_source                         | Relative path where the helm charts are stored                                                                   |
| gitops.git_push_url                         | Gitops https URL for git push like "github.com/hyperledger-labs/blockchain-automation-framework.git"                          |
| gitops.username                             | Username which has access rights to read/write on repository                                                     |
| gitops.password                             | Password of the use which has access rights to read/write on repository                                          |
| services.ca.name                            | Certificate Authority name                                                                                       |
| services.ca.subject                         | Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
| services.ca.grpc.port                       | Grpc port number                                                                                                 |
| services.peer.name                          | Name of the peer                                                                                                 |
| services.peer.type                          | This field can be validating/non-validating *                                                                    |
| services.peer.gossippeeraddress             | Gossip address of the peer                                                                                       |
| services.peer.grpc.port                     | Grpc port                                                                                                        |
| services.peer.events.port                   | Events port                                                                                                      |
| services.peer.couchdb.port                  | Couchdb port                                                                                                     |
| services.peer.restserver.targetPort         | Restserver target port                                                                                           |
| services.peer.restserver.port               | Restserver port                                                                                                  |
| services.peer.expressapi.targetPort         | Express server target port                                                                                       |
| services.peer.expressapi.port               | Express server port                                                                                              |
| services.peer.chaincode.name                | Name of the chaincode                                                                                            |
| services.peer.chaincode.version             | Version of the chaincode                                                                                         |
| services.peer.chaincode.maindirectory       | Path of main.go file                                                                                             |
| services.peer.chaincode.repository.username | Username which has access to the git repo containing chaincode                                                   |
| services.peer.chaincode.repository.password | Password of the user which has access to the git repo containing chaincode                                       |
| services.peer.chaincode.repository.url      | URL of the git repository containing the chaincode                                                               |
| services.peer.chaincode.repository.branch   | Branch in the repository where the chaincode resides                                                             |
| servcies.peer.chaincode.repository.path     | Path of the chaincode in the repository branch                                                                   |
| services.peer.chaincode.arguments           | Arguments to the chaincode                                                                                       |
| services.peer.chaincode.endorsements        | This could be anchor/non-anchor **                                                                               |
| services.consensus.name                     | Consensus service, for example: kafka                                                                            |
| service.consensus.type                      | Server name, for example: broker                                                                                 |
| service.consensus.replicas                  | Replica count of the servers                                                                                     |
| service.consensus.grpc.port                 | Grpc port of consensus service                                                                                   |
| service.orderer.name                        | Orderer name                                                                                                     |
| service.orderer.consensus                   | Consensus name, for example: kafka                                                                               |
| service.orderer.grpc.port                   | Grpc port of orderer                                                                                             |
| service.orderer.ca_data.url                 | Orderer url                                                                                                      |
| service.orderer.ca_data.certificate         | Path to CA certificate ***                                                                                                        |

\* non-validating feature is in future scope<br>
** non-anchor feature is in future scope<br>
*** feature is in future scope