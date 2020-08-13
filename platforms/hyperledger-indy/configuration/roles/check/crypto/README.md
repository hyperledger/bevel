## check/crypto
This role is checking if all crypto jobs are completed and all crypto data are in Vault.

## Tasks:
### 1. Check if Indy Key management pod for trustee is completed
This task is waiting until job for all trustees in organization are completed.
It uses *k8s_info* Ansible role.

#### Variables:
 - component_ns: A name of namespace' organization.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - component_name: A name of Crypto job.
 
#### Input Variables:
 - identity_name: A name of trustee in organization.
 
#### Output Variables:
 - result: It holds number of running pods.

### 2. Check if Indy Key management pod for stewards is completed
This task is waiting until job for all stewards in organization are completed.
It uses *k8s_info* Ansible role.

#### Variables:
 - component_ns: A name of namespace' organization.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - component_name: A name of Crypto job.
 
#### Input Variables:
 - identity_name: A name of steward in organization.
 
#### Output Variables:
 - result: It holds number of running pods.

### 3. Check if Indy Key management pod for endorser is completed
This task is waiting until job for all endorsers in organization are completed.
It uses *k8s_info* Ansible role.

#### Variables:
 - component_ns: A name of namespace' organization.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - component_name: A name of Crypto job.
 
#### Input Variables:
 - identity_name: A name of endorser in organization.
 
#### Output Variables:
 - result: It holds number of running pods.

### 4. Check trustee in vault
This task check correct completion of job for crypto of trustee.
It reads a public did from trustee.

#### Variables:
 - vault_ac_token: Read-only token for getting public data from Vault.
 - vault.url: Url address of Vault.
 - organization: A organization's name.

#### Environment Variables:
 - VAULT_ADDR: Vault address, which is defined in variable *{{ vault.url }}*
 - VAULT_TOKEN: Vault token, which is defined in variable *{{ vault_ac_token }}*
 
#### Output Variables:
 - result: It holds result of check. If is empty then task is failed.

### 5. Check stewards in vault
This task check correct completion of job for crypto of steward.
It reads a public did from steward.

#### Variables:
 - vault_ac_token: Read-only token for getting public data from Vault.
 - vault.url: Url address of Vault.
 - organization: A organization's name.

#### Environment Variables:
 - VAULT_ADDR: Vault address, which is defined in variable *{{ vault.url }}*
 - VAULT_TOKEN: Vault token, which is defined in variable *{{ vault_ac_token }}*
 
#### Output Variables:
 - result: It holds result of check. If is empty then task is failed.

### 6. Check endorser in vault
This task check correct completion of job for crypto of endorser.
It reads a public did from endorser.

#### Variables:
 - vault_ac_token: Read-only token for getting public data from Vault.
 - vault.url: Url address of Vault.
 - organization: A organization's name.

#### Environment Variables:
 - VAULT_ADDR: Vault address, which is defined in variable *{{ vault.url }}*
 - VAULT_TOKEN: Vault token, which is defined in variable *{{ vault_ac_token }}*
 
#### Output Variables:
 - result: It holds result of check. If is empty then task is failed.
