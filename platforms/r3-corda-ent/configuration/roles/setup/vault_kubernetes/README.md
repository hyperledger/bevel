[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: `setup/vault_kubernetes`
This role sets up the communication between the Vault and Kubernetes cluster and installs the necessary configuration.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

---

#### 1. Creating the build directory
This task creates the `./build` directory by calling the shared `check/directory` role.
##### Input variables
- `path` - The path to create, i.e. `./build`

---

#### 2. Check if the Vault path already exists
This task checks whether the auth path already exists on the Vault.
##### Input variables
- `check` - What exactly to setup/check, i.e. `vault_auth`

----

#### 3. Get auth_lists and check for component_auth
This task (split up in multiple smaller tasks) will get the `auth_lists` and then check if `component_auth` is one of them.
#### Output variables 
- `vault_auth_status` - This variable will be true if `component_auth` exists.

---

#### 4. Vault Auth enable for organisation
This task enables the path for the nodes on the Vault.
##### Input Variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
- *`component_auth` - Contains the auth path

**when** - This task is only run when `vault_auth_status` is `false`, when `component_auth` is *NOT* in the output of `auth_list`

**ignore_errors** - This flag ignores any errors that occur and proceeds further with the task

---

#### 5. Get Kubernetes cert files for organizations
This task gets the certificate files for the cluster and puts them in the local build directory
##### Input Variables
- *`config_file` - The configuration file used for communication with the K8s cluster.
- *`component_ns` - The namespace of the resource, where the secrets also are stored.

**when** - The task only runs when the *component_auth* is not created

---

#### 6. Write reviewer token
This task writes the Service Account token to the Vault for various Corda Enterprise entities.
##### Input Variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
- *`config_file` - The configuration file used for communication with the K8s cluster.
- *`component_ns` - The namespace of the resource, where the service account tokens also are stored.

**when** - The task only runs when the *auth_path* is not created

---

#### 7. Check if the vault policies already exist
This task checks if the vault policies already exist by calling the shared `check/setup` role. 
##### Input variables
- `check` - What exactly to check/setup, i.e. `vault_policies`
##### Output variables
- `vault_policy_result` - This variable stores the result of the check, i.e. will be `true` when the vault policies exist.

**ignore_errors** - This task will ignore any errors and continue with the task.

---

#### 8. Create policy for Access Control for the nodes
This task checks for the vault secret path and then writes the policies to the Vault.
##### Input Variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path

**when** - This task only runs when `component_type == 'node'` and `vault_policy_result.failed == True` (the Vault policies do not exist yet)

---

#### 9. Create Vault auth role
This task creates the Vault auth role.
##### Input Variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
- *`component_path` - The path of the resource
- *`component_name` - The name of the resource

**when** - This task only runs when `not vault_auth_status` (the `auth_path` is not found)

---

#### 10. Check if the Docker credentials already exist
This task checks if the Docker credentials exists for any namespace by calling the shared `check/setup` role.
##### Input Variables
- `check` -  What exactly to setup/check, i.e. `docker_credentials`
##### Output Variables
- `get_regcred` - This variable stores the output of the check for the Docker credentials
    
---

#### 11.  Create the docker pull credentials
This task creates the Docker credentials if they do not exist yet.
##### Input Variables
- *`config_file` - The configuration file used for communication with the K8s cluster.
- *`component_ns` - The namespace where the Docker credentials need to be created. 
- *`network.docker` - The Docker information (repository, username, password) provided in the `network.yaml`

**when** - This task only runs when `get_regcred.resources|length == 0`, when the Docker credentials do not exist yet.
