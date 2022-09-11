[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: orderer
 This role creates helm value file for zkKafka and orderer

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

#### 1. Fetch the genesis block from vault
This task fetch the genesis block from vault to the build directory
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of the resource.

#### 2. Reset orderers pods
This task reset peers pods
##### Input Variables
    *pod_name: Provide the name of the pod
    *name: Provide the name of the organization
    *file_path: Provide the release file path
    *gitops_value: *item.gitops* from network.yaml
    *component_ns: Provide the namespace of the resource
    *kubernetes: *item.k8s* from network.yaml
    *hr_name: Provides the name of the helmrealse
**when**: It runs Only when *refresh_cert* is defined and *refresh_cert* is true.

#### 3. create kafka clusters
This task creates the value file for kafka for orderes as per requirements mentioned in
network.yaml.
##### Input Variables

    name: "orderer"
    *org_name: The name of the organisation
    component_name: "zkkafka"
    type: "zkkafka"
    consensus: "consensus details"
**include_role**: It includes the name of intermediatory role which is required for creating the helm value file, here helm_component
**when**: *component_services.orderer.consensus* is 'zkkafka' and *consensus: "component_services.consensus* is defined.
    
#### 4. create orderers
This task creates the value file for the Orderers as per requirements mentioned in 
network.yaml
##### Input Variables

    name: "orderer"
    *org_name: The name of the organisation
    *component_name: "The name of the component"
    type: "orderers"
    consensus: "consensus details"
    orderer: "Orderer details patch from network yaml"
    genesis: "path of genesis block"
**include_role**: It includes the name of intermediatory role which is required for creating the helm value file, here helm_component
**when**: *component_services.orderer* is defined and *consensus: "component_services.consensus* is defined.

#### 5. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"

**include_role**: It includes the name of intermediatory role which is required for creating the vault auth helm value file.
