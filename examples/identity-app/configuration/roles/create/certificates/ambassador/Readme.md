## ROLE: create/certificates/ambassador
This role generates certificates for ambassador and places them in vault. Certificates are created using openssl. This also creates the Kubernetes secrets

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Call nested_main for each node in an organisation
This task calls nested_main
##### Input Variables
    *node_name: Name of the node
    *type: "trustees" or "endoresers"
**include_tasks**: It includes the name of intermediary task which is required for creating the ambassador certificates.
**loop**: loops over all the node in an organisation
**loop_control**: Specifies the condition for controlling the loop.

    loop_var: loop variable used for iterating over the loop.

---------------

### nested_main.yaml
This task initaiates the nested_main role for each node in the organisation
### Tasks
#### 1. Ensure ambassador tls dir exists
This tasks checks if the ambassador tls dir already created or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.

#### 2. Check if certs already created
This tasks checks if ambassador tls certificates are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore if any error occurs

##### Output Variables
    root_certs: This variable stores the output of root certificates check query.

#### 3. Get tls certs
This task fetches the generated tls certificates by calling role *get/crypto

##### Input Variables
    *cert_path: The path where to check/create is specified here.
    *vault_output: Yaml with root_certs output.
    
    
**when**: It runs when *root_certs.failed* == False, i.e. root CA certs are not present. 

#### 4. check root certs
This task checks for the existing root certs in the specified folder.

##### Input Variables
    *path: The path to check the root certificates.

##### Output variables
    *rootca_stat_result: The varaiable store the result of Root certificate query in local directory.

#### 5. Generate CAroot certificate
This task generates the Root CA certificates.

##### Input Variables
    *root_subject: Contains subject name defaulted in the playbook
    *cert_subject: The root_subject with / instead of ,

**shell**: It generates rootca.pem and rootca.key.
**when**:  It runs when *root_certs.failed* == True, i.e. when ambassador certs are not present. 

#### 6. Generate the openssl conf file
This task generates component openssl configuration file for ambassador.

##### Input Variables
    *domain_name: The name of the uri formed by attaching node_name with external_url_suffix.

**shell**: It goes to the ./build directory and generates component's openssl configuration file.
**when**: It runs when *root_certs.failed* == True, i.e. when ambassador certs are not present.

#### 7. Generate ambassador tls certs
This task generates the ambassador tls certificates.

##### Input Variables
    domain_name: Contains component name and  external_url_suffix, Fetched using 'item.' from network.yaml

**shell**: It generates ambassador.crt and ambassador.key.
**when**:  It runs when *root_certs.failed* == True, i.e. when ambassador certs are not present.. 


#### 8. Putting certs to vault
This task writes the root and ambassador tls certificates to Vault
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    *component_ns: The name of namespaces 
    *node_name: The name of the node in the organisation.

**shell**: It writes the generated certificates to the vault.
**when**:  It runs when *root_certs.failed* == True, i.e. ambassador certs are not present and are generated. 

#### 9. Check Ambassador cred exists
This tasks check if the Check Ambassador credentials exists or not.
##### Input Variables

    kind: This defines the kind of Kubernetes resource
    namespace: The namespace of the component
    *name: Name of the component 
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    get_ambassador_secret: This variable stores the output of Ambassador credentials check query.
    
#### 10. Create the Ambassador credentials
This task creates the Ambassador TLS credentials.
##### Input Variables
    *node_name: The name of resource
    *kubernetes.config_file: The config file of kubernetes cluster.

**shell**: The specified command creates ambassador credentials.
**when**: It runs when *get_ambassador_secret.resources* are not found.

#### Note: 
vars folder has environment variable for ambassador role.
