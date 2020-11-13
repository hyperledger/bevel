<a name = "adding-new-org-to-existing-network-in-corda"></a>
# Adding a new organization in R3 Corda

- [Prerequisites](#prerequisites)
- [Create configuration file](#create_config_file)
- [Running playbook to deploy R3 Corda network](#run_network)

<a name = "prerequisites"></a>
## Prerequisites
To add a new organization Corda Doorman and Networkmap services should already be running. The public certificates from Doorman and Networkmap should be available and specified in the configuration file. 

---
**NOTE**: Addition of a new organization has been tested on an existing network which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.

---

<a name = "create_config_file"></a>
## Create Configuration File

Refer [this guide](./corda_networkyaml.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organization` patch along with the network service information about the networkmap and doorman service.

---
**NOTE**: Make sure the doorman and networkmap service certificates are in plain text and not encoded in base64 or any other encoding scheme, along with correct paths to them mentioned in network.yaml.

---
For reference, sample `network.yaml` file looks like below (but always check the latest at `platforms/r3-corda/configuration/samples`):

```
network:
  # Network level configuration specifies the attributes required for each organization
  # to join an existing network.
  type: corda
  version: 4.0
  #enabled flag is frontend is enabled for nodes
  frontend: enabled
  
  #Environment section for Kubernetes setup
  env:
    type: "env_type"              # tag for the environment. Important to run multiple flux on single cluster
    proxy: ambassador               # value has to be 'ambassador' as 'haproxy' has not been implemented for Corda
    ambassadorPorts: 15010,15020    # Any additional Ambassador ports can be given here, must be comma-separated without spaces, this is valid only if proxy='ambassador'
    retry_count: 20                 # Retry count for the checks
    external_dns: enabled           # Should be enabled if using external-dns for automatic route configuration

  # Docker registry details where images are stored. This will be used to create k8s secrets
  # Please ensure all required images are built and stored in this registry. 
  # Do not check-in docker_password.
  docker:
    url: "docker_url"
    username: "docker_username"
    password: "docker_password"
  
  # Remote connection information for doorman and networkmap (will be blank or removed for hosting organization)
  network_service:
    - service:
      type: doorman
      uri: https://doorman.test.corda.blockchaincloudpoc.com:8443
      certificate: home_dir/platforms/r3-corda/configuration/build/corda/doorman/tls/ambassador.crt
    - service:
      type: networkmap
      uri: https://networkmap.test.corda.blockchaincloudpoc.com:8443
      certificate: home_dir/platforms/r3-corda/configuration/build/corda/networkmap/tls/ambassador.crt
  
  # Allows specification of one or many organizations that will be connecting to a network.
  # If an organization is also hosting the root of the network (e.g. doorman, membership service, etc),
  # then these services should be listed in this section as well.
  organizations:
    # Specification for the new organization. Each organization maps to a VPC and a separate k8s cluster
    - organization:
      name: neworg
      country: US
      state: New York
      location: New York
      subject: "O=Neworg,OU=Neworg,L=New York,C=US"
      type: node
      external_url_suffix: test.corda.blockchaincloudpoc.com
      
      cloud_provider: aws   # Options: aws, azure, gcp
      aws:
        access_key: "aws_access_key"        # AWS Access key, only used when cloud_provider=aws
        secret_key: "aws_secret_key"        # AWS Secret key, only used when cloud_provider=aws
  
      # Kubernetes cluster deployment variables. The config file path and name has to be provided in case
      # the cluster has already been created.
      k8s:
        region: "cluster_region"
        context: "cluster_context"
        config_file: "cluster_config"

      # Hashicorp Vault server address and root-token. Vault should be unsealed.
      # Do not check-in root_token
      vault:
        url: "vault_addr"
        root_token: "vault_root_token"

      # Git Repo details which will be used by GitOps/Flux.
      # Do not check-in git_password
      gitops:
        git_ssh: "gitops_ssh_url"         # Gitops ssh url for flux value files like "ssh://git@github.com/hyperledger-labs/blockchain-automation-framework.git"
        branch: "gitops_branch"           # Git branch where release is being made
        release_dir: "gitops_release_dir" # Relative Path in the Git repo for flux sync per environment. 
        chart_source: "gitops_charts"     # Relative Path where the Helm charts are stored in Git repo
        git_push_url: "gitops_push_url"   # Gitops https URL for git push like "github.com/hyperledger-labs/blockchain-automation-framework.git"
        username: "git_username"          # Git Service user who has rights to check-in in all branches
        password: "git_password"          # Git Server user password
        email: "git_email"                # Email to use in git config
        private_key: "path_to_private_key"          # Path to private key file which has write-access to the git repo

      services:
        peers:
        - peer:
          name: neworg
          subject: "O=Neworg,OU=Neworg,L=New York,C=US"
          type: node
          p2p:
            port: 10002
            targetPort: 10002
            ambassador: 10070       #Port for ambassador service (use one port per org if using single cluster)
          rpc:
            port: 10003
            targetPort: 10003
          rpcadmin:
            port: 10005
            targetPort: 10005
          dbtcp:
            port: 9101
            targetPort: 1521
          dbweb:             
            port: 8080
            targetPort: 81
          springboot:
            targetPort: 20001
            port: 20001 
          expressapi:
            targetPort: 3000
            port: 3000

```

<a name = "run_network"></a>
## Run playbook

The [add-new-organization.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/add-new-organization.yaml) playbook is used to add a new organization to the existing network. This can be done using the following command

```
ansible-playbook platforms/shared/configuration/add-new-organization.yaml --extra-vars "@path-to-network.yaml"
```

---
**NOTE:** If you have CorDapps and applications, please deploy them as well.

