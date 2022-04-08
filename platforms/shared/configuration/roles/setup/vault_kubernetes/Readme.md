[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## Role setup/vault_kubernetes

Shared/Common role to create the Kubernetes Job for vault-kubernetes associations using helmchart vault-k8s-mgmt

### Inputs

| Key        | Description                                 |
|------------|---------------------------------------------|
| policy_type       | Key for the policy to be created. Like quorum, besu which defines the policy template that will be used.|
| name  | The org name |
| component_ns | The namespace where the job will be created |
| component_name | Name of the job |
| component_auth | The auth path on Vault |
| component_type | The org type, generally 'organization' |
| kubernetes | The org's k8s key |
| gitops | The org's gitops key |
| vault | The org's vault key |
| reset_path | The Git reset path which is generally 'platforms/*dlt-platform*/configuration'
