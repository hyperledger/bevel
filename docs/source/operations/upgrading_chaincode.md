<a name = "upgrading-chaincode"></a>
# Upgrading existing chaincode in Hyperledger Fabric

- [Pre-requisites](#pre_req)
- [Modifying configuration file](#create_config_file)
- [Running playbook to upgrade chaincode to new version in Hyperledger Fabric network](#run_network)

<a name = "pre_req"></a>
## Pre-requisites
Hyperledger Fabric network deployed, network.yaml configuration file already set and chaincode is installed and instantiated.

<a name = "create_config_file"></a>
## Modifying configuration file

The `network.yaml` file should contain the specific `network.organizations.services.peers.chaincode.arguments`, `network.organizations.services.peers.chaincode.version` and `network.organizations.services.peers.chaincode.name` variables which are used as arguments while upgrading the chaincode.

For reference, sample `network.yaml` file looks like:

```
---
# This is a sample configuration file for SupplyChain App which has 5 nodes.
network:
  # Network level configuration specifies the attributes required for each organization
  # to join an existing network.
  type: fabric
  version: 1.4.0
  
  frontend: enabled #Flag for frontend to enabled for nodes/peers

  #Environment section to help run multiple applications on same cluster
  env:
    type: "env_type"          #Must be unique per single-cluster
    ambassadorPorts: 10010,10020    #Any additional Ambassador ports can be given here, must be comma-separated without spaces
    retry_count: 100 #Retry count for the checks
  
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
      name: carrier
      type: creator       # creator organization will create the channel and instantiate chaincode, in addition to joining the channel and install chaincode
      peers:
      - peer:
        name: peer0
        type: validating
        gossipAddress: peer0.carrier-net.org3ambassador.blockchaincloudpoc.com:8443  # External or internal URI of the gossip peer
      ordererAddress: orderer.org1ambassador.blockchaincloudpoc.com:8443             # External or internal URI of the orderer
    - organization:      
      name: store
      type: joiner        # joiner organization will only join the channel and install chaincode
      peers:
      - peer:
        name: peer0
        type: validating
        gossipAddress: peer0.store-net.org3ambassador.blockchaincloudpoc.com:8443
      ordererAddress: orderer.org1ambassador.blockchaincloudpoc.com:8443
    - organization:
      name: warehouse
      type: joiner
      peers:
      - peer:
        name: peer0
        type: validating
        gossipAddress: peer0.warehouse-net.org2ambassador.blockchaincloudpoc.com:8443
      ordererAddress: orderer.org1ambassador.blockchaincloudpoc.com:8443
    - organization:
      name: manufacturer
      type: joiner
      peers:
      - peer:
        name: peer0
        type: validating
        gossipAddress: peer0.manufacturer-net.org2ambassador.blockchaincloudpoc.com:8443
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
      name: carrier
      country: GB
      state: London
      location: London
      subject: "O=Carrier,OU=Carrier,L=51.50/-0.13/London,C=GB"
      type: peer
      external_url_suffix: org3ambassador.blockchaincloudpoc.com
      ca_data:
        url: ca.carrier-net:7054
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
        private_key: "path_to_private_key"          # Path to private key file which has write-access to the git repo

      #Optional for infrastructure configuration files.
      infrastructure:
        target_state: "present"  # Options: present, absent, planned            
        refresh_inventory: yes  

              
      services:
        ca:
          name: ca
          subject: "/C=GB/ST=London/L=London/O=Carrier/CN=ca.carrier-net"
          type: ca
          grpc:
            port: 7054
        peers:
        - peer:
          name: peer0          
          type: peer
          gossippeeraddress: peer0.carrier-net.org3ambassador.blockchaincloudpoc.com:8443          
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
    - organization:
      name: store
      country: US
      state: New York
      location: New York
      subject: "O=Store,OU=Store,L=40.73/-74/New York,C=US"
      type: peer
      external_url_suffix: org3ambassador.blockchaincloudpoc.com
      ca_data:
        url: ca.store-net:7054
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
        private_key: "path_to_private_key"          # Path to private key file which has write-access to the git repo

      #Optional for infrastructure configuration files.
      infrastructure:
        target_state: "present"  # Options: present, absent, planned            
        refresh_inventory: yes  

        
      services:
        ca:
          name: ca
          subject: "/C=US/ST=New York/L=New York/O=Store/CN=ca.store-net"
          type: ca
          grpc:
            port: 7054
        peers:
        - peer:
          name: peer0          
          type: peer
          gossippeeraddress: peer0.store-net.org3ambassador.blockchaincloudpoc.com:8443          
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
      name: warehouse
      country: US
      state: Massachusetts
      location: Boston
      subject: "O=Warehouse,OU=Warehouse,L=42.36/-71.06/Boston,C=US"
      type: peer
      external_url_suffix: org2ambassador.blockchaincloudpoc.com
      ca_data:
        url: ca.warehouse-net:7054
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
        private_key: "path_to_private_key"          # Path to private key file which has write-access to the git repo

      #Optional for infrastructure configuration files.
      infrastructure:
        target_state: "present"  # Options: present, absent, planned            
        refresh_inventory: yes  

        
      services:
        ca:
          name: ca
          subject: "/C=US/ST=Massachusetts/L=Boston/O=Warehouse/CN=ca.warehouse-net"
          type: ca
          grpc:
            port: 7054
        peers:
        - peer:
          name: peer0          
          type: peer
          gossippeeraddress: peer0.warehouse-net.org2ambassador.blockchaincloudpoc.com:8443          
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
            name: "chaincode_name"     #This has to be replaced with the name of the chaincode
            version: "chaincode_version"     #This has to be replaced with the version of the chaincode
            maindirectory: "chaincode_main"   #The main directory where chaincode is needed to be placed
            repository:
              username: "git_username"          # Git Service user who has rights to check-in in all branches
              password: "git_password"
              url: "github.com/hyperledger-labs/blockchain-automation-framework.git"
              branch: develop
              path: "chaincode_src"   #The path to the chaincode 
            arguments: 'chaincode_args'     #Arguments to be passed along with the chaincode parameters
            endorsements: ""        #Endorsements (if any) provided along with the chaincode
```

<a name = "run_network"></a>
## Run playbook to upgrade the chaincode version in existing Hyperledger Fabric network

The playbook mentioned [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/chaincode-upgrade.yaml) is used to upgrade chaincode to a new version in the existing fabric network.
This can be done manually using the following command

```
    ansible-playbook platforms/hyperledger-fabric/configuration/chaincode-upgrade.yaml --extra-vars "@path-to-network.yaml"
```