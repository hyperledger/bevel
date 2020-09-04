## ROLE: create/certificates/cenm
This role generates the ambassador proxy certificates and Kubernetes secret required for inter cluster communication.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if the ambassador tls directory exists
This tasks checks if the ambassador tls directory exists or not
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.
##### Output Variables

    ambassadordir_check: Variable which stores the status of the directory presence

#### 2. Create the ambassador directory if it doesn't exist
This tasks create the ambassador directory if it doesn't exist
##### Input Variables

    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.

**when**: It runs when **ambassadordir_check** variable exists

#### 3. Check if the ambassador tls is already created
This tasks checks if the ambassador tls is already created and stored in the vault
##### Input Variables

    VAULT_ADDR: The vault address
    VAULT_TOKEN: Vault root/custom token which has the access to the path
##### Output Variables:

    ambassador_tls_certs: Stores the status of the ambassador tls certificates in the vault

#### 4. Get the ambassador certs if they exist
This tasks fetches the ambassador certificates, if they are present in the vault
##### Input Variables

    vault_output: Stores the vault output in yaml format
    cert_path: Path where the ambassador certificates are fetched to

**when**: It runs when **ambassador_tls_certs.failed** variable is False

#### 5. Check if the openssl conf file exists or not
This tasks check if the openssl file for the idman exists on the given path
##### Input Variables

    path: The path to the opensslidman.conf file
##### Output Variables

    openssl_conf_check: Stores the status of the opensslidman.conf file

#### 6. Generate openssl.conf file for idman
This tasks creates the openssl.conf file for the idman if it does not exist
##### Input Variables

    domain_name: Domain name of the idman, usually formed by IDMAN_NAME.EXTERNAL_URL_SUFFIX

**when**: It runs when **openssl_conf_check.stat.exists** variable is False

#### 7. Get the subordinateCA certs if they exist in the vault
##### Input Variables

    VAULT_ADDR: Address of the vault
    VAULT_TOKEN: Token of the vault
##### Output Variables

    subordinateca: The variable stores the status of subordinateca cert in the vault

#### 8. Check if rootca.jks is present
This tasks checks if the rootca.jks is present in the ansible controller
##### Input Variables

    path: Path to the rootca.jks file
##### Output Variables

    check_rootcajks: This variable stores rootca.jks file status

**when**: It runs when **ambassadordir_check** variable exists

#### 9. Store the keystore in a file
This tasks stores the keystore in a file
##### Input Variables

    content: This variable contains the keystore in base64 encoded format
    dest: This variable has the path where the keystore will be stored

**when**: It runs when **check_rootcajks.stat.exists** does not exist

#### 10. Create ambassador certfiicates
This tasks create ambassador certificates with SubordinateCA as the rootCA

**when**: It runs when **ambassador_tls_certs.failed** variable is false

#### 11. Store the ambassador certs to the vault
This tasks stores the created/fetched ambassador certificates to the vault
##### Input Variables

    VAULT_ADDR: Address of the vault
    VAULT_TOKEN: Root/Custom Token which has the access to store on the mentioned path

**when**: It runs when **ambassador_tls_certs.failed** variable is True

#### 12. Check Ambassador creds exists
This tasks checks if the ambassador secret is already created
##### Input Variables

    name: Name of the ambassador credential
    kubeconfig: Kubeconfig file path
    context: Kuberentes cluster context
##### Output Variables

    get_ambassador_secret: Status of the ambassador secret

#### 3. Create the ambassador credentials
This tasks creates the ambassador credential secret if they dont exist

**when**: It runs when **get_ambassador_secret** variable doesnt have the secret details (secret is not already created)
