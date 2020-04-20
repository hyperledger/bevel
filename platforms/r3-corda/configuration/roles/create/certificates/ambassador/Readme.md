## ROLE: create/certificates/ambassador
This role generates certificates for ambassador and places them in vault. Certificates are created using openssl.This also creates the Kubernetes secrets

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Ensure ambassador tls dir exists
This tasks checks if the ambassador tls dir already created or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.

#### 2. Check if ambassador tls already created
This tasks checks if ambassador tls certificates are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore if any error occurs
##### Output Variables

    ambassador_tls_certs: This variable stores the output of ambassador tls certificates check query.

#### 3. Get ambassador tls certs
This task fetches the generated ambassador tls certificates by calling role *setup/get_crypto

##### Input Variables
    *cert_path: The path where to check/create is specified here.
    *vault_output: Yaml with ambassador_tls_certs output.
    type:  ambassador 
    
**when**: It runs when *ambassador_tls_certs*.failed == False, i.e. ambassador tls certs are present. 

#### 4. Generate openssl conf file
This task generates compoenent openssl configuration file.

##### Input Variables
    *domain_name: The name of the uri formed by attaching component_name with external_url_suffix.

**shell**: It goes to the ./build directory and generates component's openssl configuration file.
**when**: It runs when *ambassador_tls_certs.failed* == True, i.e. ambassador certs are not present and are generated.

#### 5. Generate ambassador tls certs
This task generates the ambassador tls certificates.

##### Input Variables
    domain_name: Contains component name and  external_url_suffix, fetched using 'item.' from network.yaml

**shell**: It generates ambassador.crt and ambassador.key.
**when**:  It runs when *ambassador_tls_certs.failed* == True, i.e. ambassador certs are not present and are generated. 

#### 6. Putting tls certs to vault
This task writes the ambassador tls certificates to Vault
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_name: The name of resource

**shell**: It writes the generated certificates to the vault.
**when**:  It runs when *ambassador_tls_certs.failed* == True, i.e. ambassador certs are not present and are generated. 

#### 7. Check Ambassador cred exists
This tasks check if the Check Ambassador credentials exists or not.
##### Input Variables

    kind: This defines the kind of Kubernetes resource
    namespace: The namespace of the component
    *name: Name of the component 
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    get_ambassador_secret: This variable stores the output of Ambassador credentials check query.
    
#### 8. Create the Ambassador credentials
This task creates the Ambassador TLS credentials.
##### Input Variables
    *component_name: The name of resource
    *kubernetes.config_file: The config file of kubernetes cluster.

**shell**: The specified command creates ambassador credentials.
**when**: It runs when *get_secret.resources* are not found.

#### Note: 
Var folder has enviornment variable for ambassador role.
