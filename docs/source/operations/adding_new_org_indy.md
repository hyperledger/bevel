[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "adding-new-org-to-existing-network-in-indy"></a>
# Adding a new validator organization in Indy

  - [Prerequisites](#prerequisites)
  - [Add a new validator organization to a Bevel managed network](#add-new-org-bevel)
    - [Create Configuration File](#create-configuration-file-bevel)
    - [Run playbook](#run-playbook-bevel)
  - [Add a new validator organization to network managed outside of Bevel](#add-new-org-non-bevel)
    - [Create Configuration File](#create-configuration-file-non-bevel)
    - [Run playbook up-to genesis config map creation](#run-playbook-up-to-config-map-non-bevel)
    - [Provide public STEWARD identity crypto to network manager](#provide-public-crypto-non-bevel)
    - [Run rest of playbook](#run-rest-playbook-non-bevel)

<a name = "prerequisites"></a>
## Prerequisites
To add a new organization in Indy, an existing Indy network should be running, pool and domain genesis files should be available.

---

**NOTE**: The guide is only for the addition of VALIDATOR Node in existing Indy network.

---

<a name = "add-new-org-bevel"></a>
## Add a new validator organization to a Bevel managed network

<a name = "create-configuration-file-bevel"></a>
### Create Configuration File

Refer [this guide](./indy_networkyaml.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organization` details.

---
**NOTE**: If you are adding node to the same cluster as of another node, make sure that you add the ambassador ports of the existing node present in the cluster to the network.yaml

---
For reference, sample `network.yaml` file looks like below (but always check the latest network-indy-newnode-to-bevel-network.yaml at `platforms/hyperledger-indy/configuration/samples`):

```
---
# This is a sample configuration file for hyperledger indy which can be reused for adding of new org with 1 validator node to a fully Bevel managed network.
# It has 2 organizations:
# 1. existing organization "university" with 1 trustee, 4 stewards and 1 endorser
# 2. new organization "bank" with 1 trustee, 1 steward and 1 endorser

network:
  # Network level configuration specifies the attributes required for each organization
  # to join an existing network.
  type: indy
  version: 1.11.0                         # Supported versions 1.11.0 and 1.12.1

  #Environment section for Kubernetes setup
  env:
    type: indy             # tag for the environment. Important to run multiple flux on single cluster
    proxy: ambassador               # value has to be 'ambassador' as 'haproxy' has not been implemented for Indy
    ambassadorPorts:
      portRange:              # For a range of ports
        from: 9711
        to: 9720
    loadBalancerSourceRanges: # (Optional) Default value is '0.0.0.0/0', this value can be changed to any other IP adres or list (comma-separated without spaces) of IP adresses, this is valid only if proxy='ambassador'
    retry_count: 40                 # Retry count for the checks
    external_dns: enabled           # Should be enabled if using external-dns for automatic route configuration

  # Docker registry details where images are stored. This will be used to create k8s secrets
  # Please ensure all required images are built and stored in this registry.
  # Do not check-in docker_password.
  docker:
    url: "ghcr.io/hyperledger"
    username: "docker_username"
    password: "docker_password"

  # It's used as the Indy network name (has impact e.g. on paths where the Indy nodes look for crypto files on their local filesystem)
  name: bevel

  # Information about pool transaction genesis and domain transactions genesis
  # All the fields below in the genesis section are MANDATORY
  genesis:
    state: present              # must be present when add_new_org is true
    pool: /path/to/pool_transactions_genesis         # path where pool_transactions_genesis from existing network has been stored locally
    domain: /path/to/domain_transactions_genesis     # path where domain_transactions_genesis from existing has been stored locally

  # Allows specification of one or many organizations that will be connecting to a network.
  organizations:
  - organization:
    name: university
    type: peer
    org_status: existing # Status of the organization for the existing network, can be new / existing
    cloud_provider: aws
    external_url_suffix: indy.blockchaincloudpoc.com  # Provide the external dns suffix. Only used when Indy webserver/Clients are deployed.

    aws:
      access_key: "aws_access_key"            # AWS Access key
      secret_key: "aws_secret_key"            # AWS Secret key
      encryption_key: "encryption_key_id"     # AWS encryption key. If present, it's used as the KMS key id for K8S storage class encryption.
      zone: "availability_zone"               # AWS availability zone
      region: "region"                        # AWS region

    publicIps: ["3.221.78.194"]             # List of all public IP addresses of each availability zone from all organizations in the same k8s cluster

    # Kubernetes cluster deployment variables. The config file path has to be provided in case
    # the cluster has already been created.
    k8s:
      config_file: "/path/to/cluster_config"
      context: "kubernetes-admin@kubernetes"

    # Hashicorp Vault server address and root-token. Vault should be unsealed.
    # Do not check-in root_token
    vault:
      url: "vault_addr"
      root_token: "vault_root_token"

    # Git Repo details which will be used by GitOps/Flux.
    # Do not check-in git_access_token
    gitops:
      git_protocol: "https" # Option for git over https or ssh
      git_url: "https://github.com/<username>/bevel.git"                 # Gitops https or ssh url for flux value files
      branch: "develop"                   # Git branch where release is being made
      release_dir: "platforms/hyperledger-indy/releases/dev"         # Relative Path in the Git repo for flux sync per environment.
      chart_source: "platforms/hyperledger-indy/charts"             # Relative Path where the Helm charts are stored in Git repo
      git_repo: "github.com/<username>/bevel.git"           # Gitops git repository URL for git push
      username: "git_username"                  # Git Service user who has rights to check-in in all branches
      password: "git_access_token"                  # Git Server user password
      email: "git@email.com"                        # Email to use in git config
      private_key: "path_to_private_key"        # Path to private key file which has write-access to the git repo (Optional for https; Required for ssh)

    # Services maps to the pods that will be deployed on the k8s cluster
    # This sample has trustee, 2 stewards and endoorser
    services:
      trustees:
      - trustee:
        name: university-trustee
        genesis: true
      stewards:
      - steward:
        name: university-steward-1
        type: VALIDATOR
        genesis: true
        publicIp: 3.221.78.194        # IP address of current organization in current availability zone
        node:
          port: 9713
          targetPort: 9713
          ambassador: 9713            # Port for ambassador service
        client:
          port: 9714
          targetPort: 9714
          ambassador: 9714            # Port for ambassador service
      - steward:
        name: university-steward-2
        type: VALIDATOR
        genesis: true
        publicIp: 3.221.78.194        # IP address of current organization in current availability zone
        node:
          port: 9715
          targetPort: 9715
          ambassador: 9715            # Port for ambassador service
        client:
          port: 9716
          targetPort: 9716
          ambassador: 9716            # Port for ambassador service
      - steward:
        name: university-steward-3
        type: VALIDATOR
        genesis: true
        publicIp: 3.221.78.194        # IP address of current organization in current availability zone
        node:
          port: 9717
          targetPort: 9717
          ambassador: 9717            # Port for ambassador service
        client:
          port: 9718
          targetPort: 9718
          ambassador: 9718            # Port for ambassador service
      - steward:
        name: university-steward-4
        type: VALIDATOR
        genesis: true
        publicIp: 3.221.78.194        # IP address of current organization in current availability zone
        node:
          port: 9719
          targetPort: 9719
          ambassador: 9719            # Port for ambassador service
        client:
          port: 9720
          targetPort: 9720
          ambassador: 9720            # Port for ambassador service
      endorsers:
      - endorser:
        name: university-endorser
        full_name: Some Decentralized Identity Mobile Services Partner
        avatar: http://university.com/avatar.png
        # public endpoint will be {{ endorser.name}}.{{ external_url_suffix}}:{{endorser.server.httpPort}}
        # Eg. In this sample http://university-endorser.indy.blockchaincloudpoc.com:15033/
        # For minikube: http://<minikubeip>>:15033
        server:
          httpPort: 15033
          apiPort: 15034
          webhookPort: 15035
  - organization:
    name: bank
    type: peer
    org_status: new # Status of the organization for the existing network, can be new / existing
    cloud_provider: aws
    external_url_suffix: indy.blockchaincloudpoc.com  # Provide the external dns suffix. Only used when Indy webserver/Clients are deployed.

    aws:
      access_key: "aws_access_key"            # AWS Access key
      secret_key: "aws_secret_key"            # AWS Secret key
      encryption_key: "encryption_key_id"     # AWS encryption key. If present, it's used as the KMS key id for K8S storage class encryption.
      zone: "availability_zone"               # AWS availability zone
      region: "region"                        # AWS region

    publicIps: ["3.221.78.194"]               # List of all public IP addresses of each availability zone from all organizations in the same k8s cluster                        # List of all public IP addresses of each availability zone

    # Kubernetes cluster deployment variables. The config file path has to be provided in case
    # the cluster has already been created.
    k8s:
      config_file: "/path/to/cluster_config"
      context: "kubernetes-admin@kubernetes"

    # Hashicorp Vault server address and root-token. Vault should be unsealed.
    # Do not check-in root_token
    vault:
      url: "vault_addr"
      root_token: "vault_root_token"

    # Git Repo details which will be used by GitOps/Flux.
    # Do not check-in git_access_token
    gitops:
      git_protocol: "https" # Option for git over https or ssh
      git_url: "https://github.com/<username>/bevel.git"                   # Gitops https or ssh url for flux value files
      branch: "develop"                     # Git branch where release is being made
      release_dir: "platforms/hyperledger-indy/releases/dev"           # Relative Path in the Git repo for flux sync per environment.
      chart_source: "platforms/hyperledger-indy/charts"               # Relative Path where the Helm charts are stored in Git repo
      git_repo: "github.com/<username>/bevel.git"             # Gitops git repository URL for git push
      username: "git_username"                    # Git Service user who has rights to check-in in all branches
      password: "git_access_token"                    # Git Server user password
      email: "git@email.com"                          # Email to use in git config
      private_key: "path_to_private_key"          # Path to private key file which has write-access to the git repo (Optional for https; Required for ssh)

    # Services maps to the pods that will be deployed on the k8s cluster
    # This sample has trustee, 2 stewards and endoorser
    services:
      trustees:
      - trustee:
        name: bank-trustee
        genesis: true
      stewards:
      - steward:
        name: bank-steward-1
        type: VALIDATOR
        genesis: true
        publicIp: 3.221.78.194    # IP address of current organization in current availability zone
        node:
          port: 9711
          targetPort: 9711
          ambassador: 9711        # Port for ambassador service
        client:
          port: 9712
          targetPort: 9712
          ambassador: 9712        # Port for ambassador service
      endorsers:
      - endorser:
        name: bank-endorser
        full_name: Some Decentralized Identity Mobile Services Provider
        avatar: http://bank.com/avatar.png


```
Following items must be added/updated to the network.yaml used to add new organizations

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| genesis.state  | Must be `present` for add org  |
| genesis.pool | Path to Pool Genesis file of the existing Indy network.|
| genesis.domain | Path to Domain Genesis file of the existing Indy network.|


Also, ensure that `organization.org_status` is set to `existing` for existing orgs and `new` for the new org.

<a name = "run-playbook-bevel"></a>
### Run playbook

The [add-new-organization.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/add-new-organization.yaml) playbook is used to add a new organization to the existing Bevel managed network by running the following command

```
ansible-playbook platforms/shared/configuration/add-new-organization.yaml -e "@path-to-network.yaml"
```

<a name = "add-new-org-non-bevel"></a>
## Add a new validator organization to network managed outside of Bevel

<a name = "create-configuration-file-non-bevel"></a>
### Create Configuration File

Refer [this guide](./indy_networkyaml.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organization` details.

For reference, sample `network.yaml` file looks like below (but always check the latest network-indy-newnode-to-non-bevel-network.yaml at `platforms/hyperledger-indy/configuration/samples`):

```
---
# This is a sample configuration file for hyperledger indy which can be reused for adding of new org with 1 validator node to an existing non-Bevel managed network.
# It has 1 organization:
# - new organization "bank" with 1 steward and 1 endorser

network:
  # Network level configuration specifies the attributes required for each organization
  # to join an existing network.
  type: indy
  version: 1.11.0                         # Supported versions 1.11.0 and 1.12.1

  #Environment section for Kubernetes setup
  env:
    type: indy             # tag for the environment. Important to run multiple flux on single cluster
    proxy: ambassador               # value has to be 'ambassador' as 'haproxy' has not been implemented for Indy
    ambassadorPorts:
      portRange:              # For a range of ports
        from: 9711
        to: 9712
    loadBalancerSourceRanges: # (Optional) Default value is '0.0.0.0/0', this value can be changed to any other IP adres or list (comma-separated without spaces) of IP adresses, this is valid only if proxy='ambassador'
    retry_count: 40                 # Retry count for the checks
    external_dns: enabled           # Should be enabled if using external-dns for automatic route configuration

  # Docker registry details where images are stored. This will be used to create k8s secrets
  # Please ensure all required images are built and stored in this registry.
  # Do not check-in docker_password.
  docker:
    url: "ghcr.io/hyperledger"
    username: "docker_username"
    password: "docker_password"

  # It's used as the Indy network name (has impact e.g. on paths where the Indy nodes look for crypto files on their local filesystem)
  name: bevel

  # Information about pool transaction genesis and domain transactions genesis
  # All the fields below in the genesis section are MANDATORY
  genesis:
    state: present              # must be present when add_new_org is true
    pool: /path/to/pool_transactions_genesis         # path where pool_transactions_genesis from existing network has been stored locally
    domain: /path/to/domain_transactions_genesis     # path where domain_transactions_genesis from existing has been stored locally

  # Allows specification of one or many organizations that will be connecting to a network.
  organizations:
  - organization:
    name: bank
    type: peer
    org_status: new # Status of the organization for the existing network, can be new / existing
    cloud_provider: aws
    external_url_suffix: indy.blockchaincloudpoc.com  # Provide the external dns suffix. Only used when Indy webserver/Clients are deployed.

    aws:
      access_key: "aws_access_key"            # AWS Access key
      secret_key: "aws_secret_key"            # AWS Secret key
      encryption_key: "encryption_key_id"     # AWS encryption key. If present, it's used as the KMS key id for K8S storage class encryption.
      zone: "availability_zone"               # AWS availability zone
      region: "region"                        # AWS region

    publicIps: ["3.221.78.194"]               # List of all public IP addresses of each availability zone from all organizations in the same k8s cluster                        # List of all public IP addresses of each availability zone

    # Kubernetes cluster deployment variables. The config file path has to be provided in case
    # the cluster has already been created.
    k8s:
      config_file: "/path/to/cluster_config"
      context: "kubernetes-admin@kubernetes"

    # Hashicorp Vault server address and root-token. Vault should be unsealed.
    # Do not check-in root_token
    vault:
      url: "vault_addr"
      root_token: "vault_root_token"

    # Git Repo details which will be used by GitOps/Flux.
    # Do not check-in git_access_token
    gitops:
      git_protocol: "https" # Option for git over https or ssh
      git_url: "https://github.com/<username>/bevel.git"                   # Gitops https or ssh url for flux value files
      branch: "develop"                     # Git branch where release is being made
      release_dir: "platforms/hyperledger-indy/releases/dev"           # Relative Path in the Git repo for flux sync per environment.
      chart_source: "platforms/hyperledger-indy/charts"               # Relative Path where the Helm charts are stored in Git repo
      git_repo: "github.com/<username>/bevel.git"             # Gitops git repository URL for git push
      username: "git_username"                    # Git Service user who has rights to check-in in all branches
      password: "git_access_token"                    # Git Server user password
      email: "git@email.com"                          # Email to use in git config
      private_key: "path_to_private_key"          # Path to private key file which has write-access to the git repo (Optional for https; Required for ssh)

    # Services maps to the pods that will be deployed on the k8s cluster
    # This sample has trustee, 2 stewards and endoorser
    services:
      stewards:
      - steward:
        name: bank-steward-1
        type: VALIDATOR
        genesis: true
        publicIp: 3.221.78.194    # IP address of current organization in current availability zone
        node:
          port: 9711
          targetPort: 9711
          ambassador: 9711        # Port for ambassador service
        client:
          port: 9712
          targetPort: 9712
          ambassador: 9712        # Port for ambassador service
      endorsers:
      - endorser:
        name: bank-endorser
        full_name: Some Decentralized Identity Mobile Services Provider
        avatar: http://bank.com/avatar.png

```

Following items must be added/updated to the network.yaml used to add new organizations

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| genesis.state  | Must be `present` for add org  |
| genesis.pool | Path to Pool Genesis file of the existing Indy network.|
| genesis.domain | Path to Domain Genesis file of the existing Indy network.|


Also, ensure that `organization.org_status` is set to `new` for the new org.

<a name = "run-playbook-up-to-config-map-non-bevel"></a>
### Run playbook up-to genesis config map creation

The [add-new-organization.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/add-new-organization.yaml) playbook is used with additional parameters specifying that a TRUSTEE identity is not present in the network configuration file and also NYMs (identities) of the new organization are not yet present on the domain ledger. This is achieved by running the following command

```
ansible-playbook platforms/shared/configuration/add-new-organization.yaml -e "@path-to-network.yaml" \
                                                                          -e "add_new_org_network_trustee_present=false" \
                                                                          -e "add_new_org_new_nyms_on_ledger_present=false"
```

<a name = "provide-public-crypto-non-bevel"></a>
### Provide public STEWARD identity crypto to network manager

Share the following public crypto with an organization admin (TRUSTEE identity owner), check full Vault structure [here](../architectureref/certificates_path_list_indy.md).

| Path                | Key (for Vault)                        | Type             |
|-----------------------------------|--------------------------|------------------|
| /`org_name_lowercase`/stewards/`steward_name_lowercase`/identity/public/             | did                 | String           |
| /`org_name_lowercase`/stewards/`steward_name_lowercase`/node/public/verif_keys/      | verification-key                       | Verification Key |

Please wait for the organization admin to confirm that the identity has been added to the domain ledger with a STEWARD role until you proceed with the final step.

<a name = "run-rest-playbook-non-bevel"></a>
### Run rest of playbook

The [add-new-organization.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/add-new-organization.yaml) playbook is used with additional parameters specifying that a TRUSTEE identity is not present in the network configuration file and also NYMs (identities) of the new organization are already present on the domain ledger. This is achieved by running the following command

```
ansible-playbook platforms/shared/configuration/add-new-organization.yaml -e "@path-to-network.yaml" \
                                                                          -e "add_new_org_network_trustee_present=false" \
                                                                          -e "add_new_org_new_nyms_on_ledger_present=true"
```
