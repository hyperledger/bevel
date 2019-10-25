<a name = "adding-new-org-to-existing-network-in-corda"></a>
# Adding new organization to existing network in R3 Corda

- [Modifying configuration file](#create_config_file)
- [Running playbook to deploy R3 Corda network](#run_network)

<a name = "create_config_file"></a>
## Create Configuration File

The `network.yaml` file should contain the specific `network.organization` patch along with the orderer information about the networkmap service and doorman.

---
**NOTE**: Make sure the doorman and networkmap service certificates are in plain text and not encoded in base64 or any other encoding scheme, along with correct paths to them mentioned in network.yaml)

---
For reference, sample `network.yaml` file looks like:

```
network:
  # Network level configuration specifies the attributes required for each organization
  # to join an existing network.
  type: corda
  version: 4.0
  #enabled flag is frontend is enabled for nodes
  frontend: enabled
  
  # Docker registry details where images are stored. This will be used to create k8s secrets
  # Please ensure all required images are built and stored in this registry. 
  # Do not check-in docker_password.
  docker:
    url: "docker_url"
    username: "docker_username"
    password: "docker_password"
  
  # Remote connection information for doorman and networkmap (will be blank or removed for hosting organization)
  orderers:
    - orderer:
      type: doorman
      uri: https://doorman.test.corda.blockchaincloudpoc.com:8443
      certificate: home_dir/platforms/r3-corda/configuration/build/corda/doorman/tls/ambassador.crt
    - orderer:
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
        provider: "EKS"
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
        git_ssh: "gitops_ssh_url"         # Gitops ssh url for flux value files like "ssh://git@innersource.accenture.com/blockofz/blockchain-automation-framework.git"
        branch: "gitops_branch"           # Git branch where release is being made
        release_dir: "gitops_release_dir" # Relative Path in the Git repo for flux sync per environment. 
        chart_source: "gitops_charts"     # Relative Path where the Helm charts are stored in Git repo
        git_push_url: "gitops_push_url"   # Gitops https URL for git push like "innersource.accenture.com/scm/blockofz/blockchain-automation-framework.git"
        username: "git_username"          # Git Service user who has rights to check-in in all branches
        password: "git_password"          # Git Server user password

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
## Run playbook to add the new organization to the existing R3 Corda network

[This](https://innersource.accenture.com/projects/BLOCKOFZ/repos/blockchain-automation-framework.git/browse/platforms/r3-corda/configuration/deploy-network.yaml) playbook (deploy_network.yaml) is used to deploy the network. Same playbook is used to add a new organization to the existing network. This can be done manually using the following command

```
    ansible-playbook platforms/r3-corda/configuration/deploy-network.yaml --extra-vars "@path-to-network.yaml"
```

---
**NOTE:** If you have additional applications, please deploy them as well.

---