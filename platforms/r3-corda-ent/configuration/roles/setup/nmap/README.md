[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: `setup/nmap`
This role creates deployment file for the Networkmap (nmap) and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. Check if the networkmap certs are already created
This tasks checks if the networkmap certificates are already created and stored in the vault
##### Input Variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
##### Output Variables:
-  `nmap_certs` - Variable that stores the result of the command (`nmap_certs.failed` will be `true` when the certs do not exist yet)

**ignore_errors** is yes because certificates are not created for a fresh network deployment and this command will fail.

---

#### 2. Waiting for `pki-generator` job to be completed
This tasks waits for pki-generator job to be completed calling shared/configuration/roles/check/helm_component role.
##### Input Variables
- `component_type` - Which component type to check for, i.e. `Job` 
- `namespace` - The namespace where the `Job` to wait for, is created
- *`component_name` - Contains name of resource
- `kubernetes` - The resources of the K8s cluster (context and configuration file)

**when**: It runs when **nmap_certs.failed** variable is `true`

---

#### 3. "Create networkmap ambassador certificates"
This task will create the Ambassador certificates for Networkmap by calling the `create/certificates/cenm` role.
##### Input variables
- `tlscert_path` - The path where the TLS certificates will be stored
- `dest_path` - The destination path for the certificate file
- `service_name` - The name of the service (networkmap)

---

#### 4. Get the network-root-truststore
This task gets the `network-root-truststore.jks` file from the Vault
#### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
- `cert_path` - The path on which the truststore will be saved

---

#### 5. Check if the notary-registration is already completed
This tasks checks if the notary files are already created and stored in the vault
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
##### Output variables:
- notary_certs - Stores the status of the certificates in the vault

ignore_errors is yes because certificates are not created for a fresh network deployment and this command will fail.

---

#### 6. Create value file for notary registration job
This tasks creates the value file for notary registration by calling `setup/notary-initial-registration` role.

**when**: It runs when **notary_certs.failed** variable is true

---

#### 7. Waiting for notary initial registration job to complete
This tasks waits for notary-initial-registration job to be completed calling `shared/configuration/roles/check/helm_component` role.
##### Input Variables
- `component_type` - Which component type to check for, i.e. `Job` 
- `namespace` - The namespace where the `Job` to wait for, is created
- *`component_name` - Contains name of resource
- `kubernetes` - The resources of the K8s cluster (context and configuration file)

**when**: It runs when **notary_certs.failed** variable is true

---

#### 8. "create nmap value files"
This tasks creates deployment file for nmap node by calling the `helm_component` role.
##### Input Variables
- `type` - The type of component, i.e. `nmap`
- *`name` - The name of the organization
- *`component_name` - The exact name of the component
- *`charts_dir` - path to nmap charts
- `values_dir` - The directory where the release files are stored
- `corda_service_version` - `idman{{ org.version }}`, this is used to find the Docker image from `helm_component/vars`
- *`idman_url` - The public URL of the Idman (with external URL suffix) 
- `helm_lint` - Whether to lint the Helm chart, i.e. `true`

---

#### 9. "Push the created deployment files to repository"
This task pushes the created value files into repository by calling the `git_push` role from shared.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- `gitops` - *item.gitops* from `network.yaml`
- `msg` - The commit message to use when pushing deployment files.
