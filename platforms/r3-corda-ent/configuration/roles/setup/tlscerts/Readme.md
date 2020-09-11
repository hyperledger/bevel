## ROLE: setup/tlscerts
This role fetches the tlscerts specified at a given path in network.yaml and then pushes them to the vault of each node organization.

### Takks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)
#### 1. "Check if the idman tls certificate is already present in the vault or not"
This task checks if the idman tls certficate is already present in the vault or not.
##### Environment variables

    VAULT_ADDR: address of the vault
    VAUTL_TOKEN: token of the vault

##### Output variable

    vault_idman_tlscert: stores the status of idman tlscert in vault

#### 2. "Copy the idman tls certificate to each org vault"
This task copys the idman tls certificate to the vault of each organization from the path specified in network.yaml
##### Environment variables

    VAULT_ADDR: address of the vault
    VAUTL_TOKEN: token of the vault

#### 3. "Check if the networkmap tls certificate is already present in the vault or not"
This task checks if the networkmap tls certficate is already present in the vault or not.
##### Environment variables

    VAULT_ADDR: address of the vault
    VAUTL_TOKEN: token of the vault

##### Output variable

    vault_networkmap_tlscert: stores the status of networkmap tlscert in vault

#### 4. "Copy the networkmap tls certificate to each org vault"
This task copys the networkmap tls certificate to the vault of each organization from the path specified in network.yaml
##### Environment variables

    VAULT_ADDR: address of the vault
    VAUTL_TOKEN: token of the vault
