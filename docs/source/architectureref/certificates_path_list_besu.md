[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

Certificate Paths on Vault for Hyperledger Besu Network
-------------------------------------------------------

* Optionally, `secret_path` can be set on the network.yaml to change the secret engine from the default `secretsv2/`.

### For IBFT2 WIP

| Path                                                                              | Key Name               | Description         |
|-----------------------------------------------------------------------------------|-------------------------------|--------------|
| secretsv2/{{`component_ns`}}/crypto/{{ `peer_name` }}/data                         | key                       | Private Key Data for a node   |
| secretsv2/{{`component_ns`}}/crypto/{{ `peer_name` }}/data                         | key_pub                      | Public Key (Identity for a node)  |
| secretsv2/{{`component_ns`}}/crypto/{{ `peer_name` }}/data                         | nodeAddress                       | Besu Node Address     |

### For Orion

| Path                                                                           | Key Name               | Description         |
|--------------------------------------------------------------------------------|-------------------------------|--------------|
| secretsv2/{{ `component_ns` }}/crypto/{{ `peer_name` }}/tm               | publicKey                        | Public key of Transaction manager |
| secretsv2/{{`component_ns`}}/crypto/{{ `peer_name` }}/tm                 | privateKey                        | Private key of Transaction manager |


### For Root Certificates

| Path                                                                         | Key Name               | Description         |
|------------------------------------------------------------------------------|-------------------------------|--------------|
| secretsv2/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | rootca_key                        | Initial Root CA Key  |
| secretsv2/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | rootca_pem                        | Initial Root CA Certificates  |
| secretsv2/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | ambassadorcrt                 | Certificate chain for Ambassador proxy and Orion TLS |
| secretsv2/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | ambassadorkey                 | Ambassador key  |
for Ambassador proxy and Orion TLS |
| secretsv2/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | knownServer                 | Common name and SHA256 digest of authorized privacy enclave  |
| secretsv2/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | keystore                 | Keystore (PKCS #12 format) Besu TLS Certificate and key   |
| secretsv2/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | password                 | Password to decrypt the Keystore  |


------------------------------------------------------------------------------------------------

### For Admin Keys

| Path                                                                         | Key Name               | Description         |
|-----------------------------------------------------------------------------------|-------------------------------|--------------|
| secretsv2/{{`component_ns`}}/crypto/admin                         | key                       | Private Key for admin account   |
| secretsv2/{{`component_ns`}}/crypto/admin                         | key_pub                      | Public Key (Identity for a admin account)  |

Details of Variables

| Variable | Description |
|-------------------------------|--------------|
|`component_ns` | Name of Component's Namespace |
|`peer_name` | Name of Peer  | 
|`component_name` | Name of Component  | 
|`node_name` | Name of Node   |
|`component_auth` | Auth Name |
