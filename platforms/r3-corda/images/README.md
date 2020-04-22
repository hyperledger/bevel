# Images

## About
Contains Dockerfile and other source files to create various docker images needed for Blockchain Automation Framework Corda setup. These steps are also automated using Jenkinsfile. [Click here](/automation/r3-corda/README.md) to see the automation steps. 

## Folder Structure ##
```
/images
|-- doorman
|-- linuxkit-base
|-- networkmap
```
## Manually creating images ##
For **doorman**, **linuxkit-base** and **networkmap**, follow the readme's in the respective folders.

### Corda Node ###

For building tls-enabled Corda Node (which can be used as Corda Node as well as Notary), following are the steps:
1. Ensure the **blockchain-linuxkit:latest** is built and available. (If using it from a docker repository, update line 1 of *Dockerfile-corda-tls* file).
2. Execute the following command from this folder. Argument BUILDTIME_CORDA_VERSION=4.4 will build the Corda Node with Corda version 4.4 (so please ensure that the Corda build version is available).
```
	sudo docker build --build-arg BUILDTIME_CORDA_VERSION=4.4 -t corda/node:4.4 -f Dockerfile-corda-tls .

```
3. The above command will create an image with tag *corda_node:4.4*. If you want to upload this image to a registry, update the tag accordingly and then push to docker. Sample command below:
```
	sudo docker tag corda/node:4.4 hyperledgerlabs/corda:4.4-linuxkit
	sudo docker push hyperledgerlabs/corda:4.4-linuxkit
```
