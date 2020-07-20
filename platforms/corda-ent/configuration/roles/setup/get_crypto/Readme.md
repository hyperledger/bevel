## ROLE: setup/get_crypto
This role fetches the crypto material from the vault.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Save the cert file
This task saves the idman.cert file from the vault output

**when**: The type is ambassador

#### 1. Save the key file
This task saves the idman.key file from the vault output

**when**: The type is ambassador
