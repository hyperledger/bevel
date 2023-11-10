[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: setup/float-environment/tasks
 This role creates enviorment for float cluster.

 ### Tasks
 (Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. "Setup flux for float cluster"
This task will setup the flux for float cluster.
##### Input Variables
- `kubeconfig_path` -  item.k8s can be found in your network yaml.
- `kubecontext` - Kubernetes cluster context.
- `git_username` - username of the GIT user 
- `git_password` - password of the GIT user
- `git_repo` - Repositories in GIT contain a collection of files of various different versions of a Project. These files are imported from the repository into the local server of the user for further updations and modifications in the content of the file.
- `git_branch` - List of branches.
- `git_path` - The path of the git repository.
- `git_host`- extract the hostname from the git_repo
- `ssh` - SSH refers to the suite of utilities that implement the SSH protocol.
- `helm_operator_version` - This show the  helm_operator_version.

---

#### 2. "Setup ambassador for float cluster"
This task will setup ambassador for float cluster.
#### Input Variables
- `item` - item can be found in network yaml.
- `kubeconfig_path` -  The config path of K8s cluster.
- `kubecontext` - Kubernetes cluster context.
- `aws` - item can be found in network yaml.

---

#### 3. "Create Storage Class"
This task create Storageclass that will be used for this deployment.
#### Input Variables
- `storageclass_name` - This is the name of the storageclass_name.
- `kubernetes` -  The resources of the K8s cluster (context and configuration file)
- `gitops` -*item.gitops* from `network.yaml`

---

#### 4. "Create namespace, service accounts and clusterrolebinding"
This task create namespace, service accounts and clusterrolebinding
#### Input Variables
- `component_ns` - The namespace from which to  Create namespace, service accounts and clusterrolebinding from the Kubernetes Cluster.
- `organisation` - name of the organisation.
- `kubernetes` - The resources of the K8s cluster (context and configuration file)
- `gitops` -*item.gitops* from `network.yaml`


---

#### 5. wait for the environment creation
This task will Wait for namespace creation for organisation.
#### Input Variables
- `component_type` - Which component type to check for, i.e. `Job` 
- `component_name` -  The exact name of the component
- `kubernetes` -The resources of the K8s cluster (context and configuration file).
- `type` - `retry` the role will keep retrying the check until it exists.

---

#### 6. Wait for vault-auth creation for organisation
This task will wait for vault-auth creation for organisation
#### Input Variables
- `component_type` - Which component type to check for, i.e. `Job` 
- `component_name` -  Contains name of resource
- `kubernetes` -The resources of the K8s cluster (context and configuration file).
- `type` - `retry` the role will keep retrying the check until it exists.

---

#### 7. "Wait for vault-reviewer creation for organisation"
This task will wait for vault-reviewer creation for organisation
#### Input Variables
- `component_type` - Which component type to check for, i.e. `Job` 
- `component_name` -  Contains name of resource
- `kubernetes` -The resources of the K8s cluster (context and configuration file).
- `type` - `retry` the role will keep retrying the check until it exists.

---

#### 8. "Wait for ClusterRoleBinding creation for organisation"
This task will wait for ClusterRoleBinding creation for organisation"
#### Input Variables
- `component_type` - This refers to the type of the component
- `component_name` -  Contains name of resource
- `kubernetes` - The resources of the K8s cluster (context and configuration file)
- `type` - `retry` the role will keep retrying the check until it exists.

---






