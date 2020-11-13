Certificate Paths on Vault for Corda Network
---------------------------------------------

* Optionally, `secret_path` can be set on the network.yaml to change the secret engine from the default `secret/`.

### For Networkmap 

| Path (networkmap crypto material) | Crypto-material         | Type        |
|-----------------------------------|-------------------------|-------------|
| /secrets/networkmap/certs         | networkmap.jks          | Certificate |
| /secrets/networkmap/certs         | cacerts                 | Certificate |
| /secrets/networkmap/certs         | keystore                | Certificate |
| /secrets/networkmap/certs         | rootcakey               | Private key |
| /secrets/networkmap/tlscerts      | tlscacerts              | Certificate |
| /secrets/networkmap/tlscerts      | tlskey                  | Private key |

----
### For Doorman 

| Path (doorman crypto material) | Crypto-material         | Type        |
|--------------------------------|-------------------------|-------------|
| /secrets/doorman/certs         | doorman.jks             | Certificate |
| /secrets/doorman/certs         | cacerts                 | Certificate |
| /secrets/doorman/certs         | keystore                | Certificate |
| /secrets/doorman/certs         | rootcakey               | private key |
| /secrets/doorman/tlscerts      | tlscacerts              | Certificate |
| /secrets/doorman/tlscerts      | tlskey                  | Private key |

-----
### For Notary organization 

| Path (notary crypto material)              | Crypto-material        | Type        |
|--------------------------------------------|------------------------|-------------|
| /secrets/notary/certs                      | Notary.cer             | Certificate |
| /secrets/notary/certs                      | Notary.key             | Private key |
| /secrets/notary/certs/customnodekeystore   | nodekeystore.jks       | Certificate |
| /secrets/notary/certs/doorman              | doorman.crt            | Certificate |
| /secrets/notary/certs/networkmap           | networkmap.crt         | Certificate |
| /secrets/notary/certs/networkmaptruststore | network-map-truststore | Certificate |
| /secrets/notary/certs/nodekeystore         | nodekeystore.jks       | Certificate |
| /secrets/notary/certs/sslkeystore          | sslkeystore.jks        | Certificate |
| /secrets/notary/certs/truststore           | truststore.jks         | Certificate |
| /secrets/notary/tlscerts                   | tlscacerts             | Certificate |
| /secrets/notary/tlscerts                   | tlskey                 | Private key |

-----

### For Node/Peer Organization 

| Path (`orgname_lowercase` crypto material)              | Crypto-material        | Type        |
|--------------------------------------------------|------------------------|-------------|
| /secrets/`orgname_lowercase`/certs                      | `orgname_lowercase`.cer       | Certificate |
| /secrets/`orgname_lowercase`/certs                      | `orgname_lowercase`.key       | Private key |
| /secrets/`orgname_lowercase`/certs/customnodekeystore   | nodekeystore.jks       | Certificate |
| /secrets/`orgname_lowercase`/certs/doorman              | doorman.crt            | Certificate |
| /secrets/`orgname_lowercase`/certs/networkmap           | networkmap.crt         | Certificate |
| /secrets/`orgname_lowercase`/certs/networkmaptruststore | network-map-truststore | Certificate |
| /secrets/`orgname_lowercase`/certs/nodekeystore         | nodekeystore.jks       | Certificate |
| /secrets/`orgname_lowercase`/certs/sslkeystore          | sslkeystore.jks        | Certificate |
| /secrets/`orgname_lowercase`/certs/truststore           | truststore.jks         | Certificate |
| /secrets/`orgname_lowercase`/tlscerts                   | tlscacerts             | Certificate |
| /secrets/`orgname_lowercase`/tlscerts                   | tlskey                 | Private key |