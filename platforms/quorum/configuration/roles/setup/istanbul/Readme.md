[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: setup/istanbul
This role installs the istanbul binary if it doesn't exist

### Tasks

#### 1. Check istanbul
This task check if istanbul is already installed or not

**stat**: This module checks if istanbul is installed or not with path variable.

##### Output Variables
    istanbul_stat_result: This variable stores the info on availibility on istanbul binary

#### 2. Check istanbul repo dir exists
This task check if istanbul is already cloned or not

**stat**: This module checks if istanbul is cloned at the path variable or not.

##### Output Variables
    repo_stat_result: This variable stores the info on availibility on istanbul binary


#### 3. Clone the instanbul-tools git repo
This task clones the quorum git repository

**git**: This module clones the quorum repository

##### Input Variables
    repo: The path where the istanbul binary should be installed
    dest: Path where the repository should be cloned

**when**: It runs when *istanbul_stat_result.stat.exists* == False or *repo_stat_result.stat.exists* == False, i.e. when istanbul is not installed.

#### 4. Make istanbul
This task makes istanbul from the cloned repository and store the binary at build/bin

**shell**: The task goes to the cloned repository.

**when**: It runs when *istanbul_stat_result.stat.exists* == False, i.e. when istanbul is not installed.

#### 5. Create bin directory
This task creates the bin directory if it does not exist.

**file**: This module creates the bin directory if it does not exist.

**when**: It runs when *istanbul_stat_result.stat.exists* == False, i.e. when istanbul is not installed.

#### 6. Copy istanbul binary to destination directory
This task copies the istanbul binary to the bin directory.

**copy**: This module copies the istanbul binary which is build in the above task and paste it in bin directory

**when**: It runs when *istanbul_stat_result.stat.exists* == False, i.e. when istanbul is not installed.
