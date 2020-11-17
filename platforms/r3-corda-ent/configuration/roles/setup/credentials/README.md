## ROLE: `setup/credentials`
This role writes passwords for keystores, truststores and ssl from network.yaml into the vault. There are some different tasks that are called for the type of organisation.
- `main.yaml` as first task, which will call `cenm_tasks.yaml`
- `cenm_tasks.yaml` will execute some tasks for CENM specifically
- `node_tasks.yaml` will call `node_tasks_nested.yaml` for every peer
- `node_tasks_nested.yaml` will execute tasks per specific peer

### Tasks (`main.yaml`)
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. "Call cenm_tasks.yaml for org as type cenm"
This task writes credentials for CENM services to vault from `network.yaml`.

**when** - This role is called when the type of organization is `cenm`.

---

#### 2. "Call cenm_tasks.yaml for org as type node"
This task writes credentials for node to Vault from `network.yaml`.

**when** - This role is called when the type of organization is `node`.

---------
### Tasks (`cenm_tasks.yaml`)

#### 1. Check if the keystore credentials are already present in the Vault
This task checks if the keystore credentials have already been written to the Vault.
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - The Vault/root token with full access to the Vault
- *`org.name` - The name of the organization 
##### Output variables
- `vault_credentials_keystore` - Stores the result of the check to Vault (if the keystore credentials are present)

---

#### 2. Write the keystore credentials to the vault if they don't exist
This task will write the keystore credentials to the Vault if they were not present as per previous check.
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - The Vault/root token with full access to the Vault
- *`org.name` - The name of the organization 
- *`org.credentials.keystore` - Contains the  keystore credentials for the services (idman, networkmap, etc.)

**when** - This role is only called if the result of `vault_credentials_keystore` is that the credentials did not exist yet

---

#### 3. Check if the truststore credentials are already present in the Vault
This task checks if the truststore credentials have already been written to the Vault.
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - The Vault/root token with full access to the Vault
- *`org.name` - The name of the organization 
##### Output variables
- `vault_credentials_truststore` - Stores the result of the check to Vault (if the truststore credentials are present)

---

#### 4. Write the truststore credentials to the vault if they don't exist
This task will write the truststore credentials to the Vault if they were not present as per previous check.
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - The Vault/root token with full access to the Vault
- *`org.name` - The name of the organization 
- `org.credentials.truststore` - Contains the truststore credentials for the CENM (RootCA, SSL and Truststore password)

**when** - This role is only called if the result of `vault_credentials_truststore` is that the credentials did not exist yet

---

#### 5. Check if the SSL credentials are already present in the Vault
This task checks if the SSL credentials have already been written to the Vault.
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - The Vault/root token with full access to the Vault
- *`org.name` - The name of the organization 
##### Output variables
- `vault_credentials_ssl` - Stores the result of the check to Vault (if the SSL credentials are present)

---

#### 6. Write the SSL credentials to the vault if they don't exist
This task will write the SSL credentials to the Vault if they were not present as per previous check.
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - The Vault/root token with full access to the Vault
- *`org.name` - The name of the organization 
- `org.credentials.ssl` - Contains the truststore credentials for the CENM (idman, networkmap etc.)

**when** - This role is only called if the result of `vault_credentials_ssl` is that the credentials did not exist yet

#### 7. Write cordapps credentials to Vault
This task will write credentials to the Vault for Cordapps repository.
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - The Vault/root token with full access to the Vault
- *`org.name` - The name of the organization 
- `org.cordapps` - Contains the username & password for the Cordapps repository

---
## Tasks (`node_tasks.yaml`)

#### 1. Call `node_tasks_nested.yaml`
This task will call the `node_tasks_nested.yaml` role for each peer.

---
## Tasks (`node_tasks_nested.yaml`)

#### 1. Check if the Node credentials are already present in the Vault
This task will check if the Node credentials are already present in the Vault
#### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - The Vault/root token with full access to the Vault
- *`org.name` - The name of the organisation
- *`peer.name` - The name of the peer
#### Output variables
- `vault_credentials_node` - Stores the result of the check to Vault (if the Node credentials are present)

---

#### 2. Write networkroottruststore, node truststore, node keystore password to the Vault
This task will write the passwords for the several truststores/keystores to the Vault
### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - The Vault/root token with full access to the Vault
- *`org.name` - The name of the organisation
- *`peer.name` - The name of the peer

**when** - This role is only called if the result of `vault_credentials_node` is that the credentials did not exist yet

#### 3. Write cordapps credentials to Vault
This task will write credentials to the Vault for Cordapps repository.
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - The Vault/root token with full access to the Vault
- *`org.name` - The name of the organization 
- `org.cordapps` - Contains the username & password for the Cordapps repository

**when** - This role is only called if the result of `vault_credentials_node` is that the credentials did not exist yet