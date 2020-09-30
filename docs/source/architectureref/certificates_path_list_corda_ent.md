Certificate Paths on Vault for Corda Enterprise
-----------------------------------------------
All values must be Base64 encoded files as BAF decodes them.

### For CENM

| Path (on Vault secrets)           | Crypto-material         | Type        |
|-----------------------------------|-------------------------|-------------|
| /secret/`cenm_orgname_lowercase`/root/certs          | root-key-store.jks                | Root keystore |
| /secret/`cenm_orgname_lowercase`/root/certs          | corda-ssl-trust-store.jks         | SSL certificates truststore |
| /secret/`cenm_orgname_lowercase`/root/certs          | network-root-truststore.jks       | Network Root certificates truststore |
| /secret/`cenm_orgname_lowercase`/root/certs          | corda-ssl-root-keys.jks           | SSL Root keystore |
| /secret/`cenm_orgname_lowercase`/root/certs          | tls-crl-signer-key-store.jks      | Keystore containing tlscrlsigner key |
| /secret/`cenm_orgname_lowercase`/root/certs          | subordinate-key-store.jks         | Keystore containing subordinateca key |
| /secret/`cenm_orgname_lowercase`/`signer_service_name`/certs        | corda-ssl-signer-keys.jks         | Signer keystore |
| /secret/`cenm_orgname_lowercase`/`signer_service_name`/certs        | identity-manager-key-store.jks    | Idman keystore |
| /secret/`cenm_orgname_lowercase`/`signer_service_name`/certs        | network-map-key-store.jks         | Networkmap keystore |
| /secret/`cenm_orgname_lowercase`/`networkmap_service_name`/certs    | corda-ssl-network-map-keys.jks    | Networkmap SSL keystore |
| /secret/`cenm_orgname_lowercase`/`networkmap_service_name`/tlscerts | tlscacerts                        | Networkmap Ambassador Certificate |
| /secret/`cenm_orgname_lowercase`/`networkmap_service_name`/tlscerts | tlskey                            | Networkmap Ambassador Private key |
| /secret/`cenm_orgname_lowercase`/`idman_service_name`/crls          | tls.crl                           | TLS CRL |
| /secret/`cenm_orgname_lowercase`/`idman_service_name`/crls          | ssl.crl                           | SSL CRL |
| /secret/`cenm_orgname_lowercase`/`idman_service_name`/crls          | root.crl                          | Network Root CRL|
| /secret/`cenm_orgname_lowercase`/`idman_service_name`/crls          | subordinate.crl                   | Subordinate CRL |
| /secret/`cenm_orgname_lowercase`/`idman_service_name`/certs         | corda-ssl-identity-manager-keys.jks  | Idman SSL keystore |
| /secret/`cenm_orgname_lowercase`/`idman_service_name`/tlscerts      | tlscacerts                        | Idman Ambassador Certificate |
| /secret/`cenm_orgname_lowercase`/`idman_service_name`/tlscerts      | tlskey                            | Idman Ambassador Private key |
| /secret/`cenm_orgname_lowercase`/`notary_service_name`/certs/nodekeystore                | nodekeystore.jks           | Notary keystore |
| /secret/`cenm_orgname_lowercase`/`notary_service_name`/certs/sslkeystore                 | sslkeystore.jks            | SSL Keystore |
| /secret/`cenm_orgname_lowercase`/`notary_service_name`/certs/truststore                  | truststore.jks             | Trust keystore |
| /secret/`cenm_orgname_lowercase`/`notary_service_name`/certs/networkparam        | network-parameters-initial     | Initial network-parameters file generated during notary registration |
| /secret/`cenm_orgname_lowercase`/`notary_service_name`/nodeInfo                          | nodeInfoFile                   | Notary node info file contents            |
| /secret/`cenm_orgname_lowercase`/`notary_service_name`/nodeInfo                            | nodeInfoName | Notary node info filename with hash    |
| /secret/`cenm_orgname_lowercase`/`notary_service_name`/tlscerts                          | tlscacerts                 | Notary Ambassador Certificate |
| /secret/`cenm_orgname_lowercase`/`notary_service_name`/tlscerts                          | tlskey                     | Notary Ambassador Private key |
| /secret/`cenm_orgname_lowercase`/credentials/keystore                          | idman                     | Idman keystore password |
| /secret/`cenm_orgname_lowercase`/credentials/keystore                          | networkmap                     | Networkmap keystore password |
| /secret/`cenm_orgname_lowercase`/credentials/keystore                          | subordinateca                     | SubordinateCA keystore password |
| /secret/`cenm_orgname_lowercase`/credentials/keystore                          | rootca                     | Root keystore password |
| /secret/`cenm_orgname_lowercase`/credentials/keystore                          | tlscrlsigner                     | Signer keystore password |
| /secret/`cenm_orgname_lowercase`/credentials/keystore                          | keyStorePassword                     | Notary keystore password |
| /secret/`cenm_orgname_lowercase`/credentials/truststore                          | rootca                     | Network root truststore password |
| /secret/`cenm_orgname_lowercase`/credentials/truststore                          | ssl                     | SSL truststore password |
| /secret/`cenm_orgname_lowercase`/credentials/truststore                          | trustStorePassword                     | Notary truststore password |
| /secret/`cenm_orgname_lowercase`/credentials/ssl                          | idman                     | Idman sslkeystore password |
| /secret/`cenm_orgname_lowercase`/credentials/ssl                          | networkmap                     | Networkmap sslkeystore password |
| /secret/`cenm_orgname_lowercase`/credentials/ssl                          | signer                     | Signer sslkeystore password |
| /secret/`cenm_orgname_lowercase`/credentials/ssl                          | root                     | Corda root sslkeystore password |
-----

### For Node/Peer Organization

| Path (`orgname_lowercase` crypto material)              | Crypto-material        | Type        |
|--------------------------------------------------|------------------------|-------------|
| /secret/`orgname_lowercase`/`peer_name`/certs/`idman_service_name`  | `idman_service_name`.crt       | Idman Ambassador Certificate |
| /secret/`orgname_lowercase`/`peer_name`/certs/`networkmap_service_name`   | ``networkmap_service_name``.crt  | Networkmap Ambassador Certificate |
| /secret/`orgname_lowercase`/`peer_name`/certs/nodekeystore         | nodekeystore.jks       | Node keystore |
| /secret/`orgname_lowercase`/`peer_name`/certs/sslkeystore          | sslkeystore.jks        | SSL Keystore |
| /secret/`orgname_lowercase`/`peer_name`/certs/truststore           | truststore.jks         | Trust keystore |
| /secret/`orgname_lowercase`/`peer_name`/root/certs | network-root-truststore.jks | Network Root certificates truststore |
| /secret/`orgname_lowercase`/`peer_name`/tlscerts                   | tlscacerts             | Node Ambassador Certificate |
| /secret/`orgname_lowercase`/`peer_name`/tlscerts                   | tlskey                 | Node Ambassador Private key |
| /secret/`orgname_lowercase`/`peer_name`/credentials                   | root                 | Network root truststore password |
| /secret/`orgname_lowercase`/`peer_name`/credentials                   | truststore                 | Node truststore password |
| /secret/`orgname_lowercase`/`peer_name`/credentials                   | keystore                 | Node keystore password |
