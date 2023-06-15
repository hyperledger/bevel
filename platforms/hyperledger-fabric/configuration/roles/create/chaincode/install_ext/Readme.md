## chaincode/install_ext
This role creates helm value file for the deployment of install_external_chaincode job.
### main.yaml
### Tasks
Provides nested loping for peers of an org

-------
### nested_main.yaml
### Tasks
Deploys install_external_chaincode Job on k8s for the desired chaincode
#### 1. Check if install-ext-chaincode is already running
This task checks for if the Job has already ran.
#### 2. Copy buildpack for external chaincode
This task copies the provided buildpack to the target peer node
#### 3. Create value file for chaincode installation
This task creates helm value file for the target helm chart.
#### 4. Git Push : Pushes the above generated files to git directory
This task pushes the release file to git for flux to sync and deploy the helm charts.
