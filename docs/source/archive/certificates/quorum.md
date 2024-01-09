[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

Certificate Paths on Vault for Quorum Network
---------------------------------------------

* Optionally, `secret_path` can be set on the network.yaml to change the secret engine from the default `secretsv2/`.

### For IBFT/ RAFT

| Path                                                                              | Key Name               | Description         |
|-----------------------------------------------------------------------------------|-------------------------------|--------------|
| secretsv2/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | nodekey                       | Public Key (Identity for a node)   |
| secretsv2/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | keystore                      | Private Key Data for a node |
| secretsv2/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | db_user                       | Username for Quorum keystore     |
| secretsv2/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | db_password                   | Password for Quorum keystore     |
| secretsv2/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | geth_password                   | Password for geth    |



### For Tessera

| Path                                                                           | Key Name               | Description         |
|--------------------------------------------------------------------------------|-------------------------------|--------------|
| secretsv2/{{ `component_ns` }}/crypto/{{ `peer_name` }}/tm               | publicKey                        | Public key of Transaction manager |
| secretsv2/{{`component_ns`}}/crypto/{{ `peer_name` }}/tm                 | privateKey                        | Private key of Transaction manager |


### For Root Certificates

| Path                                                                         | Key Name                 | Description         |
|------------------------------------------------------------------------------|-------------------------------|--------------|
| secretsv2/{{ `component_ns` }}/crypto/{{ `node_name` }}/certs                       | rootCA                        | JKS(Java KeyStore) Initail Root CA Certificates  |
| secretsv2/{{ `component_ns` }}/crypto/{{ `node_name` }}/certs                       | ambassadorcrt                 | Certificate chain for Ambassador proxy  |
| secretsv2/{{ `component_ns` }}/crypto/{{ `node_name` }}/certs                       | ambassadorkey                 | Ambassador key  |

------------------------------------------------------------------------------------------------


Details of Variables

| Variable | Description |
|-------------------------------|--------------|
|`component_ns` | Name of Component's Namespace |
|`peer_name` | Name of Peer  |
|`node_name` | Name of Node  |
