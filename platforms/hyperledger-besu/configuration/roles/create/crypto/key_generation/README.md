[//]: # (##############################################################################################)
[//]: # (Copyright Walmart Inc. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/key_generation
This role generates public and private for each organization and store it to vault.
##### Input Variables
     *component_ns: Organization namespace
     *vault: Vault uri and token read from network.yaml
     *build_path: Path to the build directory
     *user: Name using which keys will be stored in vault
