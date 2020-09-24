## ROLE: create/certificates/cenm
This role generates the ambassador proxy certificates and Kubernetes secret required for inter cluster communication.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check if the ambassador tls directory exists
This tasks checks if the ambassador tls directory exists or not
##### Input Variables

    path: The path to the directory is specified here.

##### Output Variables

    ambassadordir_check: Variable which stores the status of the directory presence

#### 2. Create the ambassador directory if it doesn't exist
This tasks create the ambassador directory if it doesn't exist. Calls common role in shared/configuration/roles/check/setup
##### Input Variables

    path: The path to the directory is specified here.
    check: "ensure_dir"

**when**: It runs when **ambassadordir_check** variable is false.

#### 3. Check if the ambassador tls is already created
This tasks checks if the ambassador tls is already created and stored in the vault
##### Input Variables

    VAULT_ADDR: The vault address
    VAULT_TOKEN: Vault root/custom token which has the access to the path
##### Output Variables:

    ambassador_tls_certs: Stores the status of the ambassador tls certificates in the vault
ignore_errors is yes because certificates are not created for a fresh network deployment and this command will fail.

#### 4. Get the ambassador certs if they exist
This tasks fetches the ambassador certificates, if they are present in the vault. Calls common role in setup/get_crypto
##### Input Variables

    vault_output: result of the previous command
    type: "ambassador"
    cert_path: Path where the ambassador certificates are fetched to

**when**: It runs when **ambassador_tls_certs.failed** variable is False

#### 5. Check if the openssl conf file exists or not
This tasks check if the openssl file exists on the given path
##### Input Variables

    path: The path to the openssl.conf file
##### Output Variables

    openssl_conf_check: Stores the status of the command

#### 6. Generate openssl.conf file
This tasks creates the openssl.conf file if it does not exist
##### Input Variables

    domain_name: Domain name of the service, usually formed by SERVICE_NAME.EXTERNAL_URL_SUFFIX

**when**: It runs when **openssl_conf_check.stat.exists** variable is False

#### 7. Create ambassador certfiicates
This tasks create ambassador certificates using the openssl file created above.

**when**: It runs when **ambassador_tls_certs.failed** variable is true.

#### 8. Store the ambassador certs to the vault
This tasks stores the created/fetched ambassador certificates to the vault
##### Input Variables

    VAULT_ADDR: Address of the vault
    VAULT_TOKEN: Root/Custom Token which has the access to store on the mentioned path

**when**: It runs when **ambassador_tls_certs.failed** variable is True

#### 9. Check Ambassador creds exists
This tasks checks if the ambassador secret is already created
##### Input Variables

    name: Name of the ambassador credential
    kubeconfig: Kubeconfig file path
    context: Kuberentes cluster context
##### Output Variables

    get_ambassador_secret: Status of the ambassador secret

#### 10. Create the ambassador credentials
This tasks creates the ambassador credential secret if they dont exist

**when**: It runs when **get_ambassador_secret** variable doesnt have the secret details (secret is not already created)

#### 11. Copy generated crt to build location
This tasks copies the public ambassador cert to the build location provided in network.yaml

**when**: the dest_path variable is defined. (This is the location where the cert will be copied to).
