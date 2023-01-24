[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## helm_lint
This is a generic role test for helm value files
Inputs are:

    helmtemplate_type: The type of helmtemple, this matches to the chart name
    chart_path: Helm chart directory path (absolute to project root)
    value_file: Helmrelease value file path (absolute to project root)
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if value file exists
This task checks if the value file exists
##### Input Variables
    *value_file: The path to the value file
##### Output Variables

    value_stat_result: This variable stores the output of value file check query.

#### 2. Check or create test directory
This task checks or create test directory if not found.
##### Input Variables
    *path: The path of temp directory
    recurse: Yes/No to recursively check inside the path specified. 
**when**: It runs when *value_stat_result.stat.exists* is True i.e. value file is found.

#### 3. Load file into memory
This task loads value file into memory.
##### Input Variables
    *value_file: The path to the value file
**when**: It runs when *value_stat_result.stat.exists* is True i.e. value file is found.

#### 4. Create value file
This task creates the helmvalue file to run test.
**local_action**: Copies the content to a helm value file.
**when**: It runs when *value_stat_result.stat.exists* is True i.e. value file is found.

#### 3. Run Helm lint
This task  Execute helm lint. If this fails, fix the errors.
##### Input Variables
    *playbook_dir: The path to the playbook directory.
    *chart_path: The path to the charts directory.
**shell**: This command runs helm lint and chaecks the validity of the file.
**when**: It runs when *value_stat_result.stat.exists* is True i.e. value file is found.
