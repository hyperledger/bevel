[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Configuration file specification: Indy
A network.yaml file is the base configuration file for setting up a Indy network. This file contains all the information related to the infrastructure and network specifications. 

??? note "Schema Definition"

    A json-schema definition is provided in `platforms/network-schema.json` to assist with semantic validations and lints. You can use your favorite yaml lint plugin compatible with json-schema specification, like `redhat.vscode-yaml` for VSCode. You need to adjust the directive in template located in the first line based on your actual build directory:

    `# yaml-language-server: $schema=../platforms/network-schema.json`

The configurations are grouped in the following sections for better understanding.

* [type](#type)

* [version](#version)

* [env](#env)

* [docker](#docker)

* [name](#name)

* [genesis](#genesis)

* [organizations](#organizations)


Use this [sample configuration file](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml) as a base.
```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml:7:19"
```

<a name="type"></a>
type
: `type` defines the platform choice like corda/fabric/indy, here in example its Indy.

<a name="version"></a>
version
: `version` defines the version of platform being used, here in example the Indy version is 1.11.0 .

<a name="env"></a>
env
: `env` section contains the environment type and additional configuration. Value for proxy field under this section has to be 'ambassador' as 'haproxy' has not been implemented for Indy..


The snapshot of the `env` section with example values is below
```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml:22:34"
```

The fields under `env` section are 

| Field      | Description                                 |
|------------|---------------------------------------------|
| type       | Environment type. Can be like dev/test/prod.|
| proxy      | Choice of the Cluster Ingress controller. Currently supports 'ambassador' only as 'haproxy' has not been implemented for Indy |
|ambassadorPorts|Provide additional Ambassador ports for Identity sample app. These ports must be different from all steward ambassador ports specified in the rest of this network yaml |
| loadBalancerSourceRanges | (Optional) Restrict inbound access to a single or list of IP adresses for the public Ambassador ports to enhance Bevel network security. This is only valid if `proxy: ambassador`.  |
| retry_count       | Retry count for the checks.|
| external_dns       | If the cluster has the external DNS service, this has to be set `enabled` so that the hosted zone is automatically updated. Must be `enabled` for Identity sample app.  |

<a name="docker"></a>
docker
: `docker` section contains the credentials of the container registry where all the required images are stored.

The snapshot of the `docker` section with example values is below
```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml:36:42"
```

The fields under `docker` section are

| Field      | Description                                 |
|------------|---------------------------------------------|
| docker_url        | Docker registry url. Use private Docker registries for production network and for Identity sample app.            |
| username   | Username credential required for login      |
| password   | Password credential required for login      |

!!! tip

    Please follow [these instructions](../getting-started/configure-prerequisites.md#docker-images) to build and store the docker images before running the Ansible playbooks.
  
<a name="name"></a>
name
: `name` is used as the Indy network name (has impact e.g. on paths where the Indy nodes look for crypto files on their local filesystem)

The snapshot of the `name` section with example values is below
```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml:44:45"
```

<a name="genesis"></a>
genesis
: The `genesis` section contains Information about pool transaction genesis and domain transactions genesis. 

```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml:47:51"
```

`genesis` contains the following fields:

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| state        | State is placeholder for future, when there will be option to join to existing cluter. Currently only "absent" is supported. That means, that genesis will be always generated    |
| pool         | Path to pool transaction genesis. [Readme here](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-indy/configuration/roles/setup/pool_genesis/).    |
| domain | Path to domain transaction genesis. [Readme here](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-indy/configuration/roles/setup/domain_genesis/).      |


<a name="organizations"></a>
organizations
: The `organizations` section allows specification of one or many organizations that will be connecting to a network. If an organization is also hosting the root of the network (e.g. membership service, etc), then these services should be listed in this section as well.
 

The snapshot of an `organization` field with sample values is below
```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml:53:60"
```

Each organization under the `organizations` section has the following fields. 

| Field                                    | Description                                 |
|------------------------------------------|-----------------------------------------------------|
| name                                        | Name of the organization                              |
| type                                        | Type of organization. This field can be peer/              |
|external_url_suffix | Provide the external dns suffix. Only used when Indy webserver/Clients are deployed. external_dns should be enabled for this to work. |
| cloud_provider                              | Cloud provider of the Kubernetes cluster for this organization. This field can be aws_baremetal, aws or minikube.  |
| aws                                         | When the organization cluster is on AWS |
| publicIps                                   | List of all public IP addresses of each availability zone from all organizations in the same k8s cluster |
| k8s                                         | Kubernetes cluster deployment variables.|
| vault                                       | Contains Hashicorp Vault server address and root-token in the example |
| gitops                                      | Git Repo details which will be used by GitOps/Flux. |
| services                                    | Contains list of services which could be trustee/steward/endorser |


For the `aws`,`publicIps` and `k8s` field the snapshot with sample values is below
```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml:62:75"
```

The `aws` field under each organisation contains: (This will be ignored if cloud_provider is not 'aws')

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| access_key               | AWS Access key  |
| secret_key               | AWS Secret key  |
| encryption_key           | (optional) AWS encryption key. If present, it's used as the KMS key id for K8S storage class encryption.  |
| zone              | (optional) AWS availability zone. Applicable for Multi-AZ deployments  |
| region            | The AWS region where K8s cluster and EIPs reside |

The `publicIps` field under each organisation contains:

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| publicIps   | List of all public IP addresses of each availability zone from all organizations in the same k8s cluster |

??? note "publicIps"
    Network.yaml file consists of more organizations, where each organization can be under different availability zone. It means, that each organization has different IP. The field `publicIps` holds list of all IPs of all organizations in the same cluster. This should be in JSON Array format like ["1.1.1.1","2.2.2.2"] and must contain different IP for each availability zone on the K8s cluster i.e. If the K8s cluster is in two AZ, then two IP addresses should be provided here.

The `k8s` field under each organisation contains

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| context                                 | Context/Name of the cluster where the organization entities should be deployed                                   |
| config_file                             | Path to the kubernetes cluster configuration file                                                                |


For the `vault` field the snapshot with sample values is below
```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml:77:81"
```

The `vault` field under each organisation contains:

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| url                              | Vault server  |
| root_token                              | Vault root token  |

For  `gitops` fields the snapshot from the sample configuration file with the example values is below
```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml:83:95"
```

The `gitops` field under each organization contains

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
| private_key                          | Path to the private key file which has write-access to the git repo  (Optional for https; Required for ssh)    |


The services field for each organization under `organizations` section of Indy contains list of `services` which could be trustee/steward/endorser

The snapshot of `trustee` service with example values is below
```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml:97:106"
```

The fields under `trustee` service are
| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name            | Name for the trustee service                 |
| genesis         | If using domain and pool transaction genesis. `true` for current implementation  |
| server.port  | Applicable for Identity Sample App. This is the Indy webserver container port |
| server.ambassador  | Applicable for Identity Sample App. This is the Indy webserver ambassador port which will be exposed publicly using the external URL. |

The snapshot of `steward` service example values is below
```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml:150:170"
```

The fields under `steward` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name                | Name of the steward service                     |
| type      | type VALIDATOR/OBSERVER for steward service. Currenty only VALIDATOR type is supported. Validators are trusted parties who validate identities and transactions in a distributed fashion. They validate identities by the private key of the identity validator. An outside party can also verify claims using the public key of the validator. Observer nodes may be required as the network scales. From the perspective of Indy clients, an observer node is a read-only copy of the Sovrin ledger performing three functions (Read requests, Hot stanbys, Push subscriptions) |
| genesis              | If using domain and pool transaction genesis. |
| publicIp                    | Public Ip of service   |
| node.port       | HTTP node port number                                       |
| node.targetPort        | HTTP target node port number                                |
| node.ambassador                     | HTTP node port number of ambassador |
| client.port       |HTTP client port number                                       |
| client.targetPort        | HTTP client target port number                                   |
| client.ambassador                     | HTTP client port number of ambassador |


The snapshot of `endorser` service with example values is below
```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml:152:152"
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indyv3.yaml:184:195"
```

The fields under `endorser` service are 

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name                     | Name of the endorser service   |
| full_name                   | Full name of endorser service |
| avatar                      | Link to avatar. Not used now.  |
| server.httpPort  | Applicable for Identity Sample App. This is the Endorser Agent's Web port which will be exposed publicly using the external URL.  |
| server.apiPort  | Applicable for Identity Sample App. This is the Endorser Agent's API/Swagger port which will be exposed publicly using the external URL.  |
| server.webhookPort  | Applicable for Identity Sample App. This is the Endorser Agent's API/Swagger port which will be exposed publicly using the external URL.  |
