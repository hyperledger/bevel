[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

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

#### 3. Check if root directory where mongorootca certificates and key will be placed exists create one if the same doesn't exist
This tasks checks if root directory where mongorootca certificates and key will be placed exists or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory

#### 4. Check if root directory where mongodbca certificates and key will be placed exists create one if the same doesn't exist
This tasks checks if root directory where  mongodbca certificates and key will be placed exists or not.
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory

#### 5. Check if  root certs already created
This tasks checks if root certificates are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore ifany error occurs
##### Output Variables

    nms_root_certs: This variable stores the output of nms root certificates check query.

#### 6. Get networkmap root certs
This task fetches the nms root certificates by calling role *setup/get_crypto

##### Input Variables
    *cert_path: The path where to check/create is specified here.
    vault_output: Yaml with nms_root_certs output.
    type:  rootca 
    
**when**: It runs when *nms_root_certs*.failed == False, i.e. nms root certs are present. 

#### 7. Check root certs key.jks
This task checks whether the root certificates key.jks exists or not

##### Input Variables
    path: Path where nms root certificate's key.jks is present.
##### Output Variables

    rootca_stat_result: This variable stores the output of nms root certificates key.jks check query.


#### 8. Generate CA Root certificates
This task generates the CA Root certificates.

##### Input Variables
    rootca: Path to root CA directory

**shell**: It generates cordarootca.key and cordarootca.pem file in the rootca directory.
**when**:  It runs when *nms_root_certs.failed* == True and *rootca_stat_result.stat.exists* == False, i.e. root certs are not present and root key.jks is also not present. 

#### 9. Check networkmap certs is present in vault or not
This task checks whether the nms certs already created or not

##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore ifany error occurs

**shell**: It fetches networkmap.jks from vault.

##### Output Variables

    networkmap_certs: This variable stores the output of nms root certificates check query.

#### 10. Generate networkmap Root certificates
This task generates the NMS Root certificates.

##### Input Variables
    nmsca: Path to root CA directory

**shell**: It generates cordanetworkmap.key, cordanetworkmapcacert.pkcs12 and cordanetworkmap.pem file in the nmsca directory.
**when**:  It runs when *networkmap_certs.failed* == True, i.e. nms root certs are not present . 

#### 11. Check if mongoroot certs already created
This task checks if mongoroot certs already created
  
#### Input Variables
     *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore if any error occurs

**shell**: 
      It fetches mongodb.pem from vault.

**when** : It runs when services.nms.tls == 'on' i.e when mongoroot certs are present.

#### Output Variables

    mongodb: This variable stores the output of  mongoroot certificates check query.

#### 12. Check mongoroot certs
This task checks whether the mongoroot certificates mongoCA.crt exists or not

##### Input Variables
    path: Path where  mongoroot certificate's mongoCA.crt is present.
##### Output Variables

    mongoroot_stat_result: This variable stores the output of mongoroot certificates mongoCA.crt check query.

#### 13.Generating mongoroot certificates
This task generates the mongoroot certificates.

##### Input Variables
    mongorroot: Path to mongoroot directory

**shell**: It generates mongoCA.key file in the mongoroot directory.
**when**:  It runs when services.nms.tls == 'on' and mongoCA_stat_result.stat.exists == False and mongoCA_certs.failed == True. mongo root certs are not present .
  
#### 14. Check if mongodb certificate already created
This task checks if mongodb certificate already created
  
#### Input Variables
     *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore if any error occurs

**shell**: 
      It fetches mongodb.pem from vault.

#### Output Variables

    mongodb_certs: This variable stores the output of  mongodb certificates check query.

#### 15.Generating mongodb certificates
This task generates the mongodb certificates.

##### Input Variables
    mongodb: Path to mongodb directory

**shell**: It generates mongodb.key file in the mongodb directory.
**when**:  It runs when services.nms.tls == 'on' and  mongodb_certs.failed == True. mongodb_certs are not present .

#### 16. Putting certs to vault for root
This task will put certs to vault for root

#### Input Variables
      *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    
**shell**: It will put the certs for root  in vault .

#### 17.Putting certs and credential to vault for networkmap
This task will put the certs and credential to vault for networkmap.

#### Input Variables
     *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml

**shell**: It will put the certs and credential to vault for networkmap to vault.

**when**: It runs when networkmap_certs.failed == True i.e
when nms root certs are not present.

#### 18. Write the networkmap rootcakey ,cacerts and keystore to Vault.
This task writes the doorman rootcakey ,cacerts and keystore to Vault
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml

**shell**: It writes the generated certificates to the vault.
**when**:  It runs when *nms_root_certs.failed* == True, i.e. root certs are not present and are generated. 

#### 19. Write the networkmap certificates and credentials to Vault
This tasks writes networkmap certificates and credentials to Vault.
##### Input Variables
    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml

**shell**: It writes the generated networkmap certificates and credential to the vault.
**when**:  It runs when *networkmap_certs.failed* == True, i.e. networkmap certs are not present and are generated.
    
#### 20. Create the Ambassador certificates
This task creates the Ambassador certificates by calling create/certificates/ambassador role.
##### Input Variables
    component_name: The name of resource i.e networkmap

#### Note:
Var folder has enviornment variable for nms role.