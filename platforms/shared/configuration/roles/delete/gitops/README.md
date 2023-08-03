[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## clean/gitops
This role deletes all the gitops release files.

### Tasks:
#### 1. Delete release files
This task deletes all the files from the release directory.
##### Input Variables:
 - release_dir: A directory's path of deployed release, which may be deleted.

#### 2. Git Push
This task push changes into remote branch.
It calls role *{{ playbook_dir }}/../../shared/configuration/roles/git_push*

##### Input Variables:
 - GIT_DIR: A path of git directory. By default "{{ playbook_dir }}/../../../"
 - gitops: *item.gitops* from network.yaml
 - msg: A message for git commit
