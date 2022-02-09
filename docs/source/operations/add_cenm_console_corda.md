[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "adding-new-org-to-existing-network-in-corda"></a>
# Adding a CENM Management Console in R3 Corda

- [Prerequisites](#prerequisites)
- [Modify configuration file](#modify-configuration-file)

<a name = "prerequisites"></a>
## Prerequisites
To add CENM management console, Auth service that has been setup with atleast one user (an admin user), Zone service and Gateway services should already be installed and running.

The Helm Chart for Auth service is available [here](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/auth).  
The Helm Chart for Zone service is available [here](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/zone).  
The Helm Chart for Gateway service is available [here](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/gateway).

---
**NOTE**: Addition of a cenm management console has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

---

<a name = "modify_config_file"></a>
## Modify Configuration File

Refer [this guide](./corda_networkyaml.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `services.auth`, `services.zone` and `services.gateway` details along with the network service information about the networkmap and doorman service.

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
    type: "env_type"                # tag for the environment. Important to run multiple flux on single cluster
    proxy: ambassador               # value has to be 'ambassador' as 'haproxy' has not been implemented for Corda
    ambassadorPorts:                # Any additional Ambassador ports can be given here, this is valid only if proxy='ambassador'
      portRange:              # For a range of ports 
        from: 15010 
        to: 15043
    # ports: 15020,15021      # For specific ports
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
        git_protocol: "https" # Option for git over https or ssh
        git_url: "gitops_ssh_url"         # Gitops https or ssh url for flux value files like "https://github.com/hyperledger/bevel.git"
        branch: "gitops_branch"           # Git branch where release is being made
        release_dir: "gitops_release_dir" # Relative Path in the Git repo for flux sync per environment. 
        chart_source: "gitops_charts"     # Relative Path where the Helm charts are stored in Git repo
        git_repo: "gitops_repo_url"   # Gitops git repository URL for git push like "github.com/hyperledger/bevel.git"
        username: "git_username"          # Git Service user who has rights to check-in in all branches
        password: "git_password"          # Git Server user access token (Optional for ssh; Required for https)
        email: "git_email"                # Email to use in git config
        private_key: "path_to_private_key"          # Path to private key file which has write-access to the git repo (Optional for https; Required for ssh)

      services:
        zone:
          name: zone
          type: cenm-zone
          ports:
            enm: 25000
            admin: 12345
        auth:
          name: auth
          subject: "CN=Test TLS Auth Service Certificate, OU=HQ, O=HoldCo LLC, L=New York, C=US"
          type: cenm-auth
          port: 8081
          username: admin
          userpwd: p4ssWord
        gateway:
          name: gateway
          subject: "CN=Test TLS Gateway Certificate, OU=HQ, O=HoldCo LLC, L=New York, C=US"
          type: cenm-gateway
          ports: 
            servicePort: 8080
            ambassadorPort: 15008

```

<a name = "access-console"></a>
## Access CENM Management Console

The detailed steps to access the CENM Management console is given [here](https://docs.r3.com/en/platform/corda/1.5/cenm/cenm-console.html)
