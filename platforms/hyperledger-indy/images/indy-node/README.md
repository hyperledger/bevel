[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## Hyperledger Bevel Indy bevel-indy-node Docker image
Docker image of an Indy node (runs using a Steward identity)

### Build
Ideally, the build of the image should be run from this directory.<br>
For build run command below:
```bash
docker build -t <docker_url>/bevel-indy-node:1.12.6 .
```
*NOTE*: Version 1.11.0 is default version also for version of Hyperledger Indy in this Docker image.<br>
When you would like to use older version, then override build arguments.<br>
Example for use version 1.9.2:
```bash
docker build --build-arg indy_plenum_ver=1.12.6 --build-arg indy_node_ver=1.12.6 -t <docker_url>/bevel-indy-node:1.12.6 .
```
#### Build arguments with default values
 - indy_plenum_ver=1.12.6
 - indy_node_ver=1.12.6

### Using
The Docker image is created specially for Helm Chart [indy-node](../../charts/indy-node).
It starts Indy node with inserted parameters via environment variables such node name, node ip address and ports.
Indy node needs keys, domain transactions genesis and pool transactions genesis.

The Helm chart [indy-node](../../charts/indy-node) is able to get needed data via:
 - keys from Hashicorp Vault
 - domain transactions genesis via Config Map
 - pool transactions genesis via Config Map
