[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

Certificate Paths on Vault for Corda Network
---------------------------------------------

* Secrets engine kv path for each organization services (networkmap, doorman, notary, nodes) are enabled via the automation.

### For Networkmap 

| Path (networkmap crypto material)          | Crypto-material         | Type        |
|--------------------------------------------|-------------------------|-------------|
| /`networkmap.name_lowercase`/certs         | networkmap.jks          | Certificate |
| /`networkmap.name_lowercase`/certs         | cacerts                 | Certificate |
| /`networkmap.name_lowercase`/certs         | keystore                | Certificate |
| /`networkmap.name_lowercase`/certs         | rootcakey               | Private key |
| /`networkmap.name_lowercase`/tlscerts      | tlscacerts              | Certificate |
| /`networkmap.name_lowercase`/tlscerts      | tlskey                  | Private key |

----
### For Doorman 

| Path (doorman crypto material)          | Crypto-material         | Type        |
|-----------------------------------------|-------------------------|-------------|
| /`doorman.name_lowercase`/certs         | doorman.jks             | Certificate |
| /`doorman.name_lowercase`/certs         | cacerts                 | Certificate |
| /`doorman.name_lowercase`/certs         | keystore                | Certificate |
| /`doorman.name_lowercase`/certs         | rootcakey               | private key |
| /`doorman.name_lowercase`/tlscerts      | tlscacerts              | Certificate |
| /`doorman.name_lowercase`/tlscerts      | tlskey                  | Private key |

-----
### For Notary organization 

| Path (notary crypto material)                       | Crypto-material        | Type        |
|-----------------------------------------------------|------------------------|-------------|
| /`notary.name_lowercase`/certs                      | Notary.cer             | Certificate |
| /`notary.name_lowercase`/certs                      | Notary.key             | Private key |
| /`notary.name_lowercase`/certs/customnodekeystore   | nodekeystore.jks       | Certificate |
| /`notary.name_lowercase`/certs/doorman              | doorman.crt            | Certificate |
| /`notary.name_lowercase`/certs/networkmap           | networkmap.crt         | Certificate |
| /`notary.name_lowercase`/certs/networkmaptruststore | network-map-truststore | Certificate |
| /`notary.name_lowercase`/certs/nodekeystore         | nodekeystore.jks       | Certificate |
| /`notary.name_lowercase`/certs/sslkeystore          | sslkeystore.jks        | Certificate |
| /`notary.name_lowercase`/certs/truststore           | truststore.jks         | Certificate |
| /`notary.name_lowercase`/tlscerts                   | tlscacerts             | Certificate |
| /`notary.name_lowercase`/tlscerts                   | tlskey                 | Private key |

-----

### For Node/Peer Organization 

| Path (`node.name_lowercase` crypto material)      | Crypto-material        | Type        |
|---------------------------------------------------|------------------------|-------------|
| /`node.name_lowercase`/certs                      | `node.name_lowercase`.cer       | Certificate |
| /`node.name_lowercase`/certs                      | `node.name_lowercase`.key       | Private key |
| /`node.name_lowercase`/certs/customnodekeystore   | nodekeystore.jks       | Certificate |
| /`node.name_lowercase`/certs/doorman              | doorman.crt            | Certificate |
| /`node.name_lowercase`/certs/networkmap           | networkmap.crt         | Certificate |
| /`node.name_lowercase`/certs/networkmaptruststore | network-map-truststore | Certificate |
| /`node.name_lowercase`/certs/nodekeystore         | nodekeystore.jks       | Certificate |
| /`node.name_lowercase`/certs/sslkeystore          | sslkeystore.jks        | Certificate |
| /`node.name_lowercase`/certs/truststore           | truststore.jks         | Certificate |
| /`node.name_lowercase`/tlscerts                   | tlscacerts             | Certificate |
| /`node.name_lowercase`/tlscerts                   | tlskey                 | Private key |