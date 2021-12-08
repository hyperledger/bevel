[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## create/helm_component/domain_genesis
This role create the config map value file for storing domain genesis for Indy cluster.

## Tasks:
### 1. Ensures {{ release_dir }}/{{ component_type }}/{{ component_name }} dir exists
This task ensure, that release folder for value file exists.
It the folder doesn't exist, then creates them.

#### Variables:
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
 - gitops: A object, which contains data of organization's gitops from network.yaml file.
 - component_name: Name of component.

### 2. Generate domain genesis for organization
This task generate domain genesis with data from crypto, which is in Vault.
This task need bevel-ac token for getting public data from Vault.
The result is domain genesis transactions, which define initial trusted trustees and stewards.
(Each ledger may have pre-defined transactions defining the initial pool and network.)

#### Genesis transaction structure
```json
{
  "reqSignature":{},
  "txn":{
    "data":{
      "alias": <...>,
      "dest": <...>,
      "role": "0",
      "verkey": <...>
    },
    "metadata":{
      "from": <...>
    },
    "type": "1"
  },
  "txnMetadata":{
    "seqNo": <...>
  },
  "ver": "1"
}
```
- reqSignature (dict): Submitter's signature over request with transaction.
- txn (dict): Transaction-specific payload (data)
    - data (dict): Transaction-specific data fields
        - alias (string): NYM's alias
        - desc (base58-encoded string): Target DID as base58-encoded string for 16 or 32 byte DID value. It may differ from the from metadata field, where from is the DID of the submitter. If they are equal (in permissionless case), then transaction must be signed by the newly created verkey. <br>Example: from is a DID of a Endorser creating a new DID, and dest is a newly created DID.
        - role (enum number as integer): "0" == TRUSTEE
        - verkey (base58-encoded string): Target verification key as base58-encoded string.
    - metadata (dict): Metadata as came from the request
        - from (base58-encoded string): Identifier (DID) of the transaction author as base58-encoded string for 16 or 32 bit DID value.
    - type (enum number as string): "1" == NYM transaction
- txnMetadata (dict):
    - seqNo (integer): A unique sequence number of the transaction on Ledger
- ver (string): Transaction version to be able to evolve content. The content of all sub-fields may depend on this version.

    
#### Variables:
 - ac_vault_tokens - A map of bevel-ac tokens, which are stored by organization's name.
 - organization.vault.url - A url address of Vault for a organization.
 - organization.name - An organization name.

#### Output Variables:
 - domain_genesis: A variable, which contains generated domain genesis.

### 3. create value file for {{ component_name }} {{ component_type }}
This task generate config map for domain genesis of Indy cluster.
Value file of Helm release Config Map is stored.
This task uses template for generating Config Map.

#### Input Variables:
 - organization: A name of organization.
 - component_ns: A name of organization's namespace.
 - gitops: A object, which contains data of organization's gitops from network.yaml file.
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
 - component_name: A name of config map. It uses *{{ organizationItem.name }}-dtg*
 - domain_genesis_values: A variable, which contains domain genesis. It uses a variable *domain_genesis.stdout* 
 - values_file: Path for output value file. It uses *{{ release_dir }}/{{ component_name }}/{{ component_type }}.yaml*
 - chart: A chart name. Default value is *indy-domain-genesis* 

#### Template:
 - domain-genesis.tpl

## Templates:
 - domain_genesis.tpl: A template for creation Kubernetes ConfigMap to store domain genesis for a cluster.

## Vars:
 - domain_genesis: domain_genesis.tpl