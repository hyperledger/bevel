## ROLE: orderer
 This role creates helm value file for zkKafka and orderer

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. create kafka clusters
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
    
#### 2. create orderers
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

#### 3. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"

**include_role**: It includes the name of intermediatory role which is required for creating the vault auth helm value file.
