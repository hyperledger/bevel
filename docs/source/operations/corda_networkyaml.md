# Configuration file specification: R3 Corda
A network.yaml file is the base configuration file for setting up a Corda DLT network. This file contains all the information related to the infrastructure and network specifications. Here is the structure of it.
![](./../_static/TopLevelClass.png)

Before setting up a Corda DLT network, this file needs to be updated with the required specifications.
The configurations are grouped in the following sections for better understanding.

* type

* version

* frontend

* env

* docker

* orderers

* organizations

`type` defines the platform choice like corda/fabric.

`version` defines the version of platform being used.

`frontend` is a flag which defines if frontend is enabled for nodes or not. Its value can only be enabled/disabled. This is only applicable if the sample Supplychain App is being installed.

`env` section contains the environment type and additional (other than 8443) Ambassador port configuration.

| Field      | Description                                 |
|------------|---------------------------------------------|
| type       | Environment type. Can be like dev/test/prod.|
| ambassadorPorts   | Any additional Ambassador ports can be given here; must be comma-separated without spaces like `10010,10020`.      |


`docker` section contains the credentials of the repository where all the required images are built and stored.
(Note: Please use the [NMS Jenkins file](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/automation/r3-corda/NMS.Jenkinsfile) or/and [Doorman Jenkins file](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/automation/r3-corda/Doorman.Jenkinsfile) to build and store the docker images before running the Ansible playbooks)

| Field      | Description                                 |
|------------|---------------------------------------------|
| url        | Docker registry url                         | 
| username   | Username credential required for login      |
| password   | Password credential required for login      |

---
**NOTE:** Please follow [these instructions](../operations/configure_prerequisites.md#docker) to build and store the docker images before running the Ansible playbooks.

---


`orderers` section contains a list of doorman/networkmap which is exposed to the network.

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name        | Name of the orderer                                      |
| type        | For Corda, `networkmap` and `doorman` are the only valid type of orderers.   |
| uri         | Doorman/Networkmap external URL. This should be reachable from all nodes.| 
| certificate | Directory path of custom certificates for Doorman and Networkmap. |


`organizations` section contains the specifications of each organization.

| Field                                    | Description                                 |
|------------------------------------------|-----------------------------------------------------|
| name                                        | Name of the organization                                                                                         |
| country                                     | Country of the organization                                                                                      |
| state                                       | State of the organization                                                                                        |
| location                                    |  Location of the organization                                                                                    |
| subject                                     | Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
| type                                        | This field can be doorman/nms/notary/peer               |
| external_url_suffix                         | Public url suffix of the cluster. This is the configured path for the Ambassador Service on the DNS provider.|
| cloud_provider                              | Clod provider of the Kubernetes cluster for this organization. This field can be aws, azure or gcp |
| aws.access_key                              | AWS Access key; when the organization cluster is on AWS                                                        |
| aws.secret_key                              | AWS Secret key; when the organization cluster is on AWS                                                      |
| k8s.region                              | Region where the Kubernetes cluster is deployed        |
| k8s.context                                 | Context/Name of the cluster where the organization entities should be deployed                                        |
| k8s.config_file                             | Path to the kubernetes cluster configuration file                                                                |
| vault.url                                   | Unsealed Hashicorp Vault URL                                                                                     |
| vault.root_token                            | Hashicorp Vault root token for the above Vault                                                                           |
| gitops.git_ssh                              | SSH url of the repository where flux should be synced                                                            |
| gitops.branch                               | Branch of the repository where the Helm Charts and value files are stored                                        |
| gitops.release_dir                          | Relative path where flux should sync files                                                                       |
| gitops.chart_source                         | Relative path where the helm charts are stored                                                                   |
| gitops.git_push_url                         | Gitops https URL for git push like "github.com/hyperledger-labs/blockchain-automation-framework.git"                 |
| gitops.username                             | Username which has access rights to read/write on repository                                                     |
| gitops.password                             | Password of the user which has access rights to read/write on repository                                          |
| gitops.private_key | Path to the private key file which has write-access to the git repo|
| services.doorman. name            | Name for the Doorman service                                                                                 |
| services.doorman.subject                    | Certificate Subject for Doorman service. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
| services.doorman.type                       | Service type must be `doorman`                                                                             |
| services.doorman.ports.servicePort          | HTTP port number where doorman service is accessible                                       |
| services.doorman.ports.targetPort          | HTTP target port number of the doorman docker-container                                       |
| services.nms. name                | Name of the NetworkMap service                     |
| services.nms.subject      | Certificate Subject for NetworkMap service. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
| services.nms.type                    | Service type must be `networkmap`    |
| services.nms.ports.servicePort       | HTTP port number where NetworkMap service is accessible                                       |
| services.nms.ports.targetPort          | HTTP target port number of the NetworkMap docker-container                                  |
| services.notary. name                      | Name of the notary service   |
| services.notary.subject                   | Certificate Subject for notary service. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
| services.notary.type                      | Service type must be `notary`  |
| services.notary.p2p.port                  | Corda Notary P2P port. Used for communication between the notary and nodes of same network|
| services.notary.p2p.targetport            | P2P Port where notary service is running. |
| services.notary.p2p.ambassadorport        | Port where notary service is exposed via Ambassador|
| services.notary.rpc.port                  | Corda Notary RPC port. Used for communication between the notary and nodes of same network|
| services.notary.rpc.targetport            | RPC Port where notary services is running.|
| services.notary.rpcadmin.port             | Corda Notary Rpcadmin port. Used for RPC admin binding|
| services.notary.dbtcp.port                | Corda Notary DbTcp port. Used to expose database to other services                                           |
| services.notary.dbtcp.targetPort          | Corda Notary DbTcp target port. Port where the database services are running                               |
| services.notary.dbweb.port                | Corda Notary dbweb port. Used to expose dbweb to other services                                                    |
| services.notary.dbweb.targetPort          | Corda Notary dbweb target port. Port where the dbweb services are running                                        |
| services.peer. name                          | Name of the Corda Node                                                                                           |
| services.peer.type                          | Service type must be `node` |
| services.peer.subject                       | The node legal name subject. |
| services.peer.auth                          | Vault auth of the corda Node                                                                                     |
| services.peer.p2p.port                      | Corda Node P2P port.Used for communication between the nodes  of same network                                    |
| services.peer.rpc.port                      | Corda Node RPC port. Used for communication between the nodes of different network                               |
| services.peer.rpcadmin.port                 | Corda Node Rpcadmin port. Used for RPC admin binding                                                             |
| services.peer.dbtcp.port                    | Corda Node DbTcp port. Used to expose database to other services                                           |
| services.peer.dbtcp.targetPort              | Corda Node DbTcp target port. Port where the database services are running                               |
| services.peer.dbweb.port                    | Corda Node dbweb port. Used to expose dbweb to other services                                                    |
| services.peer.dbweb.targetPort              | Corda Node dbweb target port. Port where the dbweb services are running                                        |
| services.peer.springboot.port               | Springboot server port. Used to expose springboot to other    services                                           |
| services.peer.springboot.targetPort         | Springboot server  target port. Port where the springboot services are running                               |
| services.peer.expressapi.port               | Expressapi port. Used to expose expressapi to other services                                                     |
| services.peer.expressapi.targetPort         | Expressapi target port. Port where the expressapi services are running                                        |
