## check/k8_component
This role is used for waiting to kubernetes component.

## Tasks:
### 1. Wait for {{ component_type }} {{ component_name }}
This Task is stated when *component_type* is *Namespace*, *ClusterRoleBinding* or *StorageClass*.
It uses *k8s_info* Ansible role.

#### Variables:
 - component_type: A type of component.
 - component_name: A name of component.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - kubernetes.context: Kubernetes context from network.yaml file.

#### Output Variables:
 - component_data: It holds number of running kubernetes components.
 
### 2. Wait for {{ component_type }} {{ component_name }}
This Task is stated when *component_type* is *ServiceAccount* or *ConfigMap*.
It uses *k8s_info* Ansible role.

#### Variables:
 - component_type: A type of component.
 - component_name: A name of component.
 - component_ns: A namespace of organization.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - kubernetes.context: Kubernetes context from network.yaml file.

#### Output Variables:
 - component_data: It holds number of running kubernetes components.
 
### 3. Wait for {{ component_type }} {{ component_name }}
This Task is stated when *component_type* is *Pod*.
It uses *k8s_info* Ansible role.

#### Variables:
 - component_type: A type of component.
 - component_name: A name of component.
 - component_ns: A namespace of organization.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - kubernetes.context: Kubernetes context from network.yaml file.

#### Output Variables:
 - component_data: It holds number of running pods.
 
### 4. Get a ServiceAccount token for {{ component_name }}
This task gets read-only Vault token via Kubernetes ServiceAccount
The task is started only when a variable *component_type* is *GetServiceAccount* 

#### Variables:
 - component_name: A name of ServiceAccount for read-only access to Vault.
 - component_ns: A namespace of organization.
 
#### Input Variables:
 - service_account: A name of ServiceAccount for read-only access to Vault.
 - role: A name of read only role. By default is *ro*
 
#### Output Variables:
 - token_output: Read-only Vault token.

### 5. Store token
This task create map for store read-only Vault token by organization.
Key is organization name and value is a token.
The task is started only when a variable *component_type* is *GetServiceAccount*

#### Variables:
 - token_output: A raw stored token from previous task.

#### Output Variables:
 - ac_vault_tokens: Map of read-only tokens by organization 