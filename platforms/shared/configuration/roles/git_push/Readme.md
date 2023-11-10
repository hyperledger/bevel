[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## git_push
This is a generic role to check-in files to git repository
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Execute git push via shell task
This task executes git push
##### Input Variables
    *GIT_DIR: Git Repo Path
    *GIT_USERNAME: Git Repo username
    *GIT_EMAIL: Email to use in git config
##### Output Variables

    GIT_OUTPUT: This variable stores the output of git push task.
**shell**: The following commands executes git push. Also to ignore the desired files it adds it to git reset path.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.


#### 2. Output for gitpush
This task Displays output of shell excution stored in *GIT_OUTPUT.stdout*.
**debug**: Used to display data on console output.

#### 3. Error for git_push
This task Displays output of shell excution stored in *GIT_OUTPUT.stderr*.
**debug**: Used to display data on console output.