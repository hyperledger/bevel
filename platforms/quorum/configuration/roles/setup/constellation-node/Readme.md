[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: setup/constellation-node
This role installs the constellation-node binary if it doesn't exist

### Tasks

#### 1. Register temporary directory
This tasks creates a temporary directory for cloning and building constellation-node

**tempfile**: This module creates a temporary directory where the constellation-node binary is downloaded if it is not installed.

##### Output Variables

    tmp_directory: This variable stores the info about the temporary directory it created.

#### 2. check constellation
This task check if constellation-node is already installed or not

**stat**: This module checks if constellation-node is installed or not with path variable.

##### Output Variables
    constellation_stat_result: This variable stores the info on availibility on constellation-node binary

#### 3. Download the constellation-node binary
This task fetches the constellation binary

**get_url**: This module downloads the constellation-node binary

##### Input Variables
    url: The path where the bootnode binary is available
    dest: Path where the it should be downloaded

**when**: It runs when *constellation_stat_result.stat.exists* == False, i.e. when binary is not installed.

#### 4. Unarchive the file.
This task unzips the binary

**shell**: The task goes to the downloaded path.

**when**: It runs when *constellation_stat_result.stat.exists* == False, i.e. when constellation-node is not installed.

#### 5. Create bin directory
This task creates the bin directory if it does not exist.

**file**: This module creates the bin directory if it does not exist.

**when**: It runs when *constellation_stat_result.stat.exists* == False, i.e. when bootnode is not installed.

#### 6. Copy constellation binary to destination directory
This task creates the bin directory if it does not exist.

**copy**: This module copies the constellation binary which is unzipped in the above task and paste it in bin directory

**when**: It runs when *constellation_stat_result.stat.exists* == False, i.e. when bootnode is not installed.
