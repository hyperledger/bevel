## ROLE: `setup/get_crypto`
This role fetches the crypto material from the Vault and puts it into local folder structure

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

---

#### 1. Save the cert file
This task fetches the `idman.cert` from the Vault and saves it to local file system.

**when** - The type is `ambassador`

#### 2. Save the key file
This task fetches the `idman.key` from the Vault and saves it to local file system.

**when** - The type is `ambassador`
