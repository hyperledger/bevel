[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## Role: `create/certificates/notary`
This role generates the Ambassador proxy certificates, and the Kubernetes secret required for inter-cluster communication, specific to the nodes of Corda-Enterprise.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

---

#### 1. Check if the Ambassador tls directory exists
This task checks if the Ambassador tls directory exists or not.
##### Input Variables
- `path` - The Ambassador directory
- `node_name` - The name of the notary, used to form the previous `path` variable
##### Output Variables
- `ambassadordir_check` - Variable which stores the status of the directory presence (`true` if the directory exists)

---

#### 2. Create the Ambassador directory if it doesn't exist
This tasks creates the Ambassador directory if it doesn't exist. Calls common role in `shared/configuration/roles/check/directory`.
##### Input Variables
- `path` - The path to the directory is specified here.

**when**: It runs when **ambassadordir_check** variable is false.

---

#### 3. Check if the Ambassador TLS is already created
This tasks checks if the Ambassador TLS is already created and stored in the Vault.
##### Input Variables
- `VAULT_ADDR` - The Vault address
- `VAULT_TOKEN` - Vault root/custom token which has the access to the path
##### Output Variables:
- `ambassador_tls_certs` -  Stores the status of the ambassador tls certificates in the vault (true if the TLS is already created)

`ignore_errors` is set to `yes` because certificates are not created for a fresh network deployment and this command will fail.

--- 

#### 4. Get the Ambassador certs if they exist
This tasks fetches the Ambassador certificates, if they are present in the vault. Calls common role in `setup/get_crypto`.
##### Input Variables
- `vault_output` - result of the previous command
- `type` - `ambassador`, used as a check mechanism in the common `setup/get_crypto` role
- `cert_path` - Path where the ambassador certificates are fetched to

**when**: It runs when **ambassador_tls_certs.failed** variable is False

---

#### 5. Check if the `openssl.conf` file exists or not
This tasks checks if the `openssl.conf` file exists on the given path.
##### Input Variables
- `path` -  The path to the `openssl.conf` file
##### Output Variables
- `openssl_conf_check` -  Stores the status of the command

---

#### 6. Generate `openssl.conf` file
This tasks creates the `openssl.conf` file if it does not exist.
##### Input Variables
- `domain_name` - Domain name of the service, usually formed by `SERVICE_NAME.EXTERNAL_URL_SUFFIX`

**when**: It runs when **openssl_conf_check.stat.exists** variable is `false`

---

#### 7. Create Ambassador certfiicates
This tasks creates Ambassador certificates using the `openssl.conf` file created in the previous task.

**when**: It runs when **ambassador_tls_certs.failed** variable is true.

---

#### 8. Store the Ambassador certs to the vault
This tasks stores the created/fetched Ambassador certificates to the Vault.
##### Input Variables
- `VAULT_ADDR` - Address of the vault
- `VAULT_TOKEN` - Vault root/custom token which has the access to store on the mentioned path

**when**: It runs when **ambassador_tls_certs.failed** variable is True

--- 

#### 9. Check if Ambassador creds exists
This tasks checks if the Ambassador secret is already created.
##### Input Variables
- `name` - Name of the Ambassador credential to check
- `kubeconfig` - location of the `.kubeconfig` file 
- `context` - Kubernetes cluster context
##### Output Variables
- `get_ambassador_secret` - Status of the Ambassador secret

---

#### 10. Create the Ambassador credentials
This tasks creates the Ambassador credential secret if they don't exist.

**when**: It runs when **get_ambassador_secret** variable doesnt have the secret details (secret is not already created)
