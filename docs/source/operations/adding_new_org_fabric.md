<a name = "adding-new-org-to-existing-network-in-fabric"></a>
# Adding new organization to existing network in Hyperledger Fabric

- [Prerequisites](#prerequisites)
- [Modifying configuration file](#create_config_file)
- [Running playbook to deploy Hyperledger Fabric network](#run_network)


<a name = "prerequisites"></a>
## Prerequisites
To add a new organization a fully configured Fabric network must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels). The corresponding crypto materials should also be present in their respective Hashicorp Vault. Addition of a new organization has been tested on an existing network which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.


<a name = "create_config_file"></a>
## Modifying Configuration File

While modifying the `network.yaml` for the adding new organization, all the existing organizations should have `org_status` tag as `existing` and the new organization should have `org_status` tag as `new` under `network.channels` as 

    network:
      channels:
      - channel:
        ..
        ..
        participants:
        - organization:
          ..
          ..
          org_status: new  #org_status can be new/existing

and under `network.organizations` as

    network:
      organizations:
        - organization:
          ..
          ..
          org_status: new  #org_status can be new/existing

The `network.yaml` file should contain the specific `network.organization` patch along with the orderer information.


For reference, sample `network_neworg.yaml` file looks like below (but always check the latest at `platforms/hyperledger-fabric/configuration/samples`):

```
---
# This is a sample configuration file for SupplyChain App which has 5 nodes.
network:
  # Network level configuration specifies the attributes required for each organization
  # to join an existing network.
  type: fabric
  version: 1.4.0
  
  frontend: enabled #Flag for frontend to enabled for nodes/peers

  #Environment section for Kubernetes setup
  env:
    type: "env_type"              # tag for the environment. Important to run multiple flux on single cluster
    proxy: haproxy                  # values can be 'haproxy' or 'ambassador'
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
  
  # Remote connection information for orderer (will be blank or removed for orderer hosting organization)
  orderers:
    - orderer:
      type: orderer
      name: orderer
      org_name: supplychain               #org_name should match one organization definition below in organizations: key            
      uri: orderer.org1ambassador.blockchaincloudpoc.com:8443   # Can be external or internal URI for orderer which should be reachable by all peers
      certificate: directory/file1.cert                         # This has not been implemented in 0.2.0.0
  
  # The channels defined for a network with participating peers in each channel
  channels:
  - channel:
    consortium: SupplyChainConsortium
    channel_name: AllChannel
    orderer: 
      name: supplychain
    participants:
    - organization:
      name: manufacturer
      type: joiner
      org_status: existing      
      peers:
      - peer:
        name: peer0
        type: validating
        gossipAddress: peer0.manufacturer-net.org2ambassador.blockchaincloudpoc.com:8443
      ordererAddress: orderer.org1ambassador.blockchaincloudpoc.com:8443
    - organization:
      name: neworg
      type: joiner
      org_status: new      
      peers:
      - peer:
        name: peer0
        type: validating
        gossipAddress: peer0.neworg-net.org2ambassador.blockchaincloudpoc.com:8443
      ordererAddress: orderer.org1ambassador.blockchaincloudpoc.com:8443      
    genesis:
      name: OrdererGenesis  

  # Allows specification of one or many organizations that will be connecting to a network.
  # If an organization is also hosting the root of the network (e.g. doorman, membership service, etc),
  # then these services should be listed in this section as well.
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
      org_status: existing  #org status can be new/existing
      ca_data:
        url: ca.supplychain-net:7054
        certificate: file/server.crt        # This has not been implemented in 0.2.0.0
  
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
        git_ssh: "gitops_ssh_url"         # Gitops ssh url for flux value files like "ssh://git@github.com:hyperledger-labs/blockchain-automation-framework.git"
        branch: "gitops_branch"           # Git branch where release is being made
        release_dir: "gitops_release_dir" # Relative Path in the Git repo for flux sync per environment. 
        chart_source: "gitops_charts"     # Relative Path where the Helm charts are stored in Git repo
        git_push_url: "gitops_push_url"   # Gitops https URL for git push like "github.com/hyperledger-labs/blockchain-automation-framework.git"
        username: "git_username"          # Git Service user who has rights to check-in in all branches
        password: "git_password"          # Git Server user password
        email: "git_email"                # Email to use in git config
        private_key: "path_to_private_key"          # Path to private key file which has write-access to the git repo

      #Optional for infrastructure configuration files.
      infrastructure:
        target_state: "present"  # Options: present, absent, planned            
        refresh_inventory: yes  

        
      # Services maps to the pods that will be deployed on the k8s cluster
      # This sample is an orderer service and includes a zk-kafka consensus
      services:
        ca:
          name: ca
          subject: "/C=GB/ST=London/L=London/O=Orderer/CN=ca.supplychain-net"
          type: ca
          grpc:
            port: 7054
        
        consensus:
          name: kafka
          type: broker
          replicas: 4
          grpc:
            port: 9092
                
        orderer:
          name: orderer
          type: orderer          
          consensus: kafka
          grpc:
            port: 7050       
        

    # Specification for the 2nd organization. Each organization maps to a VPC and a separate k8s cluster
    - organization:
      name: manufacturer
      country: CH
      state: Zurich
      location: Zurich
      subject: "O=Manufacturer,OU=Manufacturer,L=47.38/8.54/Zurich,C=CH"
      type: peer
      external_url_suffix: org2ambassador.blockchaincloudpoc.com
      org_status: existing  #org status can be new/existing
      ca_data:
        url: ca.manufacturer-net:7054
        certificate: file/server.crt

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
        git_ssh: "gitops_ssh_url"         # Gitops ssh url for flux value files like "ssh://git@github.com:hyperledger-labs/blockchain-automation-framework.git"
        branch: "gitops_branch"           # Git branch where release is being made
        release_dir: "gitops_release_dir" # Relative Path in the Git repo for flux sync per environment. 
        chart_source: "gitops_charts"     # Relative Path where the Helm charts are stored in Git repo
        git_push_url: "gitops_push_url"   # Gitops https URL for git push like "github.com/hyperledger-labs/blockchain-automation-framework.git"
        username: "git_username"          # Git Service user who has rights to check-in in all branches
        password: "git_password"          # Git Server user password
        email: "git_email"                # Email to use in git config
        private_key: "path_to_private_key"          # Path to private key file which has write-access to the git repo

      #Optional for infrastructure configuration files.
      infrastructure:
        target_state: "present"  # Options: present, absent, planned            
        refresh_inventory: yes  

        
      # The participating nodes are peers
      # This organization hosts it's own CA server 
      services:
        ca:
          name: ca
          subject: "/C=CH/ST=Zurich/L=Zurich/O=Manufacturer/CN=ca.manufacturer-net"
          type: ca
          grpc:
            port: 7054
        peers:
        - peer:
          name: peer0          
          type: peer          
          gossippeeraddress: peer0.manufacturer-net.org2ambassador.blockchaincloudpoc.com:8443          
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
    
    - organization:
      name: neworg
      country: GB
      state: London
      location: London
      subject: "O=Neworg,OU=Neworg,L=51.50/-0.13/London,C=GB"
      type: peer
      external_url_suffix: org3ambassador.blockchaincloudpoc.com
      org_status: new  #org status can be new/existing
      ca_data:
        url: ca.neworg-net:7054
        certificate: file/server.crt
      
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
        git_ssh: "gitops_ssh_url"         # Gitops ssh url for flux value files like "ssh://git@github.com:hyperledger-labs/blockchain-automation-framework.git"
        branch: "gitops_branch"           # Git branch where release is being made
        release_dir: "gitops_release_dir" # Relative Path in the Git repo for flux sync per environment. 
        chart_source: "gitops_charts"     # Relative Path where the Helm charts are stored in Git repo
        git_push_url: "gitops_push_url"   # Gitops https URL for git push like "github.com/hyperledger-labs/blockchain-automation-framework.git"
        username: "git_username"          # Git Service user who has rights to check-in in all branches
        password: "git_password"          # Git Server user password
        email: "git_email"                # Email to use in git config
        private_key: "path_to_private_key"          # Path to private key file which has write-access to the git repo

      #Optional for infrastructure configuration files.
      infrastructure:
        target_state: "present"  # Options: present, absent, planned            
        refresh_inventory: yes  

              
      services:
        ca:
          name: ca
          subject: "/C=GB/ST=London/L=London/O=Neworg/CN=ca.neworg-net"
          type: ca
          grpc:
            port: 7054
        peers:
        - peer:
          name: peer0          
          type: peer
          gossippeeraddress: peer0.neworg-net.org3ambassador.blockchaincloudpoc.com:8443          
          grpc:
            port: 7051         
          events:
            port: 7053
          couchdb:
            port: 5984
          restserver:
            targetPort: 20001
            port: 20001 
          expressapi:
            targetPort: 3000
            port: 3000
          chaincode:
            name: "chaincode_name"   #This has to be replaced with the name of the chaincode
            version: "chaincode_version"   #This has to be replaced with the version of the chaincode
            maindirectory: "chaincode_main"    #The main directory where chaincode is needed to be placed
            repository:
              username: "git_username"          # Git Service user who has rights to check-in in all branches
              password: "git_password"
              url: "github.com/hyperledger-labs/blockchain-automation-framework.git"
              branch: develop 
              path: "chaincode_src"    #The path to the chaincode 
            arguments: 'chaincode_args'       #Arguments to be passed along with the chaincode parameters
            endorsements: ""          #Endorsements (if any) provided along with the chaincode
```

<a name = "run_network"></a>
## Run playbook to add the new organization to the existing Hyperledger Fabric network

The [add-organization.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/add-organization.yaml) playbook is used to add a new organization to the existing network. This can be done using the following command

```
ansible-playbook platforms/hyperledger-fabric/configuration/add-organization.yaml --extra-vars "@path-to-network.yaml"
```

---
**NOTE:** Make sure that the `org_status` label was set as `new` when the network is deployed for the first time.<br/>
          If you have additional applications, please deploy them as well.
