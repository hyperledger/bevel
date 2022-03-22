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

#### 2. Create bootnode directory
This task creates the bootnode directory

**stat**: This module creates the bootnode directory

##### Output Variables
    bootnode_stat_result: This variable stores the info on availibility on bootnode binary

#### 3. Download bootnode tar
This task downloads the bootnode tar

##### Input Variables
    repo: The path where the bootnode binary should be installed
    dest: Path where the repository should be placed

**when**: It runs when *bootnode_stat_result.stat.exists* == False i.e. when either bootnode is not installed 

#### 4. Create bin directory
This task creates the bin directory if it does not exist.

**file**: This module creates the bin directory if it does not exist.

**when**: It runs when *bootnode_stat_result.stat.exists* == False, i.e. when bootnode is not installed.

#### 5. Copy bootnode binary to destination directory
This task creates the bin directory if it does not exist.

**copy**: This module copies the bootnode binary which is build in the above task and paste it in bin directory

**when**: It runs when *bootnode_stat_result.stat.exists* == False, i.e. when bootnode is not installed.
