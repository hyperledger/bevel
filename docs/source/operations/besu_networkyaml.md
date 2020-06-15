# Configuration file specification: Hyperledger Besu
A network.yaml file is the base configuration file designed in the Blockchain Automation Framework for setting up a Hyperledger Besu DLT network. This file contains all the configurations related to the network that has to be deployed. Below shows its structure.
![](./../_static/TopLevelClass-Besu.PNG)

Before setting up a Hyperledger Besu DLT network, this file needs to be updated with the required specifications.  
A sample configuration file is provided in the repo path:  
`platforms/hyperledger-besu/configuration/samples/network-besu.yaml` 

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

`version` defines the version of platform being used. The current Hyperledger Besu version support is only for **1.4.4**


`env` section contains the environment type and additional (other than 8443) Ambassador port configuration. Vaule for proxy field under this section can be 'ambassador' or 'haproxy'

The snapshot of the `env` section with example value is below
```yaml 
  env:
    type: "env-type"              # tag for the environment. Important to run multiple flux on single cluster
    proxy: ambassador               # value has to be 'ambassador' as 'haproxy' has not been implemented for Hyperledger Besu
    ## Any additional Ambassador ports can be given below, must be comma-separated without spaces, this is valid only if proxy='ambassador'
    #  These ports are enabled per cluster, so if you have multiple clusters you do not need so many ports
    #  This sample uses a single cluster, so we have to open 4 ports for each Node. These ports are again specified for each organization below
    ambassadorPorts: 15010,15011,15012,15013,15020,15021,15022,15023,15030,15031,15032,15033,15040,15041,15042,15043  
    retry_count: 50                # Retry count for the checks
    external_dns: enabled           # Should be enabled if using external-dns for automatic route configuration
```
The fields under `env` section are 

| Field      | Description                                 |
|------------|---------------------------------------------|
| type       | Environment type. Can be like dev/test/prod.|
| proxy      | Choice of the Cluster Ingress controller. Currently supports 'ambassador' only as 'haproxy' has not been implemented for Hyperledger Besu |
| ambassadorPorts   | Any additional Ambassador ports can be given here; must be comma-separated without spaces like `10010,10020`. This is only valid if `proxy: ambassador`. These ports are enabled per cluster, so if you have multiple clusters you do not need so many ports to be opened on Ambassador. Our sample uses a single cluster, so we have to open 4 ports for each Node. These ports are again specified in the `organization` section.     |
| retry_count       | Retry count for the checks. Use a high number if your cluster is slow. |
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
| username | Username required for login to docker registry|
| password | Password required for login to docker registry|


`config` section contains the common configurations for the Hyperledger Besu network.

The snapshot of the `config` section with example values is below
```yaml
  config:    
    consensus: "ibft"                 # Options is "ibft" only
    ## Certificate subject for the root CA of the network. 
    #  This is for development usage only where we create self-signed certificates and the truststores are generated automatically.
    #  Production systems should generate proper certificates and configure truststores accordingly.
    subject: "CN=DLT Root CA,OU=DLT,O=DLT,L=London,C=GB"
    transaction_manager: "orion"    # Option is orion only
    # This is the version of "orion" docker image that will be deployed
    # Supported versions #
    # orion: 1.5.3 (for besu 1.4.4)
    tm_version: "1.5.3"               # This is the version of "orion" docker image that will be deployed
```
The fields under `config` are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| consensus   | Currently supports `ibft`. Please update the remaining items according to the consensus chosen as not all values are valid for both the consensus.                                 |
| subject     | This is the subject of the root CA which will be created for the Hyperledger Besu network. The root CA is for development purposes only, production networks should already have the root certificates.   |
| transaction_manager    | Options is `orion`. Please update the remaining items according to the transaction_manager chosen as not all values are valid for the transaction_manager. |
| tm_version         | This is the version of `orion` docker image that will be deployed. Supported versions: `1.5.3` for `orion`. |


The `organizations` section contains the specifications of each organization.  
In the sample configuration example, we have four organization under the `organizations` section.

The snapshot of an organization field with sample values is below
```yaml
  organizations:
    # Specification for the 1st organization. Each organization maps to a VPC and a separate k8s cluster
    - organization:
      name: carrier
      external_url_suffix: test.besu.blockchaincloudpoc.com   # This is the url suffix that will be added in DNS recordset. Must be different for different clusters
      cloud_provider: aws   # Options: aws, azure, gcp, minikube
```
Each `organization` under the `organizations` section has the following fields. 

