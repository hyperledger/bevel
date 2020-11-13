## ROLE: setup/notary
This role creates deployments file for notary and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. Wait for nmap pod to come up 
This task waits for the nmap service to be deployed before continuing, by calling the shared `check/helm_component` role.
##### Input variables
- `component_type` - The type of component to check for, i.e. `Pod`
- `namespace` - The namespace where the component is deployed
- `component_name` - The name of the component which is deployed
- `kubernetes` - The resources of the K8s cluster (context and configuration file)

---

#### 2. Create ambassador certificates for notary
This task creates the ambassador certificates for the notary by calling the `create/certificates/cenm` role.
##### Input Variables
- `tlscert_path` - The path where the TLS certificates will be stored
- `dest_path` - The destination path for the certificate file
- `service_name` - The name of the service (notary)

---

#### 3. Create value file for notary
This tasks creates deployment files for the notary by calling the `helm_component` role.
##### Input Variables
- `type` - notary
- `notary_service` - The name of the notary service
- `component_name` - The exact name of the component
- `name` - The name of the organisation
- `values_dir` - The directory where the release files are stored
- *`charts_dir` - path to Node registration charts
- `git_url` - The SSH URL of the GIT repository
- `git_branch` - The current working branch of the GIT repository
- `idman_url` - The URL to the idman
- `idman_domain` - The domain of the idman
- `networkmap_url` - The URL to the networkmap (nmap)
- `networkmap_url` - The domain of the networkmap (nmap)
- `corda_service_version` - `notary-{{ org.version }}`
- `p2p_port` - The notary p2p port
- `ambassador_p2pPort` - The notary ambassador p2p port    

---

#### 4. Push the created deployment files to repository
This tasks pushes the created value files into repository by calling the shared `git_push` role.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- *`GIT_REPO` - HTTPS URL for GIT repository, used for pushing deployment files; uses the variable `{{ gitops.git_push_url }}` from `network.yaml`
- *`GIT_USERNAME`: Username with access to the GIT repository; uses `{{ gitops.username }}` from `network.yaml`
- *`GIT_EMAIL`: Email associated with the username above; uses `{{ gitops.email }}` from `network.yaml`
- *`GIT_PASSWORD`: Password (most of the time access token) with write access to the GIT repository; uses `{{ gitops.password }}` from `network.yaml`
- *`GIT_BRANCH`: The name of the current branch, where the Helm releases are pushed; uses `{{ gitops.branch }}` from `network.yaml`
- `GIT_RESET_PATH`: The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
- `msg` - The commit message to use when pushing deployment files.
