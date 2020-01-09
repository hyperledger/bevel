## ROLE: doorman
This role generates certificates for doorman and rootca and places them in vault. Certificates are created using openssl.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if root directory where CA root certificates and key will be placed exists create one if the same doesn't exist
This tasks checks if the root directory where CA root certificates and key will be placed already created or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory

#### 2. Check if root directory where Doorman root certificates and key will be placed exists create one if the same doesn't exist
This tasks checks if root directory where Doorman root certificates and key will be placed exists or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory

#### 3. Check if doorman root certs already created
This tasks checks if doorman root certificates are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore ifany error occurs
##### Output Variables

    root_certs: This variable stores the output of doorman root certificates check query.

#### 4. Get doorman root certs
This task fetches the doorman root certificates by calling role *setup/get_crypto

##### Input Variables
    *cert_path: The path where to check/create is specified here.
    vault_output: Yaml with root_certs output.
    type:  rootca 
    
**when**: It runs when *root_certs*.failed == False, i.e. doorman root certs are present. 

#### 5. Check doorman root certs key.jks
This task checks whether the doorman root certificates key.jks exists or not

##### Input Variables
    path: Path where doorman root certificate's key.jks is present.
##### Output Variables

    rootca_stat_result: This variable stores the output of doorman root certificates key.jks check query.


#### 6. Generate CA Root certificates
This task generates the CA Root certificates.

##### Input Variables
    rootca: Path to root CA directory

**shell**: It generates cordarootca.key and cordarootca.pem file in the rootca directory.
**when**:  It runs when *root_certs.failed* == True and *rootca_stat_result.stat.exists* == False, i.e. root certs are not present and root key.jks is also not present. 

#### 7. Check doorman certs is present in vault or not
This task checks whether the doorman certs already created or not

##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore ifany error occurs

**shell**: It fetches doorman.jks from vault.

##### Output Variables

    doorman_certs: This variable stores the output of doorman root certificates check query.

#### 8. Generate Doorman Root certificates
This task generates the Doorman Root certificates.

##### Input Variables
    doormanca: Path to root CA directory

**shell**: It generates cordadoormanca.key, cordadoormancacert.pkcs12 and cordadoormanca.pem file in the doormanca directory.
**when**:  It runs when *doorman_certs.failed* == True, i.e. doorman root certs are not present . 

#### 9. Write the doorman rootcakey ,cacerts and keystore to Vault.
This task writes the doorman rootcakey ,cacerts and keystore to Vault
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml

**shell**: It writes the generated certificates to the vault.
**when**:  It runs when *root_certs.failed* == True, i.e. root certs are not present and are generated. 

#### 10. Write the doorman certificates and credentials to Vault
This tasks writes doorman certificates and credentials to Vault.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml

**shell**: It writes the generated doorman certificates and credential to the vault.
**when**:  It runs when *doorman_certs.failed* == True, i.e. doorman certs are not present and are generated.
    
#### 11. Create the Ambassador certificates
This task creates the Ambassador certificates by calling create/certificates/ambassador role.
##### Input Variables
    component_name: The name of resource i.e doorman

#### Note: 
Var folder has enviornment variable for doorman role.