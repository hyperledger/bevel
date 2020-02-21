Certificate Paths on Vault for Quorum Network
---------------------------------------------

### For IBFT

| Path                                                                              | Crypto-material               | Type         |
|-----------------------------------------------------------------------------------|-------------------------------|--------------|
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | nodekey                       | Public Key   |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | keystore                      | Private Key  |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | db_user                       | Username     |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | dn_password                   | Password     |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                         | gethpassword                   | Password     |


### For RAFT

| Path                                                                             | Crypto-material               | Type         |
|----------------------------------------------------------------------------------|-------------------------------|--------------|
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                        | nodekey                       | Public Key   |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                        | keystore                      | Private Key  |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                        | db_user                       | Username     |
| secret/{{`component_ns`}}/crypto/{{ `peer_name` }}/quorum                        | dn_password                   | Password     |



### For Tessera

| Path                                                                           | Crypto-material               | Type         |
|--------------------------------------------------------------------------------|-------------------------------|--------------|
| sys/policy/vault-crypto-{{ `component_name` }}-ro                              | tm.pub                        | Public Key   |
| secret/{{component_ns}}/crypto/{{ `peer_name` }}/transaction                   | tm.key                        | Private Key  |


## For Root Certificates

| Path                                                                         | Crypto-material               | Type         |
|------------------------------------------------------------------------------|-------------------------------|--------------|
| secret/{{ `component_ns` }}/crypto/{{ `node_name` }}/certs                       | rootca                        | Certificate  |
| secret/{{ `component_ns` }}/crypto/{{ `node_name` }}/certs                       | ambassadorcrt                 | Certificate  |

### For Policies

| Path                                                                         | Crypto-material                            | Type         |
|------------------------------------------------------------------------------|--------------------------------------------|--------------|
| secret/{{`component_ns`}}/crypto/{{ `node_name` }}/transaction                   | vault-crypto-{{ `component_name` }}-ro.hcl   | HashiCorp configuration language Policy File   |

### For Vault-Auth

| Path                                                                         |
|------------------------------------------------------------------------------|
|  auth/{{ `component_auth` }}/role/vault-role                                   |


------------------------------------------------------------------------------------------------


Details of Variables

`component_ns` : Name of Component's Namespace   
`peer_name` : Name of Peer   
`component_name` : Name of Component   
`node_name` : Name of Node   
`component_auth` : Auth Name