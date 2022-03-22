[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: setup/geth
This role installs the geth binary if it doesn't exist

### Tasks

#### 1. Check geth
This task check if geth is already installed or not

**stat**: This module checks if geth is installed or not with path variable.

##### Output Variables
    geth_stat_result: This variable stores the info on availibility on geth binary

#### 2. Create geth directory
This task creates the geth directory

**stat**: This module creates the geth directory

##### Output Variables
    geth_stat_result: This variable stores the info on availibility on geth binary

#### 3. Download geth tar
This task downloads the geth tar

##### Input Variables
    repo: The path where the geth binary should be installed
    dest: Path where the repository should be placed

**when**: It runs when *geth_stat_result.stat.exists* == False i.e. when either geth is not installed 

#### 4. Create bin directory
This task creates the bin directory if it does not exist.

**file**: This module creates the bin directory if it does not exist.

**when**: It runs when *geth_stat_result.stat.exists* == False, i.e. when geth is not installed.

#### 5. Copy geth binary to destination directory
This task creates the bin directory if it does not exist.

**copy**: This module copies the geth binary which is build in the above task and paste it in bin directory

**when**: It runs when *geth_stat_result.stat.exists* == False, i.e. when geth is not installed.
