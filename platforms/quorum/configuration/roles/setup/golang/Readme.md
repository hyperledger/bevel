[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: setup/golang
This role installs the go binary if it doesn't exist

### Tasks

#### 1. Register temporary directory
This tasks creates a temporary directory for cloning and building go

**tempfile**: This module creates a temporary directory where the git repository is cloned if go is not installed.

##### Output Variables

    tmp_directory: This variable stores the info about the temporary directory it created.

#### 2. Check go
This task check if go is already installed or not

**stat**: This module checks if go is installed or not with path variable.

##### Output Variables
    go_stat_result: This variable stores the info on availibility on go binary

#### 3. Download golang tar
This task downloads the go tar according to the os

**get_url**: This module clones the quorum repository

##### Input Variables
    url: The path from where the go tar has to be fetched
    dest: Path where tar should be copied
    mode: add permissions

**when**: It runs when *not go_stat_result.stat.exists*, i.e. when go is not installed.

#### 4. Extract the Go tarball
This task makes extracts the go tar at /usr/local

**unarchive**: The module unzips the tar into the dest directory.

**when**: It runs when *not go_stat_result.stat.exists* , i.e. when go is not installed.

#### 5. Create bin directory
This task creates the bin directory if it does not exist.

**file**: This module creates the bin directory if it does not exist.

**when**: It runs when *not go_stat_result.stat.exists* , i.e. when go is not installed.

#### 6. Copy go binary to destination directory
This task places the go binary in the bin_install_dir directory.

**copy**: This module copies the go binary and pastes it in bin directory

**when**: It runs when *not go_stat_result.stat.exists*, i.e. when go is not installed.

#### 7. Test go installation
This task runs `go version` to test installation is correct.
