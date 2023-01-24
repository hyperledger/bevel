[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## clean/vault
This role get vault root token for organization and remove Indy crypto from a Vault.

### Tasks:
#### 1. Remove Indy Crypto of {{ organization }}
The task removes all generated crypto of current organization from a Vault.
##### Input Variables:
 - vault.root_token: A root token of current organization inserted in network.yaml file.
 - vault.url: An url of Vault defined in network.yaml file.
 - organization: A name of current organization.
##### Environment Variables:
 - vault_token: A root token for Vault. 

#### 2. Remove Policies of trustees
The task removes all policies of current organization's trustees from a Vault.
##### Input Variables:
 - vault.root_token: A root token of current organization inserted in network.yaml file.
 - vault.url: An url of Vault defined in network.yaml file.
 - organization: A name of current organization.
 - serviceItem.name: A name of current trustee.
 - services.trustees: A list of trustees in current organization.
##### Environment Variables:
 - vault_token: A root token for Vault.

#### 3. Remove Policies of stewards
The task removes all policies of current organization's stewards from a Vault.
##### Input Variables:
 - vault.root_token: A root token of current organization inserted in network.yaml file.
 - vault.url: An url of Vault defined in network.yaml file.
 - organization: A name of current organization.
 - serviceItem.name: A name of current steward.
 - services.stewards: A list of stewards in current organization.
##### Environment Variables:
 - vault_token: A root token for Vault.

#### 4. Remove Policies of endorsers
The task removes all policies off current organization's endorsers from a Vault.
##### Input Variables:
 - vault.root_token: A root token of current organization inserted in network.yaml file.
 - vault.url: An url of Vault defined in network.yaml file.
 - organization: A name of current organization.
 - serviceItem.name: A name of current endorser.
 - services.endorsers: A list of endorsers in current organization.
##### Environment Variables:
 - vault_token: A root token for Vault.

#### 5. Remove Policies of {{ organization }}
The task removes admin and ac policies of current organization from a Vault.
##### Input Variables:
 - organization: A name of current organization.
 - vault.root_token: A root token of current organization inserted in network.yaml file.
 - vault.url: An url of Vault defined in network.yaml file.
##### Environment Variables:
 - vault_token: A root token for Vault.

#### 6. Remove Kubernetes Authentication Methods of {{ organization }}
The task removes admin and ac Kubernetes Authentication Methods of current organization from a Vault.
##### Variables:
 - auth_path: A name of Kubernetes Authentication Method.
##### Input Variables:
 - organization: A name of current organization.
 - vault.root_token: A root token of current organization inserted in network.yaml file.
 - vault.url: An url of Vault defined in network.yaml file.
##### Environment Variables:
 - vault_token: A root token for Vault.

#### 7. Remove Kubernetes Authentication Methods of {{ organization }} of trustees
The task removes all Kubernetes Authentication Methods of current organization's trustees from a Vault.
##### Input Variables:
 - organization: A name of current organization.
 - vault.root_token: A root token of current organization inserted in network.yaml file.
 - serviceItem.name: A name of current trustee.
 - vault.url: An url of Vault defined in network.yaml file.
 - services.trustees: A list of trustees in current organization.
##### Environment Variables:
 - vault_token: A root token for Vault.

#### 8. Remove Kubernetes Authentication Methods of {{ organization }} of stewards
The task removes all Kubernetes Authentication Methods of current organization's stewards from a Vault.
##### Input Variables:
 - organization: A name of current organization.
 - vault.root_token: A root token of current organization inserted in network.yaml file.
 - serviceItem.name: A name of current steward.
 - vault.url: An url of Vault defined in network.yaml file.
 - services.stewards: A list of stewards in current organization.
##### Environment Variables:
 - vault_token: A root token for Vault.

#### 9. Remove Kubernetes Authentication Methods of {{ organization }} of endorsers
The task removes all Kubernetes Authentication Methods of current organization's endorsers from a Vault.
##### Input Variables:
 - organization: A name of current organization.
 - vault.root_token: A root token of current organization inserted in network.yaml file.
 - serviceItem.name: A name of current endorser.
 - vault.url: An url of Vault defined in network.yaml file.
 - services.endorsers: A list of endorsers in current organization.
##### Environment Variables:
 - vault_token: A root token for Vault.