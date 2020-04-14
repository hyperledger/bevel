## ROLE: create/certificates/doorman
This role generates certificates for doorman and rootca and places them in vault. Certificates are created using openssl.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Ensure rootca dir exists
This tasks checks if the rootca directory where CA root certificates and key will be placed already created or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory

#### 2. Ensure doormanca dir exists
This tasks checks if doormanca directory where Doorman root certificates and key will be placed exists or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory

#### 3. Ensure mongorootca dir exists
This tasks checks if mongorootca directory where mongodb root certificates and key will be placed exists or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory

**when**: *services.doorman.tls* == 'on', i.e when tls for doorman is on.

#### 4. Ensure mongodbca dir exists
This tasks checks if mongodbca directory where mongodbca certificates and key will be placed exists or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory

**when**: *services.doorman.tls* == 'on', i.e when tls for doorman is on.

#### 5. Check if root certs already created
This tasks checks if root certificates are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore ifany error occurs
##### Output Variables

    root_certs: This variable stores the output of  root certificates check query.

#### 6. Get root certs
This task fetches the  root certificates by calling role *setup/get_crypto

##### Input Variables
    *cert_path: The path where to check/create is specified here.
    *vault_output: Yaml with root_certs output.
    type:  rootca 
    
**when**: It runs when *root_certs*.failed == False, i.e. doorman root certs are present. 

#### 7. check root certs
This task checks whether the doorman root certificates key.jks exists or not

##### Input Variables
    path: Path where doorman root certificate's key.jks is present.
##### Output Variables

    rootca_stat_result: This variable stores the output of doorman root certificates key.jks check query.


#### 8. Generate CAroot certificate
This task generates the CA Root certificates.

##### Input Variables
    rootca: Path to root CA directory

**shell**: It generates cordarootca.key and cordarootca.pem file in the rootca directory.
**when**:  It runs when *root_certs.failed* == True and *rootca_stat_result.stat.exists* == False, i.e. root certs are not present and root key.jks is also not present. 

#### 9. Check if doorman certs already created
This task checks whether the doorman certs already created or not

##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore ifany error occurs

**shell**: It fetches doorman.jks from vault.

##### Output Variables

    doorman_certs: This variable stores the output of doorman root certificates check query.

#### 10. Generate DoormanCA from generated root CA certificate
This task generates the Doorman CA certificates.

##### Input Variables
    doormanca: Path to root CA directory

**shell**: It generates cordadoormanca.key, cordadoormancacert.pkcs12 and cordadoormanca.pem file in the doormanca directory.
**when**:  It runs when *doorman_certs.failed* == True, i.e. doorman root certs are not present . 

#### 11. Check if mongoroot certs already created
This tasks checks if mongoroot certificates are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore ifany error occurs
##### Output Variables

    mongoCA_certs: This variable stores the output of  mongoCA certificates check query.

**when**: It runs when *services.doorman.tls* = 'on', i.e. tls is on for doorman. 

#### 12. Generating Mongoroot certificates
This task generates the Mongoroot certificates.

##### Input Variables
    mongorootca: Path to mongoroot CA directory

**shell**: It generates mongoCA.key, mongoCA.crt in mongorootca directory.
**when**:  It runs when *services.doorman.tls* == True && *mongoCA_certs*.failed == True i.e. certificates are not in vault.

#### 13. Check if mongodb certs already created
This task checks whether the mongodb certs already created or not

##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore ifany error occurs

**shell**: It fetches doorman.jks from vault.

##### Output Variables

    mongodb_certs: This variable stores the output of doorman root certificates check query.

**when**: It runs when *services.doorman.tls* == 'on', i.e. tls is on for doorman.

#### 14. Generating mongodb certificates
This task generates the mongodb certificates.

##### Input Variables
    mongodbtca: Path to mongodb CA directory

**shell**: It generates mongoCA.key, mongoCA.crt in mongorootca directory.
**when**:  It runs when *services.doorman.tls* == True and *mongodb_certs*.failed == True i.e. certificates are not in vault.

#### 15. Putting certs to vault for root
This task writes the doorman rootcakey ,cacerts and keystore to Vault
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml

**shell**: It writes the generated certificates to the vault.
**when**:  It runs when *root_certs.failed* == True, i.e. root certs are not present and are generated. 

#### 16. Putting certs and credential to vault for doorman
This tasks writes doorman certificates and credentials to Vault.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml

**shell**: It writes the generated doorman certificates and credential to the vault.
**when**:  It runs when *doorman_certs.failed* == True, i.e. doorman certs are not present and are generated.
    
#### 17. Create Ambassador certificates
This task creates the Ambassador certificates by calling create/certificates/ambassador role.


#### Note: 
vars folder has enviornment variable for doorman role.
