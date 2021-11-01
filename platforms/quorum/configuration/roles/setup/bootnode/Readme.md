[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: setup/bootnode
This role installs the bootnode binary if it doesn't exist

### Tasks

#### 1. Check bootnode
This task check if bootnode is already installed or not

**stat**: This module checks if bootnode is installed or not with path variable.

##### Output Variables
    bootnode_stat_result: This variable stores the info on availibility on bootnode binary

#### 2. Check quorum repo dir exists
This task check if bootnode is already installed or not

**stat**: This module checks if quorum is cloned or not.

##### Output Variables
    quorum_stat_result: This variable stores the info on availibility on quorum repo dir

#### 3. Clone the git repo
This task clones the quorum git repository

**git**: This module clones the quorum repository

##### Input Variables
    repo: The path where the bootnode binary should be installed
    dest: Path where the repository should be cloned

**when**: It runs when *bootnode_stat_result.stat.exists* == False and *quorum_stat_result.stat.exists* == Flase i.e. when either bootnode is not installed or quorum dir is not there.

#### 4. Make bootnode
This task makes bootnode from the cloned repository and store the binary at build/bin

**shell**: The task goes to the cloned repository.

**when**: It runs when *bootnode_stat_result.stat.exists* == False, i.e. when bootnode is not installed.

#### 5. Create bin directory
This task creates the bin directory if it does not exist.

**file**: This module creates the bin directory if it does not exist.

**when**: It runs when *bootnode_stat_result.stat.exists* == False, i.e. when bootnode is not installed.

#### 6. Copy bootnode binary to destination directory
This task creates the bin directory if it does not exist.

**copy**: This module copies the bootnode binary which is build in the above task and paste it in bin directory

**when**: It runs when *bootnode_stat_result.stat.exists* == False, i.e. when bootnode is not installed.
