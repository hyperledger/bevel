# Jenkins Pipeline
Jenkins is a self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software.

## Jenkins in Blockchain Automation Framework
In Blockchain Automation Framework, although Jenkins is not mandatory, we have [a single Jenkinsfile](https://github.com/hyperledger-labs/blockchain-automation-framework/blob/master/automation/Jenkinsfile) as a sample to help you setup CI/CD Pipelines. 

## Pre-requisites
1. Setup Jenkins with slave configurations. Declare a slave-config called `ansible` with the Docker Image [hyperledgerlabs/baf-build:jenkins](https://hub.docker.com/r/hyperledgerlabs/baf-build/tags).
1. A EKS Cluster (Managed on AWS) and its kubeconfig file available and accessible from the Jenkins server.
1. AWS user `jenkins` with CLI credentials with access to above EKS Cluster.
1. A Hashicorp Vault installation which is accessible from the Jenkins server.
1. A Git repo which will be added as multi-branch pipeline on Jenkins (this is a fork of this repo).
1. A separate `baf-configuration` git repo where the templated network.yaml for different platforms are stored. Details of this repo needs to be updated in pipeline Stage `Create Configuration File`.

## Branch Configuration
The Jenkinsfile is designed to ignore `develop` and `master` branches by default. So, create platform specific branches in your forked repo.
- `corda` for Opensource Corda
- `corda-ent` for Enterprise Corda
- `fabric` for Hyperledger Fabric
- `besu` for Hyperledger Besu
- `indy` for Hyperledger Indy
- `quorum` for Quorum

Your `baf-configuration` repo should have the corresponding folders and files as demanded/configured in Stage `Create Configuration File`.

## Jenkins Secrets
Following secrets must be stored in Jenkins which is configured in the environment section. This can be renamed/updated in the Jenkinsfile according to your needs.
- `sownak-innersource`: is the Git Token and password to access the Git repos.
- `aws_demo_kubeconfig`: is the Kubeconfig file for AWS EKS cluster.
- `jenkins_gitops_key`: is the Gitops private key which has Read-Write access to the Git repos.
- `nexus_user`: is the Service User and Password for access to Nexus for Cordapps (only used in Corda).
- `aws_demo_vault_key`: is the private key to enable ssh access to Hashicorp Vault Server.
- `aws_demo_vault_token`: is the Root Token for Hashicorp Vault.
- `gmaps_key`: is the Google Maps API key for frontend (only used when deploying Supplychain application).
- `aws_jenkins`: is the AWS credentials for jenkins user on AWS IAM.

## Environment Changes
Following `environment` variables need to be updated in Jenkinsfile for your own environment
- VAULT_SERVER=[vault server ip address or domain name reachable from this server]
- VAULT_PORT=[vault server port]
- VAULT_BASTION=[vault bastion server address]
- VAULT_PRIVATE_IP=[vault server private ip address]

## Parameters
These can be changed when running manually, the automated Jenkins pipeline always use the default option):
1. FORCE_ACTION (default: no) To force rebuild `[ci skip]` commits in case of previous failure.
1. RESET_ACTION (default: yes) To have the option to NOT reset the network when running the pipeline.
1. APIONLY_ACTION (default: no) To run only API test on existing live network in case of previous failure.
1. FABRIC_VERSION (default: 1_4_4) To select the Fabric version.
1. FABRIC_CONSENSUS (default: raft) To select the Fabric consensus.
1. CORDA_VERSION (default: 4_4) To select the Corda Opensource version.
1. QUORUM_VERSION (default: 2_5_0) To select the Quorum version (only 2_5_0 is supported for now)
1. QUORUM_CONSENSUS (default: ibft) To change the Quorum consensus.
1. QUORUM_TM (default: tessera) To change the Quorum Transaction manager.
1. INDY_VERSION (default: 1_11_0) To change the Indy version.

- Default Corda Enterprise version is 4_4. This is hardcoded in the jenkinsfile.
- Default Besu settings are: Version 1_4_4, Consensus IBFT, Transaction Manager Orion.

## Setup on Jenkins
Configure Multi-branch pipeline with the forked repo as the source. In case you create the branches later, scan the pipeline to get new branches on Jenkins.

## Jenkins Stages
1. `Checkout SCM`: Manually checkout the branch and check for `[ci skip]` commits as they are skipped.

1. `Prepare build environment`: Creates the build directory and sets up the necessary files for build like gitops.pem, vault.pem, kubeconfig, test jsons. Also creates the ssh-tunnel connection to Hashicorp Vault server.

1. `<branch>-settings`: Set env variables CONSENSUS, VERSION and TM based on the branch i.e. based on the DLT platform.
1. `Create Configuration File`: Downloads the config file (main network.yaml, addorg.yaml and application.yaml) depending on the BRANCH_NAME, CONSENSUS, VERSION and TM from baf-configuration and adds the secret parameters.
1. `Reset existing network`: Resets the network based on application.yaml as that should contain all the orgs.
1. `Deploy network`: Deploys the network based on main network.yaml.
1. `Add a new node`: Adds a new organization to the above network. This is not enabled for Indy currently.
1. `Deploy Supplychain-App`: Deploys the supplychain app. Not enabled for Indy. Corda Enterprise and Besu are in the future roadmap.
1. `Deploy Identity-App`: Deploys the Identity app. Only for Indy.
1. `Run SupplyChain API tests`: Runs Supplychain API test using newman. This step has a try-catch so that the whole pipeline does not fail if only API tests fail. Re-run the tests manually if only API tests fail. Not enabled for Indy. Corda Enterprise and Besu are in the future roadmap.
1. `Run Identity API tests`: Runs Identity API test using newman. This step has a try-catch so that the whole pipeline does not fail if only API tests fail. Re-run the tests manually if only API tests fail. Only for Indy.
1 `Manual Approval for resetting the deployment`: Waits for 20 minutes before resetting the network. If you want to keep the network for demo, Abort at this stage.
1. `Reset network again`: Resets the network after the 20 minutes is over or you chose to reset. Keeps the network running if the previous step was aborted.
