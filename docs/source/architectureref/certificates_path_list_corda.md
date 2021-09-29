Certificate Paths on Vault for Corda Network
---------------------------------------------

* Optionally, `secret_path` can be set on the network.yaml to change the secret engine from the default `secretsv2/`.

### For Networkmap 

| Path (networkmap crypto material) | Crypto-material         | Type        |
|-----------------------------------|-------------------------|-------------|
| /secretsv2/networkmap/certs         | networkmap.jks          | Certificate |
| /secretsv2/networkmap/certs         | cacerts                 | Certificate |
| /secretsv2/networkmap/certs         | keystore                | Certificate |
| /secretsv2/networkmap/certs         | rootcakey               | Private key |
| /secretsv2/networkmap/tlscerts      | tlscacerts              | Certificate |
| /secretsv2/networkmap/tlscerts      | tlskey                  | Private key |

----
### For Doorman 

| Path (doorman crypto material) | Crypto-material         | Type        |
|--------------------------------|-------------------------|-------------|
| /secretsv2/doorman/certs         | doorman.jks             | Certificate |
| /secretsv2/doorman/certs         | cacerts                 | Certificate |
| /secretsv2/doorman/certs         | keystore                | Certificate |
| /secretsv2/doorman/certs         | rootcakey               | private key |
| /secretsv2/doorman/tlscerts      | tlscacerts              | Certificate |
| /secretsv2/doorman/tlscerts      | tlskey                  | Private key |

-----
### For Notary organization 

| Path (notary crypto material)              | Crypto-material        | Type        |
|--------------------------------------------|------------------------|-------------|
| /secretsv2/notary/certs                      | Notary.cer             | Certificate |
| /secretsv2/notary/certs                      | Notary.key             | Private key |
| /secretsv2/notary/certs/customnodekeystore   | nodekeystore.jks       | Certificate |
| /secretsv2/notary/certs/doorman              | doorman.crt            | Certificate |
| /secretsv2/notary/certs/networkmap           | networkmap.crt         | Certificate |
| /secretsv2/notary/certs/networkmaptruststore | network-map-truststore | Certificate |
| /secretsv2/notary/certs/nodekeystore         | nodekeystore.jks       | Certificate |
| /secretsv2/notary/certs/sslkeystore          | sslkeystore.jks        | Certificate |
| /secretsv2/notary/certs/truststore           | truststore.jks         | Certificate |
| /secretsv2/notary/tlscerts                   | tlscacerts             | Certificate |
| /secretsv2/notary/tlscerts                   | tlskey                 | Private key |

-----

### For Node/Peer Organization 

| Path (`orgname_lowercase` crypto material)              | Crypto-material        | Type        |
|--------------------------------------------------|------------------------|-------------|
| /secretsv2/`orgname_lowercase`/certs                      | `orgname_lowercase`.cer       | Certificate |
| /secretsv2/`orgname_lowercase`/certs                      | `orgname_lowercase`.key       | Private key |
| /secretsv2/`orgname_lowercase`/certs/customnodekeystore   | nodekeystore.jks       | Certificate |
| /secretsv2/`orgname_lowercase`/certs/doorman              | doorman.crt            | Certificate |
| /secretsv2/`orgname_lowercase`/certs/networkmap           | networkmap.crt         | Certificate |
| /secretsv2/`orgname_lowercase`/certs/networkmaptruststore | network-map-truststore | Certificate |
| /secretsv2/`orgname_lowercase`/certs/nodekeystore         | nodekeystore.jks       | Certificate |
| /secretsv2/`orgname_lowercase`/certs/sslkeystore          | sslkeystore.jks        | Certificate |
| /secretsv2/`orgname_lowercase`/certs/truststore           | truststore.jks         | Certificate |
| /secretsv2/`orgname_lowercase`/tlscerts                   | tlscacerts             | Certificate |
| /secretsv2/`orgname_lowercase`/tlscerts                   | tlskey                 | Private key |