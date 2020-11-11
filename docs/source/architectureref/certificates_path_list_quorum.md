Certificate Paths on Vault for Quorum Network
---------------------------------------------

* Optionally, `secret_path` can be set on the network.yaml to change the secret engine from the default `secret/`.

### For IBFT/ RAFT

| Path                                                                              | Key Name               | Description         |
|-----------------------------------------------------------------------------------|-------------------------------|--------------|
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | nodekey                       | Public Key (Identity for a node)   |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | keystore                      | Private Key Data for a node |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | db_user                       | Username for Quorum keystore     |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | dn_password                   | Password for Quorum keystore     |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | gethpassword                   | Password for geth    |



### For Tessera/Constellation

| Path                                                                           | Key Name               | Description         |
|--------------------------------------------------------------------------------|-------------------------------|--------------|
| secret/{{ `component_ns` }}/crypto/{{ `peer_name` }}/transaction               | tm.pub                        | Public key of Transaction manager |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/transaction                 | tm.key                        | Private key of Transaction manager |


### For Root Certificates

| Path                                                                         | Key Name               | Description         |
|------------------------------------------------------------------------------|-------------------------------|--------------|
| secret/{{ `component_ns` }}/crypto/{{ `node_name` }}/certs                       | rootca                        | JKS(Java KeyStore) Initail Root CA Certificates  |
| secret/{{ `component_ns` }}/crypto/{{ `node_name` }}/certs                       | ambassadorcrt                 | Certificate chain for Ambassador proxy  |
| secret/{{ `component_ns` }}/crypto/{{ `node_name` }}/certs                       | ambassadorkey                 | Ambassador key  |

------------------------------------------------------------------------------------------------


Details of Variables

| Variable | Description |
|-------------------------------|--------------|
|`component_ns` | Name of Component's Namespace |
|`peer_name` | Name of Peer  | 
|`component_name` | Name of Component  | 
|`node_name` | Name of Node   |
|`component_auth` | Auth Name |