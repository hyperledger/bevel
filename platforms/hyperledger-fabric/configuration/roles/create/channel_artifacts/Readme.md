## ROLE: channel_artifacts
 This role generate genesis block and channel

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check configtxgen
This task checks if configtxgen is present or not.
##### Input Variables

    *build_path: The path of build directory.
##### Output Variables
    config_stat_result: This variable stores the output of configtxgen check query.

#### 2. Geting the configtxgen binary tar
This task creates a register temporary directory
##### Input Variables
    *fabric.os: Type of OS
    *fabric.arch: Architecture Type
    *network.version: Network version
    *tmp_directory.path: Temo Directory Path
**url**: The Url of the binary to download
**dest**: The destination path.
**when**: Condition specified here, It runs only when, configtxgen binary is not found.

#### 3. Unzipping the downloaded file
This task unzips the downloaded file.
##### Input Variables
    *fabric.os: Type of OS
    *fabric.arch: Architecture Type
    *network.version: Network version
    *tmp_directory.path: Temp Directory Path
**src**: The source of the downloaded binary
**dest**: The destination path for unzip.
**when**: Condition specified here, It runs only when, configtxgen binary is not found.

#### 4. Moving the configtxgen from the extracted folder and place in it path
This task extracts the configtxgen binary and place it at appropriate path.
##### Input Variables
    *build_path: The path of build directory.
    *tmp_directory.path: Temp Directory Path
**src**: The source of the extracted binary
**dest**: The destination for the extracted binary.
**mode**: The permission for file is specified here.
**when**: Condition specified here, It runs only when, configtxgen binary is not found.

#### 5. Remove old genesis block
This task removes the old genesis block.
##### Input Variables

    *build_path: The path of build directory.
**path**: The path for genesis block
**state**: Used to specify state. (absent, meaning it will remove the file).

#### 6. Creating channel-artifacts folder
This task Creates channel-artifacts folder.
##### Input Variables

    *build_path: The path of build directory.
**path**: The path for genesis block
**state**: Used to specify state. (directory, meaning it will create).

#### 7. Creating genesis block
This task Creates the genesis block.
##### Input Variables

    *build_path: The path of build directory.
**shell**: The command goes to build path and creates the genesis block by consuming the configtx.yaml file.

#### 8. Remove old channel block
This task removes the old channel block.
##### Input Variables

    *build_path: The path of build directory.
    *channel_name: The name of the channel.
**path**: The path for the channel block
**state**: Used to specify state. (absent, meaning it will remove the file).

#### 9. Creating channels
This task Creates channel by consuming the configtx.yaml file.
##### Input Variables

    *build_path: The path of build directory.
    *profile_name: Name of Profile
    *channel_name: The name of the channel
**shell**: The command goes to build path and creates the channel by consuming the configtx.yaml file.

#### 10. Creating Anchor artifacts
This task creates the anchortx files.
##### Input Variables

    *build_path: The path of build directory.
    *profile_name: Name of Profile
    *channel_name: The name of the channel
**shell**: The command goes to build path and creates the anchortx file.


#### 11. Creating JSON Configuration
This task Creates JSON configuration file by consuming the configtx.yaml file.
##### Input Variables

    *build_path: The path of build directory.
    *profile_name: Name of Profile
    *channel_name: The name of the channel
    *participant: The new organization 
**shell**: The command goes to build path and creates the channel by consuming the configtx.yaml file.
