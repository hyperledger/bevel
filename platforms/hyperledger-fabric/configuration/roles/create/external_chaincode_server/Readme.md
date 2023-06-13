## create/external_chaincode_server
This role creates helm value file for the deployment of external-chaincode Pod.
### main.yaml
### Tasks
Provides nested loping for peers of an org

-------
### nested_main.yaml
### Tasks
Deploys external-chaincode Pod on k8s for the desired chaincode
#### 1. Check or Wait if commit-chaincode is already run for v.2.x
This task checks for if the commit-chaincode job has already ran.
#### 2. Check external-chaincode-server exists
This task checks for if the external-chaincode-server already exists.
#### 3. Fetch the ccid from the Peer CLI
This task fetches the chaincode ID from peer CLI
#### 4. Fetch the ccid to var
This task copies the value to ansible vars
#### 5. Create Value files for chaincode server
This task creates helm value file for the target helm chart.
#### 6. Git Push : Pushes the above generated files to git directory
This task pushes the release file to git for flux to sync and deploy the helm charts.
#### 7. Wait for chaincode server pod to be in the state of running
This task waits till the chaincode server pod is in running state
