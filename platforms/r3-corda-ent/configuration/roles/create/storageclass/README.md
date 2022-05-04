[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: `create/storageclass`
This role creates the storageclass value file for notaries and nodes

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

---

#### 1. Check if storageclass {{ storageclass_name }} exists
This task checsk if the storageclass already exists, by calling the `shared/configuration/roles/check/k8_component` role.
##### Input Variables
- `component_type` - the resource that has to be checked for in cluster, i.e StorageClass here.
- `component_name`: The name of the storageclass to check for.
- `type` - The type of check to do, in this case `no_retry`, which means only check once.

##### Output Variables
- `storageclass_state` - This variable stores the output of the check if the storageclass exists.

---

#### 2. Create storageclass
This task creates value file for storageclass by calling `create/k8_component` role.
##### Input Variables
- `*component_name` - The storageclass name.
- `component_type` - It specifies the type of deployment to be created. In this case it is `{{ cloudprovider }}storageclass`
- `helm_lint` - Flag which specifies if the `helm_lint` module needs to be run; `false` in this case since storageclass is not a Helm chart.
- `release_dir` - The absolute path to the release directory which is synced by Flux.

**when** - It runs when `storageclass_state.resources|length == 0`, i.e. storageclass doen not exists.

#### 3. Push the created deployment files to repository
This task pushes the generated deployment files to the GIT repository by calling `shared/configuration/roles/git_push` role.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- `GIT_RESET_PATH` - The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
- `gitops` - *item.gitops* from `network.yaml`
- `msg` - The commit message to use when pushing deployment files.

#### 4. Wait for Storageclass creation for {{ component_name }}
This task checks storageclass is created or not by calling role check/k8_component role. 
##### Input Variables
- `storageclass_name` -  The storageclass resource name.
- `component_name`: The name of the storageclass to check for.
- `type` - The type of check to do, in this case `retry`, which will keep checking for a max amount of retries (input from `network.yaml`) until the resource exists.

**when**:  It runs when `storageclass_state.resources|length == 0`, i.e. storageclass did not exists before.
