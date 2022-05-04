[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## Hyperledger Bevel Indy Docker images

Contains Dockerfile and other source files to create various Docker images needed for Hyperledger Bevel Indy setup. These steps are also automated using [Jenkinsfile](../../../automation/hyperledger-indy/Jenkinsfile)

## Folder Structure
```
./images
|-- indy-cli
|-- indy-key-mgmt
|-- indy-node
```

### indy-cli
Docker image contains Indy CLI, which is used to issue transactions agains an Indy pool.
For more information, see [Documentation](./indy-cli/README.md)

### indy-key-mgmt
Docker image for indy key management, which generates identity crypto and stores it into Vault or displays it onto the terminal in json format.
For more information, see [Documentation](./indy-key-mgmt/README.md)
### indy-node
Docker image of an Indy node (runs using a Steward identity)
For more information, see [Documentation](./indy-node/README.md)

## Manually creating images
Follow the readme's in the respective folders.
