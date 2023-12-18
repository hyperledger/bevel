[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

Certificate Paths on Vault for Fabric Network
---------------------------------------------

* Optionally, `secret_path` can be set on the network.yaml to change the secret engine from the default `secretsv2/`.

### For each channel

| Path                                                                       | Key (for Vault)                  | Type        |
|-----------------------------------------------------------------------------------------------------------|-------------------------------------|-------------|
| /secretsv2/crypto/ordererOrganizations/`channel_name`                                                                      | genesisBlock         | Genesis     |

### For each orderer organization

| Path                                                                       | Key (for Vault)                  | Type        |
|-----------------------------------------------------------------------------------------------------------|-------------------------------------|-------------|
| /secretsv2/crypto/ordererOrganizations/`orgname_lowercase`-net/ca/                                           | ca.`orgname_lowercase`-net-cert.pem | Certificate |
| /secretsv2/crypto/ordererOrganizations/`orgname_lowercase`-net/ca/                                           | `orgname_lowercase`-net-CA.key      | Private key |
| /secretsv2/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/msp/ | admincerts                          | Certificate |
| /secretsv2/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/msp/ | cacerts                             | Certificate |
| /secretsv2/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/msp/ | keystore                            | Certificate |
| /secretsv2/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/msp/ | signcerts                           | Certificate |
| /secretsv2/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/msp/ | tlscacerts                          | Certificate |
| /secretsv2/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/tls/ | ca.crt                              | Certificate |
| /secretsv2/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/tls/ | server.key                          | Private key |
| /secretsv2/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/tls/ | server.crt                          | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                 | admincerts                          | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                 | keystore                            | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                 | signcerts                           | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                 | tlscacerts                          | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/tls/                                 | ca.crt                              | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/tls/                                 | client.crt                          | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/tls/                                 | client.key                          | Private Key |


### For each peer organization

| Path                                                                           | Key (for Vault)                    | Type        |
|------------------------------------------------------------------------------------------------------------------|-------------------------------------|-------------|
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/ca/                                                     | ca.`orgname_lowercase`-net-cert.pem | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/ca/                                                     | `orgname_lowercase`-net-CA.key      | Private key |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/orderer/tls                                             | ca.crt                              | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/msp/ | admincerts                          | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/msp/ | keystore                            | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/msp/ | signcerts                           | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/msp/ | tlscacerts                          | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/tls/ | ca.crt                              | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/tls/ | server.key                          | Private key |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/tls/ | server.crt                          | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                        | admincerts                          | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                        | keystore                            | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                        | signcerts                           | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                        | tlscacerts                          | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/tls/                                        | ca.crt                              | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/tls/                                        | client.crt                          | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/tls/                                        | client.key                          | Private Key |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/msp/                         | admincerts                          | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/msp/                         | cacerts                             | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/msp/                         | keystore                            | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/msp/                         | signcerts                           | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/msp/                         | tlscacerts                          | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/tls/                         | ca.crt                              | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/tls/                         | client.crt                          | Certificate |
| /secretsv2/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/tls/                         | client.key                          | Private Key |