## delete/genesis
This role deletes the genesis block from the Vault
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Delete genesis block from Vault
This task deletes all genesis blocks from the Vault path
##### Input Variables

    *vault: The Vault URL and root token from the orderer organization(s)