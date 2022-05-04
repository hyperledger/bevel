[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: `setup/zone`
This role creates deployment file for zone and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. Check if the idman ssl certs are already created
This task checks if the idman ssl certificates have already been created (written to the Vault).
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
##### Output variables
- `idman_certs` - Variable that stores the result of the command (`idman_certs.failed` will be `true` when the certs do not exist yet)
    
---

#### 2. Wait for pki-generator job to be completed 
This task waits for the idman service to be deployed before continuing, by calling the shared `check/helm_component` role.
##### Input variables
- `component_type` - The type of component to check for, i.e. `Pod`
- `namespace` - The namespace where the component is deployed
- `component_name` - The name of the component which is deployed
- `kubernetes` - The resources of the K8s cluster (context and configuration file)

**when** - This task is only run when there are no idman ssl certificates yet, (e.g. `idman_certs.failed == true`)

----

#### 3. Create deployment file for CENM zone service
This task creates deployment file for zone service by calling the `helm_component` role.
##### Input Variables
- `type` - The type of component to deploy, i.e. `zone`
- `chart` - The name of the chart, i.e. `zone`
- `name` - The name of the organisation
- `component_name` - The exact name of the component
- *`charts_dir` - The path to zone charts
- `vault` - The information of the Vault for the organisation
- `component_auth` - The auth of the component
- `values_dir` - The directory where the release files are stored
- `helm_lint` - Whether to lint the Helm chart, i.e. `true`    

---

#### 4. Push the created deployment files to repository
This tasks pushes the created value files into repository by calling the shared `git_push` role.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- `GIT_RESET_PATH` - The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
- `gitops` - *item.gitops* from `network.yaml`
- `msg` - The commit message to use when pushing deployment files.
