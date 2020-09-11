## ROLE: create/certificates/ambassador
This role generates certificates for ambassador and places them in vault. Certificates are created using openssl.This also creates the Kubernetes secrets

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Call nested_main for each node in an organisation
This task calls nested_main
##### Input Variables
    *node_name: Name of the node
**include_tasks**: It includes the name of intermediary task which is required for creating the ambassador certificates.
**loop**: loops over all the node in an organisation
**loop_control**: Specifies the condition for controlling the loop.

    loop_var: loop variable used for iterating over the loop.

---------------

### nested_main.yaml
This task initaiates the nested_main role for each node in the organisation
### Tasks
#### 1. Ensure rootca dir exists
This task check for the Root CA dir alreasy created or not, if not then creates one.
##### Input variables
    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.

#### 2. Ensure ambassador tls dir exists
This tasks checks if the ambassador tls dir already created or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.

#### 3. Check if root certs already created
This tasks checks if ambassador tls certificates are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore if any error occurs

##### Output Variables

    certs: This variable stores the output of root certificates check query.

#### 4. Check if ambassador tls certs already created
This tasks checks if ambassador tls certificates are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore if any error occurs

##### Output Variables

    certs: This variable stores the output of root certificates check query.

#### 5. Get root certs
This task fetches the generated root certificates by calling role *setup/get_crypto

##### Input Variables
    *cert_path: The path where to check/create is specified here.
    *vault_output: Yaml with root_certs output.
    type:  rootca
    
**when**: It runs when *root_certs.failed* == False, i.e. root CA certs are present. 

#### 6. check root certs
This task checks for the existing root certs in the specified folder.

##### Input Variables
    *path: The path to check the root certificates.

##### Output variables
    *rootca_stat_result: The varaiable store the result of Root certificate query in local directory.

#### 7. Generate CAroot certificate
This task generates the Root CA certificates.

##### Input Variables
    *cert_subject: Contains subject name Fetched from network.yaml

**shell**: It generates rootca.pem and rootca.key.
**when**:  It runs when *root_certs.failed* == True, i.e. ambassador certs are not present and are generated. 

#### 8. Putting root certs to vault
This task writes the rootca.pem and rootca.key to Vault
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_ns: The name of namespaces 

**shell**: It writes the generated certificates to the vault.
**when**:  It runs when *root_certs.failed* == True, i.e. ambassador certs are not present and the tls is on for the network. 

#### 9. Check if ambassador tls already created
This tasks checks if ambassador tls certificates are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore ifany error occurs
##### Output Variables

    ambassador_tls_certs: This variable stores the output of ambassador tls certificates check query.

#### 10. Get ambassador tls certs
This task fetches the generated ambassador tls certificates by calling role *setup/get_crypto

##### Input Variables
    *cert_path: The path where to check/create is specified here.
    *vault_output: Yaml with ambassador_tls_certs output.
    type:  ambassador 
    
**when**: It runs when *ambassador_tls_certs*.failed == False, i.e. ambassador tls certs are present.

#### 11. Generate the openssl conf file
This task generates component openssl configuration file.

##### Input Variables
    *domain_name: The name of the uri formed by attaching node_name with external_url_suffix.

**shell**: It goes to the ./build directory and generates component's openssl configuration file.
**when**: It runs when *ambassador_tls_certs.failed* == True, i.e. ambassador certs are not present and are generated.

#### 12. Generate ambassador tls certs
This task generates the ambassador tls certificates.

##### Input Variables
    domain_name: Contains component name and  external_url_suffix, Fetched using 'item.' from network.yaml

**shell**: It generates ambassador.crt and ambassador.key.
**when**:  It runs when *ambassador_tls_certs.failed* == True, i.e. ambassador certs are not present and are generated. 

#### 13. create tls credentials for besu
This task generates the tls keystore and files for besu node.

##### Input Variables
    common_name: Contains component name and  external_url_suffix, Fetched using 'item.' from network.yaml

**shell**: It generates ambassador.crt and ambassador.key.
**when**:  It runs when *network.config.tm_tls* == True, i.e. ambassador certs are not present and are generated. 

#### 14. putting ambassador certs to vault
This task writes the root and ambassador tls certificates to Vault
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_ns: The name of namespaces 
    *node_name: The name of the node in the organisation.

**shell**: It writes the generated certificates to the vault.
**when**:  It runs when *ambassador_tls_certs.failed* == True and *network.config.tm_tls* == False, i.e. ambassador certs are not present and the tls is off for the network. 

#### 15. Putting tls certs to vault
This task writes the root and ambassador tls certificates to Vault
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_ns: The name of namespaces 
    *node_name: The name of the node in the organisation.

**shell**: It writes the generated certificates to the vault.
**when**:  It runs when *ambassador_tls_certs.failed* == True and *network.config.tm_tls* == True, i.e. ambassador certs are not present and the tls is on for the network. 

#### 16. Check Ambassador cred exists
This tasks check if the Check Ambassador credentials exists or not.
##### Input Variables

    kind: This defines the kind of Kubernetes resource
    namespace: The namespace of the component
    *name: Name of the component 
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    get_ambassador_secret: This variable stores the output of Ambassador credentials check query.
    
#### 17. Create the Ambassador credentials
This task creates the Ambassador TLS credentials.
##### Input Variables
    *node_name: The name of resource
    *kubernetes.config_file: The config file of kubernetes cluster.

**shell**: The specified command creates ambassador credentials.
**when**: It runs when *get_ambassador_secret.resources* are not found.

#### Note: 
vars folder has environment variable for ambassador role.
