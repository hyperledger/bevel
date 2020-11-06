Certificate Paths on Vault for Hyperledger Besu Network
-------------------------------------------------------

* Optionally, `secret_path` can be set on the network.yaml to change the secret engine from the default `secret/`.

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
| secret/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | rootca_key                        | Initial Root CA Key  |
| secret/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | rootca_pem                        | Initial Root CA Certificates  |
| secret/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | ambassadorcrt                 | Certificate chain for Ambassador proxy and Orion TLS |
| secret/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | ambassadorkey                 | Ambassador key  |
for Ambassador proxy and Orion TLS |
| secret/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | knownServer                 | Common name and SHA256 digest of authorized privacy enclave  |
| secret/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | keystore                 | Keystore (PKCS #12 format) Besu TLS Certificate and key   |
| secret/{{ `component_ns` }}/crypto/{{ `node_name` }}/tls                       | password                 | Password to decrypt the Keystore  |


------------------------------------------------------------------------------------------------


Details of Variables

| Variable | Description |
|-------------------------------|--------------|
|`component_ns` | Name of Component's Namespace |
|`peer_name` | Name of Peer  | 
|`component_name` | Name of Component  | 
|`node_name` | Name of Node   |
|`component_auth` | Auth Name |