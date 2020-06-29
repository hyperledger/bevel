# Supplychain Playbooks

## Overview
This folder contains ansible playbooks and their corresponding roles used for the deployment of APIs for supplychain application.
These playbooks enables creation of value files and facilitate deployment of Corda Springboot server, Fabric REST Server and Express APIs over a managed Kubernetes cluster.
These playbooks deploys the smart contract in case of Quorum.

## Prerequisites

To run the playbooks and deploy the APIs, following are the pre-requisites
1. Ansible and Git are required to be setup on the machine.
2. The DLT network setup should be complete using the Blockchain Automation Framework, which includes the GitOps setup.
3. A complete input configuration file: *network.yaml* as described in **Step 1**.

## Playbook Description 
There are following playbooks.

* `deploy-api.yaml` : Creates the value files for Corda springboot-server, Fabric REST-server and respective express-api and commits them into gitops repository.

* `deploy-supplychain-smartContract.yaml` : Deploys the Smart Contract on a Quorum node in an existing Quorum network using a javascript file.

## To Deploy the Supply-Chain APIs:

#### Step 1
Configure a `network.yaml` as described below
Please use the samples provided in **samples** folder to get the examples for each type of DLT platform. Follow the comments in the samples folder to create the correct network configuration.

Sample format of network.yaml
```
network:
  type: corda
  version: 4.0
  cloud_provider: aws
  ...
  gitops:
    git_ssh: "git_ssh"
    branch: "git_branch"
    release_dir: "platforms/r3-corda/releases/dev"  
    chart_source: "platforms/r3-corda/charts"
    username: "git_username"
    password: "git_password"
    private_key: "path_to_private_key"
  ...
  organizations:
  - organization:
      name: manufacturer-net
      country: CH
      state: Zurich
      location: Zurich
      type: node    
      
      services:
        peers:
        - peer:
          name: manufacturer
          subject: "O=Manufacturer,OU=Manufacturer,L=47.38/8.54/Zurich,C=CH"
          type: node
          auth: auth-path
          p2p:
            port: 10002
          rpc:
            port: 10003 
          rpcadmin:
            port: 10005
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

#### Step 2
Run the playbook with the following command

```
ansible-playbook deploy-supplychain-app.yaml --extra-vars "@./network.yaml"
```

For multiple clusters, run the above command for each cluster's network.yaml
```
ansible-playbook deploy-supplychain-app.yaml --extra-vars "@./network1.yaml"
ansible-playbook deploy-supplychain-app.yaml --extra-vars "@./network2.yaml"
```

## To Deploy the Smart Contract:

#### Step 1
Configure a `network.yaml` as described below
Please use the samples provided in **samples** folder to get the examples for each type of DLT platform. Follow the comments in the samples folder to create the correct network configuration.

Sample format of network.yaml
```
network:
  type: quorum
  version: 2.5.0
  cloud_provider: aws
  ...
  organizations:
      - organization:
          name: manufacturer
          external_url_suffix: test.corda.blockchaincloudpoc.com      
          cloud_provider: aws   # Options: aws, azure, gcp
         

          services:
            peers:
            - peer:
              name: manufacturer
              subject: "O=Manufacturer,OU=Manufacturer,L=47.38/8.54/Zurich,C=CH"  
              type: validator         
              geth_passphrase: 12345  
              p2p:
                port: 21000
                ambassador: 15020      
              rpc:
                port: 8546
                ambassador: 15021       
              transaction_manager:
                port: 8443          
                ambassador: 8443    
              raft:                     
                port: 50401
                ambassador: 15023
              db:                       
                port: 3306
              smart_contract:
                name: "General"           
                contract_path: "./contracts"  
                deployjs_path: "examples/supplychain-app/quorum/smartContracts"    
                iterations: 200           
                entrypoint: "General.sol"
                private_for: ""   # Add comma separated list of public tm keys
                geth_url: "http://manufacturer.test.corda.blockchaincloudpoc.com:15021"          
```

#### Step 2
Run the playbook with the following command

```
ansible-playbook deploy-supplychain-app.yaml --extra-vars "@./network.yaml"
```

For multiple clusters, run the above command for each cluster's network.yaml
```
ansible-playbook deploy-supplychain-app.yaml --extra-vars "@./network1.yaml"
ansible-playbook deploy-supplychain-app.yaml --extra-vars "@./network2.yaml"
```
