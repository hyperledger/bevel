## ROLE: nms
This role generates certificates for networkmap and places them in vault. Certificates are created using openssl.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if root directory where CA root certificates and key will be placed exists create one if the same doesn't exist
This tasks checks if the root directory where CA root certificates and key will be placed already created or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory

#### 2. Check if root directory where networkmap root certificates and key will be placed exists create one if the same doesn't exist
This tasks checks if root directory where nms root certificates and key will be placed exists or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory

#### 3. Check if  root certs already created
This tasks checks if root certificates are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore ifany error occurs
##### Output Variables

    nms_root_certs: This variable stores the output of nms root certificates check query.

#### 4. Get networkmap root certs
This task fetches the nms root certificates by calling role *setup/get_crypto

##### Input Variables
    *cert_path: The path where to check/create is specified here.
    vault_output: Yaml with nms_root_certs output.
    type:  rootca 
    
**when**: It runs when *nms_root_certs*.failed == False, i.e. nms root certs are present. 

#### 5. Check root certs key.jks
This task checks whether the root certificates key.jks exists or not

##### Input Variables
    path: Path where nms root certificate's key.jks is present.
##### Output Variables

    rootca_stat_result: This variable stores the output of nms root certificates key.jks check query.


#### 6. Generate CA Root certificates
This task generates the CA Root certificates.

##### Input Variables
    rootca: Path to root CA directory

**shell**: It generates cordarootca.key and cordarootca.pem file in the rootca directory.
**when**:  It runs when *nms_root_certs.failed* == True and *rootca_stat_result.stat.exists* == False, i.e. root certs are not present and root key.jks is also not present. 

#### 7. Check networkmap certs is present in vault or not
This task checks whether the nms certs already created or not

##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore ifany error occurs

**shell**: It fetches networkmap.jks from vault.

##### Output Variables

    networkmap_certs: This variable stores the output of nms root certificates check query.

#### 8. Generate networkmap Root certificates
This task generates the Nms Root certificates.

##### Input Variables
    nmsca: Path to root CA directory

**shell**: It generates cordanetworkmap.key, cordanetworkmapcacert.pkcs12 and cordanetworkmap.pem file in the nmsca directory.
**when**:  It runs when *networkmap_certs.failed* == True, i.e. nms root certs are not present . 

#### 9. Write the networkmap rootcakey ,cacerts and keystore to Vault.
This task writes the doorman rootcakey ,cacerts and keystore to Vault
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml

**shell**: It writes the generated certificates to the vault.
**when**:  It runs when *nms_root_certs.failed* == True, i.e. root certs are not present and are generated. 

#### 10. Write the networkmap certificates and credentials to Vault
This tasks writes networkmap certificates and credentials to Vault.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml

**shell**: It writes the generated networkmap certificates and credential to the vault.
**when**:  It runs when *networkmap_certs.failed* == True, i.e. networkmap certs are not present and are generated.
    
#### 11. Create the Ambassador certificates
This task creates the Ambassador certificates by calling create/certificates/ambassador role.
##### Input Variables
    component_name: The name of resource i.e networkmap

#### Note:
Var folder has enviornment variable for nms role.