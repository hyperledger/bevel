[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: setup
This roles check if Namespace, Clusterrolebinding or StorageClass is created or not.

### Tasks
#### 2. Check if Kubernetes-auth already created for Organization
Task to check if kubernetes-auth is created and return the results back
##### Input Variables

    VAULT_ADDR: URL of the vault
    VAULT_TOKEN: Root token for the vault

**when**:  It runs when *check* == "vault_auth".

##### Output Variables

    auth_lists: This variable stores the data returned .

#### 3. Check if Kubernetes-auth already created for Organization
Task to check if Check if policy exists for the vault
##### Input Variables

    VAULT_ADDR: URL of the vault
    VAULT_TOKEN: Root token for the vault

**when**:  It runs when check == "vault_policies".

##### Output Variables

    vault_policy_result: This variable stores the data returned.

#### 3. Check if docker credentials exists
Task to check if docker credentials allready exists
##### Input Variables

    *name: The type docker credentials.
    *namespace: The organisation's namespace
    kubernetes.config_file: The kubernetes config file
    kubernetes.context: The kubernetes current context

**when**:  It runs when check == "docker_credentials".

##### Output Variables

    get_regcred: This variable stores the data returned.