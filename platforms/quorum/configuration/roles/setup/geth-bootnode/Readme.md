[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: setup/geth-bootnode
This role installs the geth and bootnode binary if it doesn't exist

### Tasks

#### 1. Create temporary directory
This tasks creates a temporary directory 

**tempfile**: This module creates a temporary directory.

##### Output Variables

    tmp_directory: This variable stores the info about the temporary directory it created.

#### 2. Check geth
This task check if geth is already installed or not

**stat**: This module checks if geth is installed or not with path variable.

##### Output Variables
    geth_stat_result: This variable checks for the presence of file/directory.

#### 3. Check bootnode
This task check if bootnode is already installed or not

**stat**: This module checks if bootnode is installed or not with path variable.

##### Output Variables
    bootnode_stat_result: This variable stores the info on availibility on bootnode binary

#### 4. Download geth and bootnode tar
This task downloads the geth and binary tar file

##### Input Variables
    url: The url from where the tar file will be downloaded
    dest: Path location where the tar file should be placed

**when**: It runs when *geth_stat_result.stat.exists* == False i.e. when either geth is not installed or *bootnode_stat_result.stat.exists* == False, i.e. when bootnode is not installed.

#### 5. Create bin directory
This task creates the bin directory if it does not exist.

**file**: This module creates the bin directory if it does not exist.

**when**: It runs when *geth_stat_result.stat.exists* == False, i.e. when geth is not installed or *bootnode_stat_result.stat.exists* == False, i.e. when bootnode is not installed.

#### 6. Extracts the tar file containing the geth and bootnode binary
This task extracts the tar file containing the geth and bootnode binary

**unarchive**: The module unzips the tar into the dest directory.

**when**: It runs when *geth_stat_result.stat.exists* == False, i.e. when geth is not installed or *bootnode_stat_result.stat.exists* == False, i.e. when bootnode is not installed

#### 7. Copy geth binary to destination directory
This task will copy geth binary to destination directory.

**copy**: This module copies the geth binary which is build in the above task and paste it in bin directory

**when**: It runs when *geth_stat_result.stat.exists* == False, i.e. when geth is not installed

#### 8. Copy bootnode binary to destination directory
This task will copy bootnode binary to destination directory

**copy**: This module copies the bootnode binary which is build in the above task and paste it in bin directory

**when**: It runs when *bootnode_stat_result.stat.exists* == False, i.e. when bootnode is not installed
