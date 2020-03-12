## ROLE: geth
This role installs the geth binary if it doesn't exist

### Tasks

#### 1. Register temporary directory
This tasks creates a temporary directory for cloning and building geth

**tempfile**: This module creates a temporary directory where the git repository is cloned if geth is not installed.

##### Output Variables

    tmp_directory: This variable stores the info about the temporary directory it created.

#### 2. Check geth
This task check if geth is already installed or not

**stat**: This module checks if geth is installed or not with path variable.

##### Output Variables
    geth_stat_result: This variable stores the info on availibility on geth binary

#### 3. Clone the git repo
This task clones the quorum git repository

**git**: This module clones the quorum repository

##### Input Variables
    repo: The path where the geth binary should be installed
    dest: Path where the repository should be cloned

**when**: It runs when *geth_stat_result.stat.exists* == False, i.e. when geth is not installed.

#### 4. Make geth
This task makes geth from the cloned repository and store the binary at build/bin

**shell**: The task goes to the cloned repository.

**when**: It runs when *geth_stat_result.stat.exists* == False, i.e. when geth is not installed.

#### 5. Create bin directory
This task creates the bin directory if it does not exist.

**file**: This module creates the bin directory if it does not exist.

**when**: It runs when *geth_stat_result.stat.exists* == False, i.e. when geth is not installed.

#### 6. Copy geth binary to destination directory
This task creates the bin directory if it does not exist.

**copy**: This module copies the geth binary which is build in the above task and paste it in bin directory

**when**: It runs when *geth_stat_result.stat.exists* == False, i.e. when geth is not installed.
