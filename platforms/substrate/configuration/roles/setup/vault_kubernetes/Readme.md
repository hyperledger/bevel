[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: vault_kubernetes
This role setups communication between the vault and kubernetes cluster and install neccessary configurations.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if namespace is created
This tasks check if the namespace is already created or not.
##### Input Variables
    kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    get_namespace: This variable stores the output of namespace query.
  **until**: This condition checks until *get_namespace.resources* variable exists
  **retries**: No of retries
  **delay**: Specifies the delay between every retry

#### 2. Check if Kubernetes-auth already created for Organization
This task checks if the vault path already exists.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
**environment** : It includes the list of environment variables.
**shell** : This command lists the auth methods enabled. The output lists the enabled auth methods and options for those methods.
**vault* : This variable contains details of vault from network.yaml. It comes from previous calling playbook(deploy-network,yaml) 

##### Output Variables
    auth_list: Stores the list of enables auth methods

#### 3. Check if policy exists
This task checks if the vault-ro policy already exists
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource
**shell** : This command reads the vault and checks if the policy exists.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

##### Output Variables
    vault_policy_result: Stores the result of policy check shell command.

#### 4. Ensures build dir exists
This task creates the build temp directory.
##### Input Variables
    path: The path where to check is specified here.
    recurse: Yes/No to recursively check inside the path specified. 

#### 5. Create vault_kubernetes secrets tokens
This task creates secrets for the root token and the reviewer token
##### Input Variables
    *namespace: "Namespace of org , Format: {{ item.name |lower }}-net"
    *vault: "Vault Details"
    *kubernetes: "{{ item.k8s }}"
**include_role**: It includes the name of intermediatory role which is required for creating the secrets, here `k8s_secret`.

### 6. Get the kubernetes server url
This role get url address of Kubernetes server and store it into variable.
##### Input Variables
    *KUBECONFIG: Contains config file of cluster, Fetched using 'kubernetes.' from network.yaml
**shell** : This command get url address of Kubernetes server.
 
#### Output Variables:
    kubernetes_server_url: Stored url address of Kubernetes server.

#### 7. Create value file for chaincode commit
This is the nested Task for chaincode commit.
##### Input Variables
    *name: "Name of the organisation"
    *type: "vault_k8s_mgmt"
    *component_name: Name of the component, "{{ item.name | lower}}}}-vaultkubernetes-job"
    *component_type: Type of the component, "{{ item.type | lower}} }}"
    *component_ns: "Namespace of organisation , Format: {{ item.name | lower}}-net"
    *git_url: "Git SSH url"
    *git_branch: "Git Branch Name"
    *charts_dir: "Path of Charts Directory"
    *vault: "Vault Details"
    *k8s: "Kubernetes Details"
    *kubernetes_url: "url address of Kubernetes server"
    *values_dir: "Destination directory"
**include_role**: It includes the name of intermediatory role which is required for creating the helm value file, here `helm_component`.

#### 8. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GGIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
