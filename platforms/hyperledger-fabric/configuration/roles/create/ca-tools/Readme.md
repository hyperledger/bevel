[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: ca-tools
This role creates helm release value file for the deployment of CA Tools CLI.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check CA-server is available
This tasks checks if CA server is available or not and waits for the CA server to be available.
##### Input Variables


    kind: This defines the kind of Kubernetes resource
    *name: Name of the component 
    *namespace: The namespace of the component.
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables
    get_ca: This variable stores the output of ca server check query.
    
  **until**: This condition checks until *get_ca.resources* exists
  **retries**: No of retries
  **delay**: Specifies the delay between every retry

#### 2. Create ca-tools secrets tokens
This task creates secrets for the root token and the reviewer token
##### Input Variables
    *namespace: "Namespace of org , Format: {{ item.name |lower }}-net"
    *vault: "Vault Details"
    *kubernetes: "{{ item.k8s }}"
**include_role**: It includes the name of intermediatory role which is required for creating the secrets, here `k8s_secrets`.

#### 3. Create CA-tools Values file
This task creates the CA-tools value files for orderer.
##### Input Variables
    *name: The name of resource
    *type: "ca-tools"
    *org_name: "Name of the organization in lowercase"
    *component_type: "Type of the organization (orderer or peer)"
    *vault: "Vault Details"
    *external_url_suffix: "External url of the organization"
    *component_subject: "Subject of the organization"
    *cert_subject: Contains subject name Fetched from network.yaml
    *component_country: "Country of the organization"
    *component_state: "State of the organization"
    *component_location: "Location of the organization"
    *ca_url: "Ca url of the organization"
    *proxy: "The proxy/ingress provider"
    *git_url: "The URL of git repo"
    *git_branch: "Git repo branch name"
    *charts_dir: "The path of chart files"
    *orderers_list: "orderer's names"
    
**include_role** : It includes the name of intermediatory role which is required for creating the CA Tools value file.
**when**: Condition is specified here, runs only when *component_type* is orderer.

#### 4. Create CA-tools Values file
This task creates the CA-tools value files for peer.
##### Input Variables
    *name: The name of resource
    *type: "ca-tools"
    *org_name: "Name of the organization in lowercase"
    *component_type: "Type of the organization (orderer or peer)"
    *vault: "Vault Details"
    *external_url_suffix: "External url of the organization"
    *component_subject: "Subject of the organization"
    *cert_subject: Contains subject name Fetched from network.yaml
    *component_country: "Country of the organization"
    *component_state: "State of the organization"
    *component_location: "Location of the organization"
    *ca_url: "Ca url of the organization"
    *proxy: "The proxy/ingress provider"
    *git_url: "The URL of git repo"
    *git_branch: "Git repo branch name"
    *charts_dir: "The path of chart files"
    
**include_role** : It includes the name of intermediatory role which is required for creating the CA Tools value file.
**when**: Condition is specified here, runs only when *component_type* is peer.

#### 5. Git Push
This task pushes the above generated value files to git repo.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"

#### 6. Create the Ambassador credentials
This task creates the Ambassador TLS credentials
##### Input Variables
    *namespace: "Namespace of org , Format: {{ item.name |lower }}-net"
    *vault: "Vault Details"
    *kubernetes: "{{ item.k8s }}"
**include_role**: It includes the name of intermediatory role which is required for creating the secrets, here `k8s_secrets`.
**when**: Condition is specified here, runs only when *network.env.proxy* is ambassador and *component_type* is orderer

#### 7. Copy the the msp folder from the ca tools
This task copies the msp folder from the respective CA Tools CLI to the Ansible container
##### Input Variables
    *component_name: The name of the resource
    *component_type: "Type of the organization (orderer or peer)"
    *KUBECONFIG: The config file of kubernetes cluster.
**shell** : The specified commands copies the msp folder from the respective CA Tools CLI.
**when**: Condition is specified here, runs only when *component_type* is orderer.

#### 8. Copy tls server.crt file from the ca tools
This task copies tls server.crt file from the respective CA Tools CLI to the Ansible container
##### Input Variables
    *component_name: The name of the resource
    *component_type: "Type of the organization (orderer or peer)"
    *orderer.name: "orderer's name"
    *KUBECONFIG: The config file of kubernetes cluster.
**shell** : The specified commands copies the generated crypto material from the respective CA Tools CLI.
**when**: Condition is specified here, runs only when *component_type* is orderer.
