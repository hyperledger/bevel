## ROLE: setup/credentials
This role writes passwords for keystores, truststores and ssl from network.yaml into the vault.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)
#### 1. "Call cenm_tasks.yaml for org as type cenm"
This task writes credentials for CENM services to vault from network.yaml

**when**: This runs when the type of organization is of cenm type.

#### 2. "Call cenm_tasks.yaml for org as type node"
This task writes credentials for node to vault from network.yaml

**when**: This runs when the type of organization is of node type.
