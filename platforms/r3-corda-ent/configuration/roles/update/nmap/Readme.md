[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: update/nmap
This role creates the helm value file to update the networkmap so that additional notaries can be added.
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)    

#### 1. Set node_list to empty
This task initializes the node_list variable to an empty string

**set_fact**: This module sets the variable assignment as globally accessible variable

---

#### 2. Get notary data for each node of all organization
This task gets the enode data in the format of
peer_name
nodeinfo
validating
nodeinfo_name

**include_task**: nodelist.yaml
**loop**: loop over the organizations when type = notary
**loop_control**: Specify conditions for controlling the loop.
                
    loop_var: loop variable used for iterating the loop.

---

#### 3. Waiting for nmap pod to come up
This task waits till the nmap is running
#### Input Variables
 - `component_type` -The type of component, i.e. "Pod"
 - `namespace` - The namespace where the component is deployed
 - `component_name` - The name of resource i.e node
 - `kubernetes` - The resources of the K8s cluster (context and configuration file).

---

#### 4. Create nmap value files for update
This task updates the networkmap value file with update parameters
Additional var **nmap_update** must be set to **true**
#### Input Variables
- `type` -The type of component, i.e. `nmap`
- `name` -  Name of the Ambassador credential 
- `component_name` - The name of resource
- `charts_dir` -path to Node DB charts
- `values_dir` - The directory where the release files are stored
- `corda_service_version` - This is  corda service version 
- `idman_url` - This idman_url and Keep this in ansible role to prevent confusion in template
- `helm_lint` - Flag which specifies if the `helm_lint` module needs to be run; `true` in this case since networkmap is a Helm chart.
- `nmap_update` - This is update of nmap true
---

#### 5. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"
    SSH_KEY: "The ssh key for writing to git repo"
    GIT_REPO: "The name of GIT REPO"
    GIT_USERNAME: "Username of Repo"
    GIT_PASSWORD: "Password for Repo"
    GIT_EMAIL: "Email for git config"
    GIT_BRANCH: "Branch Name"
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    msg: "Message for git commit"
These variables are fetched through network.yaml using *item.gitops*
**include_role**: It includes the name of intermediatory role which is required for pushing  the value file to git repository.

----------------

### nodelist_nested.yaml
### Tasks

#### 1.  Waiting for notary pod to come up
This task will wait till the notary is running
##### Input variables
 - `component_type` -The type of component, i.e. "Pod"
 - `namespace` - The namespace where the component is deployed
 - `component_name` - The name of resource i.e notary
 - `kubernetes` - The resources of the K8s cluster (context and configuration file).

---

#### 2. Check if nodeinfo is present in the build directory
This task will check if the nodeinfo exist in build directory

----

#### 3. Create build directory if it does not exist
This task will creates the build directory if it does not exist

**when** - file_status.stat.exists is `False`

---

#### 4.Get the nodeinfo from vault and generate the node
This task will fetch nodeinfo from vault
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
**when** - file_status.stat.exists is `False`
**shell**: This module executes the vault commands

---

#### 5. Get the nodeinfoFilename from vault
This task will get the nodeinfoFilename from vault
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
**when** - file_status.stat.exists is `False`
**shell**: This module executes the vault commands

---

#### 6.Get nodeinfo_data
This task will get nodeinfo_data

---

#### 7.Get notary nodeInfo
This task will get information about each addl notary node present in network.yaml and store it as a list of notary_org,node

-----------------

### nodelist.yaml
### Tasks

#### 1. Check if nodeinfo is present in the build directory
 This task checks if nodeinfo is present in the build directory or not

**stat**: This module checks the file exist or not.
##### Input variables
    *path: path to the nodeinfo.
##### Output variables
    *file_status: output of the nodeinfo exists or not task

#### 2. Create the build directory
 This task creates the build directory if it does not exist

**file**: This module creates the directory

##### Input variables 

    *path: path where the folders need to be created.

**when**: It runs when *file_status.stat.exists* == False, i.e. folder does not exists.

#### 3. Get the nodeinfo from vault
 This task gets the base64 encoded nodeinfo file from Vault and saves to build dir

**shell**: This module executes the vault commands

#### 4. Get the nodeinfoFilename from vault
 This task gets the nodeinfo filename from Vault

**shell**: This module executes the vault commands

#### 5. Get nodeinfo_data
 This task sets the value of nodeinfo_data variable as the contents of the file

**set_fact**: Sets a global variable

#### 6. Get notary nodeInfo
 Creates the notary nodeinfo array with all details

**set_fact**: Sets a global variable. Appends as a array in this case 
