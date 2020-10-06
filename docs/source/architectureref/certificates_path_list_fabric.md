Certificate Paths on Vault for Fabric Network
---------------------------------------------

## For each channel
| Path                                                                       | Key (for Vault)                  | Type        |
|-----------------------------------------------------------------------------------------------------------|-------------------------------------|-------------|
| /secret/crypto/ordererOrganizations/                                                                      | genesisBlock         | Genesis     |

### For each orderer organization

| Path                                                                       | Key (for Vault)                  | Type        |
|-----------------------------------------------------------------------------------------------------------|-------------------------------------|-------------|
| /secret/crypto/ordererOrganizations/`orgname_lowercase`-net/ca/                                           | ca.`orgname_lowercase`-net-cert.pem | Certificate |
| /secret/crypto/ordererOrganizations/`orgname_lowercase`-net/ca/                                           | `orgname_lowercase`-net-CA.key      | Private key |
| /secret/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/msp/ | admincerts                          | Certificate |
| /secret/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/msp/ | cacerts                             | Certificate |
| /secret/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/msp/ | keystore                            | Certificate |
| /secret/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/msp/ | signcerts                           | Certificate |
| /secret/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/msp/ | tlscacerts                          | Certificate |
| /secret/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/tls/ | ca.crt                              | Certificate |
| /secret/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/tls/ | server.key                          | Private key |
| /secret/crypto/ordererOrganizations/`orgname_lowercase`-net/orderers/orderer.`orgname_lowercase`-net/tls/ | server.crt                          | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                 | admincerts                          | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                 | keystore                            | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                 | signcerts                           | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                 | tlscacerts                          | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/tls/                                 | ca.crt                              | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/tls/                                 | client.crt                          | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/tls/                                 | client.key                          | Private Key |


-------------------------------
### For each peer organization

| Path                                                                           | Key (for Vault)                    | Type        |
|------------------------------------------------------------------------------------------------------------------|-------------------------------------|-------------|
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/ca/                                                     | ca.`orgname_lowercase`-net-cert.pem | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/ca/                                                     | `orgname_lowercase`-net-CA.key      | Private key |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/orderer/tls                                             | ca.crt                              | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/msp/ | admincerts                          | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/msp/ | keystore                            | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/msp/ | signcerts                           | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/msp/ | tlscacerts                          | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/tls/ | ca.crt                              | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/tls/ | server.key                          | Private key |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/peers/`peername_lowercase`.`orgname_lowercase`-net/tls/ | server.crt                          | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                        | admincerts                          | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                        | keystore                            | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                        | signcerts                           | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/msp/                                        | tlscacerts                          | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/tls/                                        | ca.crt                              | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/tls/                                        | client.crt                          | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/admin/tls/                                        | client.key                          | Private Key |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/msp/                         | admincerts                          | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/msp/                         | cacerts                             | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/msp/                         | keystore                            | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/msp/                         | signcerts                           | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/msp/                         | tlscacerts                          | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/tls/                         | ca.crt                              | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/tls/                         | client.crt                          | Certificate |
| /secret/crypto/peerOrganizations/`orgname_lowercase`-net/users/`username_lowercase`/tls/                         | client.key                          | Private Key |