| Field                                    | Description                                 |
|------------------------------------------|-----------------------------------------------------|
| name                                        | Name of the organization     |
| external_url_suffix                         | Public url suffix of the cluster.         |
| cloud_provider                              | Cloud provider of the Kubernetes cluster for this organization. This field can be aws, azure, gcp or minikube |
| aws                                         | When the organization cluster is on AWS |
| k8s                                         | Kubernetes cluster deployment variables.|
| vault                                       | Contains Hashicorp Vault server address and root-token in the example |
| gitops                                      | Git Repo details which will be used by GitOps/Flux. |
| services                                    | Contains list of services which could ca/peer/orderers/concensus based on the type of organization |

For the `aws` and `k8s` field the snapshot with sample values is below
```yaml
      aws:
        access_key: "<aws_access_key>"    # AWS Access key, only used when cloud_provider=aws
        secret_key: "<aws_secret>"        # AWS Secret key, only used when cloud_provider=aws
  
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

The `k8s` field under each organization contains

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| context                                 | Context/Name of the cluster where the organization entities should be deployed                                   |
| config_file                             | Path to the kubernetes cluster configuration file                                                                |

For gitops fields the snapshot from the sample configuration file with the example values is below
```yaml
      # Git Repo details which will be used by GitOps/Flux.
      gitops:
        git_ssh: "git@github.com/<username>/blockchain-automation-framework.git" # Gitops ssh url for flux value files
        branch: "<branch_name>"                                                  # Git branch where release is being made
        release_dir: "platforms/hyperledger-besu/releases/dev" # Relative Path in the Git repo for flux sync per environment. 
        chart_source: "platforms/hyperledger-besu/charts"      # Relative Path where the Helm charts are stored in Git repo
        git_push_url: "github.com/<username>/blockchain-automation-framework.git" # without https://
        username: "<username>"          # Git Service user who has rights to check-in in all branches
        password: "<password>"          # Git Server user password/personal token
        email: "<git_email>"              # Email to use in git config
        private_key: "<path to gitops private key>"
```

The gitops field under each organization contains

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| git_ssh                              | SSH url of the repository where flux should be synced                                                            |
| branch                               | Branch of the repository where the Helm Charts and value files are stored                                        |
| release_dir                          | Relative path where flux should sync files                                                                       |
| chart_source                         | Relative path where the helm charts are stored                                                                   |
| git_push_url                         | Gitops https URL for git push like "github.com/hyperledger-labs/blockchain-automation-framework.git"             |
| username                             | Username which has access rights to read/write on repository                                                     |
| password                             | Password of the user which has access rights to read/write on repository                                         |
| email                                | Email of the user to be used in git config                                                                       |
| private_key                          | Path to the private key file which has write-access to the git repo                                              |

The services field for each organization under `organizations` section of Hyperledger Besu contains list of `services` which could be ony peers as of now.

Each organization with type as peer will have a peers service. The snapshot of peers service with example values is below
```yaml
        peers:
        - peer:
          name: carrier
          subject: "O=Carrier,OU=Carrier,L=51.50/-0.13/London,C=GB" # This is the node subject. L=lat/long is mandatory for supplychain sample app
          type: validator         # value can be validator or non-validator, only applicable if consensus = 'ibft'
          geth_passphrase: 12345  # Passphrase to be used to generate geth account
          p2p:
            port: 21000
            ambassador: 15010       #Port exposed on ambassador service (use one port per org if using single cluster)
          rpc:
            port: 8546
            ambassador: 15011       #Port exposed on ambassador service (use one port per org if using single cluster)
          transaction_manager:
            port: 8443          
            ambassador: 8443    
```
The fields under `peer` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name            | Name of the peer                |
| subject     | This is the alternative identity of the peer node    |
| type           | Type can be `validator` and `nonvalidator`. This is only applicable for `ibft` consensus. |
| geth_passphrase | This is the passphrase used to generate the geth account. |
| p2p.port   | P2P port for Besu|
| p2p.ambassador | The P2P Port when exposed on ambassador service|
| rpc.port   | RPC port for Besu|
| rpc.ambassador | The RPC Port when exposed on ambassador service|
| transaction_manager.port   | Port used by Transaction manager `orion`. |
| transaction_manager.ambassador | The tm port when exposed on ambassador service. |



*** feature is in future scope
