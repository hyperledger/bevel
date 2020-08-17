## setup/vault_kubernetes
This role checks HashiCorp Vault for existing of admin-vault-auth SA. When this doesn't exist, then creates it.

## Tasks:
### 1. Check namespace is created
This task checking if namespaces for stewards of organizations are created.
It uses *k8s_info* Ansible role.

#### Variables:
 - component_ns: A name of namespace of organization.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - kubernetes.context: Kubernetes contex from network.yaml file.
### 2. Ensures build dir exists
This task check if *build* directory exists.
If directory doesn't exist, then creates it.
### 3. Check if Kubernetes-auth already created for Organization
This task lists auth methods in Vault. It uses installed vault binaries.
Result is stored in variable.

#### Environment variables:
 - VAULT_ADDR: Vault address, which is defined in variable *{{ vault.url }}*
 - VAULT_TOKEN: Vault token, which is defined in variable *{{ vault.root_token }}*
 
#### Output Variables:
 - auth_list: Ansible variable, where is stored output of this role, so list of auth methods.
### 4. Enable and configure Kubernetes-auth for Organization
This task enables auth method in Vault by name, which is in variable *{{ auth_path }}*.
This task is started, when auth method doesn't exist.

#### Variables:
 - auth_path: Vault auth method path.
 
#### Environment Variables:
 - VAULT_ADDR: Vault address, which is defined in variable *{{ vault.url }}*
 - VAULT_TOKEN: Vault token, which is defined in variable *{{ vault.root_token }}*
 
### 5. Get Kubernetes cert files for organizations
This task gets Kubernetes CA certificate from ServiceAccount by organization and store them into *build* directory.

#### Variables:
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - organization: A name of current organization.
 - component_ns: A name of namespace of organization.
 - auth_path: Vault auth method path.
 
#### Environment Variables:
 - VAULT_ADDR: Vault address, which is defined in variable *{{ vault.url }}*
 - VAULT_TOKEN: Vault token, which is defined in variable *{{ vault.root_token }}*
 
#### Output:
 - A certification stored in *./build/{{ organization }}.ca.cert* file.
### 6. Write reviewer token for Organizations
This task write reviewer token into Kubernetes auth method in Vault by organization

#### Input:
 - A certification stored in *./build/{{ organization }}.ca.cert* file. 

#### Variables:
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - organization: A name of current organization.
 - component_ns: A name of namespace of organization.
 
#### Environment Variables:
 - VAULT_ADDR: Vault address, which is defined in variable *{{ vault.url }}*
 - VAULT_TOKEN: Vault token, which is defined in variable *{{ vault.root_token }}*

### 7. Check if policy exists
This task check if policy of organization exists and store result into variable.

#### Variables:
 - organization: A name of current organization.
 
#### Environment Variables:
 - VAULT_ADDR: Vault address, which is defined in variable *{{ vault.url }}*
 - VAULT_TOKEN: Vault token, which is defined in variable *{{ vault.root_token }}*

#### Output Variables:
 - vault_policy_result - Stored output of this role.

### 8. Create policy for Access Control
This task creates a *.hcl* file from template *admin-rw.tpl*.
The *.hcl* file is for creating a access control policy in Vault.

#### Input:
 - admin-rw.tpl: A template for a policy

#### Output:
 - ./build/{{ organization }}-admin-rw.hcl: A hcl file ready for vault policy.
 
### 9. Write Policy to Vault
This task creates Vault policy from a *.hcl* file.
The task stats, when the policy doesn't exist.
It can be checked by variable *vault_policy_result*

#### Input:
 - ./build/{{ organization }}-admin-rw.hcl: A hcl file ready for vault policy.
 
#### Variables:
 - organization: A name of current organization.
 - vault_policy_result: Result of previous task for checking if policy exists in Vault.

#### Environment Variables:
 - VAULT_ADDR: Vault address, which is defined in variable *{{ vault.url }}*
 - VAULT_TOKEN: Vault token, which is defined in variable *{{ vault.root_token }}*
    
### 10. Create Vault auth role
This task creates auth role by auth method, Kubernetes ServiceAccount and Vault policy.

#### Variables:
 - auth_path: Vault auth method path.
 - organization: A name of current organization.
 - component_ns: A name of namespace of organization.
 
#### Environment Variables:
 - VAULT_ADDR: Vault address, which is defined in variable *{{ vault.url }}*
 - VAULT_TOKEN: Vault token, which is defined in variable *{{ vault.root_token }}*
