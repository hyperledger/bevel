Certificate Paths on Vault for Hyperledger Besu Network
-------------------------------------------------------

### For IBFT2 WIP

| Path                                                                              | Key Name               | Description         |
|-----------------------------------------------------------------------------------|-------------------------------|--------------|
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/data                         | key                       | Private Key Data for a node   |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/data                         | key.pub                      | Public Key (Identity for a node)  |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/data                         | nodeAddress                       | Besu Node Address     |

### For Orion

| Path                                                                           | Key Name               | Description         |
|--------------------------------------------------------------------------------|-------------------------------|--------------|
| secret/{{ `component_ns` }}/crypto/{{ `peer_name` }}/orion               | key.pub                        | Public key of Transaction manager |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/orion                 | key                        | Private key of Transaction manager |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/orion | password  | Password for the Key |


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