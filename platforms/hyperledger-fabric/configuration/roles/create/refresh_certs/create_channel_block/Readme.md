[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/refresh_certs/create_channel_block
This role creates the update_channel.sh script for modifying the latest configuration block.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

#### 1. Call nested_main for modifying the latest configuration block
This task callsnested_main for modifying the latest configuration block
**loop**: loops over result list fetched from *orderers*
**loop_control**: Specify conditions for controlling the loop.
    
    loop_var: loop variable used for iterating the loop.

#### 3. Call get_update_block for get the latest configuration block of the system channel
This task calls get_update_block for get the latest configuration block of the system channel
##### Input Variables
    *channel_name: Provide the channel name
    *orderer: The information of the first orderer in orderer organization

#### 4. Call get_update_block for get the last configuration block of the app channels
This task calls get_update_block for get the last configuration block of the app channels
##### Input Variables
    *channel_name: Provide the channel name
    *orderer: The information of the first orderer in orderer organization
**loop**: loops over result list fetched from *network.channels*
**loop_control**: Specify conditions for controlling the loop.
    
    loop_var: loop variable used for iterating the loop

#### 5. Ensure channel-artifacts dir exists
This tasks ensures whether the channel-artifacts dir exists

#### 6. Create genesis block
This task creates the genesis block by consuming the latest config block
##### Input Variables

    *channel_name: The name of the system channel.
**when**: Condition is specified here, runs only when the *update_type* is *address*.

#### 7. Write genesis block to Vault
Writes the BASE64 encoded genesis block to the Vault path of the orderer organizations.
**shell**: Executes a `vault cli` command to write the BASE 64 encoded genesis block to the Vault.

#### 8. delete orderer cli 
This task starts the cli using the value file created in the previous stepr.
##### Input Variables
    *config_file: Kubernetes file
    *orderer: The orderer information
**loop**: loops over result list fetched from *network.organizaions*
**loop_control**: Specify conditions for controlling the loop.
    
    loop_var: loop variable used for iterating the loop

------------
### nested_main.yaml
This task creates the update_channel.sh script for modifying the latest configuration block

#### 1. Create create-syschannel-block.sh script file for orderers
This task creates the create_block.sh script
##### Input Variables
    *component_name: The name of resource
    *namespace: The namespace of resourse
    *channel_name: Provide the channel name
    *os: The operating system for the platform
    *arch: The platform architecture
    *version: The network version
**template** : It contains the source and destinations details required for value file generation of access policy.
**src**: Contains the details of template file.
**dest**: Destination path and name of file to be generated.

#### 2. Create update-channel-script.sh script file for orderers
This task creates the create_block.sh script
##### Input Variables
    *component_name: The name of resource
    *component_ns: The namespace of resourse
    *channel_name: Provide the channel name
    *os: The operating system for the platform
    *arch: The platform architecture
    *version: The network version
**template** : It contains the source and destinations details required for value file generation of access policy.
**src**: Contains the details of template file.
**dest**: Destination path and name of file to be generated.
**loop**: loops over result list fetched from *network.channels*
**loop_control**: Specify conditions for controlling the loop.
    
    loop_var: loop variable used for iterating the loop.

#### 3. Call nested_create_cli for the first orderer
This task calls nested_create_cli for the first orderer
##### Input Variables
    *orderer: The information of the first orderer in orderer organization

**include_tasks**: It includes the name of intermediatory task which is required for creating the vault auth value file.

------------
### nested_create_cli.yaml
This task initiates the nested role for creating, fetching and modifying the config block

#### 1. create valuefile for cli {{ orderer.name }}-{{ org.name }}-{{ channel_name }}
This task create the value file for creater org first peer.
##### Input Variables

    *component_type_name: The orderer organization name 
    *orderer_name: Name of the orderer
    *component_ns: The namespace of the organization
    *charts_dir: Path to the charts directory
    *vault: The information of the vault
    *channel_name: Name of the channel
    *storage_class: Name of the storage class to be used for cli
    *release_dir: The path to the release directory
    *orderer_address: Address of the orderer

#### 2. start cli 
This task starts the cli using the value file created in the previous stepr.
##### Input Variables

    *build_path: The path of build directory.
    *config_file: Kubernetes file
    *playbook_dir: Path for the playbook directory
    *chart_source: Path for the charts directory 
 
#### 3. waiting for the fabric cli
This task wait for the fabric cli generated in the previous step to get into running state.
##### Input Variables

    namespace: Namespace of the organization
    kubeconfig: kubeconfig file
##### Output Variables
    get_cli: This variable stores the output of check if fabric cli is present query.

#### 4. Call get_update_block to fetch the syschannel channel configuration block
This task calls get_update_block to fetch the syschannel channel configuration block
##### Input Variables
    *script: Provides the path of the script to execute
    *channel_name: Provide the channel name

#### 5. Call get_update_block to fetch the app channels configuration block
This task calls get_update_block to fetch the appchannel channels configuration block
##### Input Variables
    *script: Provides the path of the script to execute
    *channel_name: Provide the channel name

**loop**: loops over result list fetched from *network.channels*
**loop_control**: Specify conditions for controlling the loop.
    
    loop_var: loop variable used for iterating the loop

#### 6. Call get_update_block to update the syschannel channel configuration block
This task calls get_update_block to update the syschannel channel configuration block
##### Input Variables
    *script: Provides the path of the script to execute
    *channel_name: Provide the channel name

#### 7. Call get_update_block to update the app channels configuration block
This task calls get_update_block to update the appchannel channels configuration block
##### Input Variables
    *script: Provides the path of the script to execute
    *channel_name: Provide the channel name

**loop**: loops over result list fetched from *network.channels*
**loop_control**: Specify conditions for controlling the loop.
    
    loop_var: loop variable used for iterating the loop

#### 8. Delete the previous orderer HelmRelease
This task delete the previously created orderer HelmRelease
##### Input Variables

    *kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *namespace: The namespace of the component.
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context

#### 9. waiting for orderer HelmRelease
This task wait for orderer HelmRelease to get into Succeeded state.
##### Input Variables

    namespace: Namespace of the organization
    kubeconfig: kubeconfig file
##### Output Variables
    get_cli: This variable stores the output of check if fabric cli is present query.

#### 10. waiting for orderer pod
This task wait for the orderer pod to get into running state.
##### Input Variables

    namespace: Namespace of the organization
    kubeconfig: kubeconfig file
##### Output Variables
    get_cli: This variable stores the output of check if fabric cli is present query.

------------
### get_update_block.yaml
This task initiates the nested role for creating, fetching and modifying the config block

#### 1. fetch the configuration block from the blockchain
This task fetch the configuration block from the blockchain with the new orderer information.
##### Input Variables

    *config_file: Kubernetes file
    *kubernetes: Kubernetes cluster information of the organization

#### 2. modify, update and copy the configuration block from the blockchain
This task modify, update and copy the configuration block from the blockchain with the new orderer information.
##### Input Variables

    *config_file: Kubernetes file
    *kubernetes: Kubernetes cluster information of the organization

#### 3. fetch the latest configuration block from the blockchain
This task fetch the latest configuration block from the blockchain to be used as genesis block.
##### Input Variables

    *config_file: Kubernetes file
    *kubernetes: Kubernetes cluster information of the organization
