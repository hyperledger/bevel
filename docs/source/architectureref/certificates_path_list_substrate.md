[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

Certificate and Secrets Paths on Vault for Substrate Network
------------------------------------------------------------

* Optionally, `secret_path` can be set on the network.yaml to change the secret engine from the default `secretsv2/`.

### Genesis and sudo 

| Path                                                                              | Key Name               | Description         |
|-----------------------------------------------------------------------------------|-------------------------------|--------------|
| secretsv2/{{`component_ns`}}/genesis                         | genesis                       | Base64 encoded genesis file for the Substrate network   |
| secretsv2/{{`component_ns`}}/genesis                         | sudo_details                | JSON format sudo details, only applicable to the sudo account/member   |


### Validator and Member/Owner Nodes

| Path                                                                              | Key Name               | Description         |
|-----------------------------------------------------------------------------------|-------------------------------|--------------|
| secretsv2/{{`component_ns`}}/{{ `peer.name` }}/substrate                         | account_addr                       | ss58 based Account address for member/owner node(s)   |
| secretsv2/{{`component_ns`}}/{{ `peer.name` }}/substrate                         | account_file_b64                      | Account key encoded in base64 |
| secretsv2/{{`component_ns`}}/{{ `peer.name` }}/substrate                         | account_seed                       | Private key for generated account key     |
| secretsv2/{{`component_ns`}}/{{ `peer.name` }}/substrate                         | aura_addr                   | ss58 based address for  validator nodes using [Aura consensus](https://docs.substrate.io/v3/advanced/consensus/#:~:text=custom%20consensus%20algorithms.-,Aura,-Aura)      |
| secretsv2/{{`component_ns`}}/{{ `peer.name` }}/substrate                         | aura_file_b64                   | Aura key encoded in base64    |
| secretsv2/{{`component_ns`}}/{{ `peer.name` }}/substrate                         | aura_seed                   | Private key for generated aura key    |
| secretsv2/{{`component_ns`}}/{{ `peer.name` }}/substrate                         | grandpa_addr                  | ss58 based address for validator nodes using [GRANDPA consensus](https://docs.substrate.io/v3/advanced/consensus/#:~:text=target%20block%20time.-,GRANDPA,-GRANDPA)    |
| secretsv2/{{`component_ns`}}/{{ `peer.name` }}/substrate                         | grandpa_file_b64               |  Grandpa key encoded in base64  |
| secretsv2/{{`component_ns`}}/{{ `peer.name` }}/substrate                         | grandpa_seed                  |   Private key for generated grandpa key  |
| secretsv2/{{`component_ns`}}/{{ `peer.name` }}/substrate                         | node_id                  |   Identifier for the node  |
| secretsv2/{{`component_ns`}}/{{ `peer.name` }}/substrate                         | node_key                  |   Output file from the generate-node-key command  |


### IPFS Member Nodes

| Path                                                                         | Key Name                 | Description         |
|------------------------------------------------------------------------------|-------------------------------|--------------|
| secretsv2/{{ `component_ns` }}/{{ `peer.name` }}/ipfs                      | peer_id                 | ID of the ipfs node |
| secretsv2/{{ `component_ns` }}/{{ `peer.name` }}/ipfs            | private_key                 | Private key for the ipfs node  |


### TLS Root Certificates

| Path                                                                         | Key Name                 | Description         |
|------------------------------------------------------------------------------|-------------------------------|--------------|
| secretsv2/{{ `component_ns` }}/tlscerts                       | tlscacerts                 | TLS CA certification |
| secretsv2/{{ `component_ns` }}/tlscerts                       | tlskey                 | TLS key  |



### Details of Variables

| Variable | Description |
|-------------------------------|--------------|
|`component_ns` | Name of Component's Namespace |
|`peer.name` | Name of Peer  |
