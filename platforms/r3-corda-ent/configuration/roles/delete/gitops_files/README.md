[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: `delete/gitops_files`
This role deletes all the GITops release files.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

---

#### 1. Delete release files
This task deletes all the files from the release directory
##### Input Variables
- `*release_dir` - The release directory path
- `state` - absent (this deletes any found result)

---

#### 2. Git Push
This task pushes the current state to the GIT repo after deleting value files from `release_dir` by calling the `shared/configuration/roles/git_push` role.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- `GIT_RESET_PATH` - The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
- `gitops` - *item.gitops* from `network.yaml`
- `msg` - The commit message to use when pushing deployment files.
