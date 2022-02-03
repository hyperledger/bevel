[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

Certificate Paths on Vault for Corda Enterprise
-----------------------------------------------
* All values must be Base64 encoded files as Bevel decodes them.
* Optionally, `secret_path` can be set on the network.yaml to change the secret engine from the default `secretsv2/`.

### For CENM

| Path (on Vault secrets)           | Crypto-material         | Type        |
|-----------------------------------|-------------------------|-------------|
| /secretsv2/`cenm_orgname_lowercase`/root/certs          | root-key-store.jks                | Root keystore |
| /secretsv2/`cenm_orgname_lowercase`/root/certs          | corda-ssl-trust-store.jks         | SSL certificates truststore |
| /secretsv2/`cenm_orgname_lowercase`/root/certs          | network-root-truststore.jks       | Network Root certificates truststore |
| /secretsv2/`cenm_orgname_lowercase`/root/certs          | corda-ssl-root-keys.jks           | SSL Root keystore |
| /secretsv2/`cenm_orgname_lowercase`/root/certs          | tls-crl-signer-key-store.jks      | Keystore containing tlscrlsigner key |
| /secretsv2/`cenm_orgname_lowercase`/root/certs          | subordinate-key-store.jks         | Keystore containing subordinateCA key |
| /secretsv2/`cenm_orgname_lowercase`/`signer_service_name`/certs        | corda-ssl-signer-keys.jks         | Signer keystore |
| /secretsv2/`cenm_orgname_lowercase`/`signer_service_name`/certs        | identity-manager-key-store.jks    | Idman keystore |
| /secretsv2/`cenm_orgname_lowercase`/`signer_service_name`/certs        | network-map-key-store.jks         | Networkmap keystore |
| /secretsv2/`cenm_orgname_lowercase`/`networkmap_service_name`/certs    | corda-ssl-network-map-keys.jks    | Networkmap SSL keystore |
| /secretsv2/`cenm_orgname_lowercase`/`networkmap_service_name`/tlscerts | tlscacerts                        | Networkmap Ambassador Certificate |
| /secretsv2/`cenm_orgname_lowercase`/`networkmap_service_name`/tlscerts | tlskey                            | Networkmap Ambassador Private key |
| /secretsv2/`cenm_orgname_lowercase`/`idman_service_name`/crls          | tls.crl                           | TLS CRL |
| /secretsv2/`cenm_orgname_lowercase`/`idman_service_name`/crls          | ssl.crl                           | SSL CRL |
| /secretsv2/`cenm_orgname_lowercase`/`idman_service_name`/crls          | root.crl                          | Network Root CRL|
| /secretsv2/`cenm_orgname_lowercase`/`idman_service_name`/crls          | subordinate.crl                   | Subordinate CRL |
| /secretsv2/`cenm_orgname_lowercase`/`idman_service_name`/certs         | corda-ssl-identity-manager-keys.jks  | Idman SSL keystore |
| /secretsv2/`cenm_orgname_lowercase`/`idman_service_name`/tlscerts      | tlscacerts                        | Idman Ambassador Certificate |
| /secretsv2/`cenm_orgname_lowercase`/`idman_service_name`/tlscerts      | tlskey                            | Idman Ambassador Private key |
| /secretsv2/`cenm_orgname_lowercase`/`notary_service_name`/certs/nodekeystore                | nodekeystore.jks           | Notary keystore |
| /secretsv2/`cenm_orgname_lowercase`/`notary_service_name`/certs/sslkeystore                 | sslkeystore.jks            | SSL Keystore |
| /secretsv2/`cenm_orgname_lowercase`/`notary_service_name`/certs/truststore                  | truststore.jks             | Trust keystore |
| /secretsv2/`cenm_orgname_lowercase`/`notary_service_name`/certs/networkparam        | network-parameters-initial     | Initial network-parameters file generated during notary registration |
| /secretsv2/`cenm_orgname_lowercase`/`notary_service_name`/nodeInfo                          | nodeInfoFile                   | Notary node info file contents            |
| /secretsv2/`cenm_orgname_lowercase`/`notary_service_name`/nodeInfo                            | nodeInfoName | Notary node info filename with hash    |
| /secretsv2/`cenm_orgname_lowercase`/`notary_service_name`/tlscerts                          | tlscacerts                 | Notary Ambassador Certificate |
| /secretsv2/`cenm_orgname_lowercase`/`notary_service_name`/tlscerts                          | tlskey                     | Notary Ambassador Private key |
| /secretsv2/`cenm_orgname_lowercase`/credentials/keystore                          | idman                     | Idman keystore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/keystore                          | networkmap                     | Networkmap keystore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/keystore                          | subordinateCA                     | SubordinateCA keystore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/keystore                          | rootCA                     | Root keystore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/keystore                          | tlscrlsigner                     | Signer keystore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/keystore                          | keyStorePassword                     | Notary keystore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/truststore                          | rootCA                     | Network root truststore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/truststore                          | ssl                     | SSL truststore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/truststore                          | trustStorePassword                     | Notary truststore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/ssl                          | idman                     | Idman sslkeystore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/ssl                          | networkmap                     | Networkmap sslkeystore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/ssl                          | signer                     | Signer sslkeystore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/ssl                          | root                     | Corda root sslkeystore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/ssl                          | auth                     | Auth sslkeystore password |
| /secretsv2/`cenm_orgname_lowercase`/credentials/cordapps                     | repo_username                     | Cordapps repository username |
| /secretsv2/`cenm_orgname_lowercase`/credentials/cordapps                     | repo_password                     | Cordapps repository password |


### For Node/Peer Organization

| Path (`orgname_lowercase` crypto material)              | Crypto-material        | Type        |
|--------------------------------------------------|------------------------|-------------|
| /secretsv2/`orgname_lowercase`/`peer_name`/certs/`idman_service_name`  | `idman_service_name`.crt       | Idman Ambassador Certificate |
| /secretsv2/`orgname_lowercase`/`peer_name`/certs/`networkmap_service_name`   | ``networkmap_service_name``.crt  | Networkmap Ambassador Certificate |
| /secretsv2/`orgname_lowercase`/`peer_name`/certs/nodekeystore         | nodekeystore.jks       | Node keystore |
| /secretsv2/`orgname_lowercase`/`peer_name`/certs/sslkeystore          | sslkeystore.jks        | SSL Keystore |
| /secretsv2/`orgname_lowercase`/`peer_name`/certs/truststore           | truststore.jks         | Trust keystore |
| /secretsv2/`orgname_lowercase`/`peer_name`/certs/firewall           | firewallca.jks         | FirewallCA keystore |
| /secretsv2/`orgname_lowercase`/`peer_name`/certs/firewall           | float.jks         | Float keystore |
| /secretsv2/`orgname_lowercase`/`peer_name`/certs/firewall           | bridge.jks         | Bridge keystore |
| /secretsv2/`orgname_lowercase`/`peer_name`/certs/firewall           | trust.jks         | Truststore keystore |
| /secretsv2/`orgname_lowercase`/`peer_name`/root/certs | network-root-truststore.jks | Network Root certificates truststore |
| /secretsv2/`orgname_lowercase`/`peer_name`/tlscerts                   | tlscacerts             | Node Ambassador Certificate |
| /secretsv2/`orgname_lowercase`/`peer_name`/tlscerts                   | tlskey                 | Node Ambassador Private key |
| /secretsv2/`orgname_lowercase`/`peer_name`/credentials                   | root                 | Network root truststore password |
| /secretsv2/`orgname_lowercase`/`peer_name`/credentials                   | truststore                 | Node truststore password |
| /secretsv2/`orgname_lowercase`/`peer_name`/credentials                   | keystore                 | Node keystore password |
| /secretsv2/`orgname_lowercase`/`peer_name`/credentials                   | firewallCA                 | FirewallCA keystore and corresponding truststore password |
| /secretsv2/`orgname_lowercase`/`peer_name`/credentials                   | float                 | Float keystore password |
| /secretsv2/`orgname_lowercase`/`peer_name`/credentials                   | bridge                 | Bridge keystore password |
| /secretsv2/`orgname_lowercase`/`peer_name`/credentials                   | `peer_name`                 | Rpc user password |
| /secretsv2/`orgname_lowercase`/`peer_name`/credentials                   | repo_username               | Cordapps repository username |
| /secretsv2/`orgname_lowercase`/`peer_name`/credentials                   | repo_password              | Cordapps repository password |
