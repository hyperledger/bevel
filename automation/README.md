# Automation

## About
This folder contains the Input configuration file and Jenkinsfile for r3-corda, hyperledger fabric which helps in automation of corda/fabric network.

## Folder Structure ###
```
/automation
|-- hyperledger-fabric
|-- r3-corda
|-- initcontainer.Jenkinsfile
```
## Description 

* **hyperledger-fabric** - Contains network.yaml file and fabric Jenkinsfile.
* **r3-corda** - Contains network.yaml file and Jenkinsfile for doorman,networkmap and entire network deployment file.
* **initcontainer.Jenkinsfile** - This file is used to initialize a container with basic configuration. This will be used on both hyperledger and r3-corda platforms.