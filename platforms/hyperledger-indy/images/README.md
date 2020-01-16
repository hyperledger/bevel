## Blockchain Automation Framework Indy Docker images

Contains Dockerfile and other source files to create various Docker images needed for Blockchain Automation Framework Indy setup. These steps are also automated using [Jenkinsfile](../../../automation/hyperledger-indy/Jenkinsfile)

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
Docker image for indy key management, which allows using commands in bash.
For more information, see [Documentation](./indy-key-mgmt/README.md)
### indy-node
Docker image for Indy node of Stewards.
For more information, see [Documentation](./indy-node/README.md)

## Manually creating images
Follow the readme's in the respective folders.
