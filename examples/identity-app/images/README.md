[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Docker images for Identity Application demo

Contains Dockerfile and other source files to create various Docker images needed for Identity Application demo of Hyperledger Bevel Indy.

## Folder Structure
```
./images
|-- agents
|-- von-network
```

### 1. agents
Docker image contains prerequisites for Indy and also scripts for running Agents like "Faber", "Alice" or "Acme" of demo. For more information follow [GitHub](https://github.com/hyperledger/aries-cloudagent-python).

### 2. von-network
Docker image contains prerequisites for Indy and also scripts for running Indy Web Server. The Web Server is needed to run Identity demo. For more information, see [Documentation](./von-network/README.md)