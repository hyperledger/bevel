[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## create/helm_component/pool_genesis
This role create the config map value file for storing pool genesis for Indy cluster.

## Tasks:
### 1. Ensures {{ release_dir }}/{{ component_type }}/{{ component_name }} dir exists
This task ensure, that release folder for value file exists.
It the folder doesn't exist, then creates them.

#### Variables:
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
 - gitops: A object, which contains data of organization's gitops from network.yaml file.
 - component_name: Name of component.

### 2. Generate pool genesis for organization
This task generate pool genesis with data from crypto, which is in Vault.
This task need bevel-ac token for getting public data from Vault.
The result is pool genesis transactions, which define initial trusted nodes in the pool.
(Each ledger may have pre-defined transactions defining the initial pool and network.)

#### Genesis transaction structure
```json
{
  "reqSignature":{},
  "txn":{
    "data":{
      "data":{
        "alias":$alias,
        "blskey":$blskey,
        "blskey_pop":$blskey_pop,
        "client_ip":$client_ip,
        "client_port":$client_port|tonumber,
        "node_ip":$node_ip,
        "node_port":$node_port|tonumber,
        "services":[$type]
      },
      "dest":$dest
    },
    "metadata":{
      "from":$from
    },
    "type":"0"
  },
  "txnMetadata":{
    "seqNo":$seqNo|tonumber,
    "txnId":$txnId
  },
  "ver":"1"
}
```
- reqSignature (dict): Submitter's signature over request with transaction.
- txn (dict): Transaction-specific payload (data)
    - data (dict): Transaction-specific data fields
        - alias (string): Node's alias
        - blskey (base58-encoded string): BLS multi-signature key as base58-encoded string (it's needed for BLS signatures and state proofs support)
        - blskey_pop: specifies Proof of possession for BLS key
        - client_ip (string): Node's client listener IP address, that is the IP clients use to connect to the node when sending read and write requests.
        - client_port (string): Node's client listener port, that is the port clients use to connect to the node when sending read and write requests.
        - node_ip (string): The IP address other Nodes use to communicate with this Node; no clients are allowed here.
        - node_port (string): The port other Nodes use to communicate with this Node; no clients are allowed here.
        - services (array of strings): the service of the Node. VALIDATOR is the only supported one now.
    - metadata (dict): Metadata as came from the request
        - from (base58-encoded string): Identifier (DID) of the transaction author as base58-encoded string for 16 or 32 bit DID value.
    - type (enum number as string): "0" == NODE
- txnMetadata (dict):
    - seqNo (integer): A unique sequence number of the transaction on Ledger
- ver (string): Transaction version to be able to evolve content. The content of all sub-fields may depend on this version.

#### Variables:
 - ac_vault_tokens - A map of bevel-ac tokens, which are stored by organization's name.
 - organization.vault.url - A url address of Vault for a organization.
 - organization.name - An organization name.

#### Output Variables:
 - pool_genesis: A variable, which contains generated pool genesis.

### 3. create value file for {{ component_name }} {{ component_type }}
This task generate config map for pool genesis of Indy cluster.
Value file of Helm release Config Map is stored.
This task uses template for generating Config Map.

#### Input Variables:
 - organization: A name of organization.
 - component_ns: A name of organization's namespace.
 - gitops: A object, which contains data of organization's gitops from network.yaml file.
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
 - component_name: A name of config map. It uses *{{ organizationItem.name }}-ptg*
 - pool_genesis_values: A variable, which contains pool genesis. It uses a variable *pool_genesis.stdout* 
 - values_file: Path for output value file. It uses *{{ release_dir }}/{{ component_name }}/{{ component_type }}.yaml*
 - chart: A chart name. Default value is *indy-pool-genesis* 

#### Template:
 - pool-genesis.tpl

## Templates:
 - pool_genesis.tpl: A template for creation Kubernetes ConfigMap to store pool genesis for a cluster.

## Vars:
 - pool_genesis: pool_genesis.tpl