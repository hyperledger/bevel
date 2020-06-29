## ROLE: create/certificates/notary
This role download certificates from nms and loads into vault. Certificates are created using openssl.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Ensure build dir exists
This tasks checks if the build directory where notary certificates and key will be placed already created or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.

#### 2. Check if truststore already created
This task loads the certificates to vault.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    component_name: The name of resource i.e notary

##### Output variables
    truststore_result: This variable stores the output of write networkmapstore to vault query.

#### 3. Downloads certs from nms
This tasks downloads the certificates from NMS.
##### Input Variables

    url: path to nms truststore
    dest: path to metwork-map-truststore.jks
    validate_certs: whether to validate the jks file or not.

**when**:  It runs when *truststore_result.failed* == True, i.e. truststore is present . 

#### 4. Write networkmaptruststore to vault
This task loads the certificates to vault.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    component_name: The name of resource i.e notary

**when**:  It runs when *truststore_result.failed* == True, i.e. truststore is present .

#### 5. Check if certificates already created
This task check if certificates already created

##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    component_name: The name of resource, notary
    ignore_errors: Ignore if any error occurs

**shell**: It fetches customnodekeystore from vault.

##### Output Variables

    certs_result: This variable stores the output of notary customnodekeystore check query.

#### 6. Generate node certs
This task generates notary certificates using openssl

##### Input Variables
    notary_certs: Path to notary certificates
    component_name: The name of resource, notary

**shell**: It generates {{ component_name }}.cer, {{ component_name }}.key and  testkeystore.p12 file in the notary_certs directory.
**when**:  It runs when *certs_result.failed* == True, i.e. notary certs are not present .


#### 7. Write certificates to vault
This task generates the notary certificates.

##### Input Variables
    notary_certs: Path to notary certificate directory
    component_name: The name of resource, notary

**shell**: It generates nodekeystore.key and notary.cer file in the rootca directory.
**when**:  It runs when *certs_result.failed* == True and *rootca_stat_result.stat.exists* == False, i.e. notary certs are not present and notary key is also not present.

#### 8.  Check if doorman certs already created.
This task checks whether the doorman certs already created or not

##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    component_name: The name of resource, notary
    ignore_errors: Ignore ifany error occurs

**shell**: It fetches doorman.crt from vault.

##### Output Variables

    doorman_result: This variable stores the output of doorman certificates check query.

#### 9. Write certificates to vault.
This tasks writes doorman certificates to Vault.
##### Input Variables
    doorman_cert_file: Doorman certificate file.
    component_name: The name of re, notarysource

**when**:  It runs when *doorman_result.failed* == True and *doorman_cert_file* != '' i.e. doorman certs are not present and doorman certificate file is not empty . 

#### 10. Check if networkmap certs already created
This task checks whether the nms certs already created or not

##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    component_name: The name of  resource, notary
    ignore_errors: Ignore ifany error occurs

**shell**: It fetches networkmap.jks from vault.

##### Output Variables

    networkmap_result: This variable stores the output of nms certificates check query.

#### 11. Write certificates to vault
This task generates the networkmap certificates.

##### Input Variables
    nms_cert_file: Networkmap certificate file.
    component_name: The name of resource, notary

**when**:  It runs when *networkmap_result.failed* == True, i.e. nms certs are not present . 

#### 12. Write credentials to vault
This task writes the database, rpcusers, vaultroottoken, keystore and networkmappassword credentials in Vault.

##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    component_name: The name of node resource

**shell**:  It writes the database, rpcusers, vaultroottoken, keystore and networkmappassword credentials in Vault .

#### 13. Write cordapps credentials to vault
This task writes the corapps repository userpass credentials in Vault.

##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    component_name: The name of node resource

**shell**:  It writes the credentials in Vault.

**when**:  It runs when *cordapps_details* != "", i.e. cordapps repository details are provided in the configuration file.  

#### Note: 
vars folder has enviornment variable for notary role.
