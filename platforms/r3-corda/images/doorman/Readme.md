[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Doorman #

## About ##
This directory contains the files to build doorman jar file which includes
lib, pom.xml, source, static files. It also contains the Dockerfile for building docker image.

## Dependencies ##
* JDK 8u181
* NodeJS 11
	
## Steps to build doorman jar ##

1. To build the project, run the following command from this folder:
```	
      mvn clean install -DskipTests
```
2. To execute the Doorman locally:
---
**NOTE:**  The jar file is generated at the target folder.

---
```
      cd target
	  java -jar doorman.jar
```
Example: To run using env variables
```	
	java \
	-Dtls=true \
	-Dtls-cert-path=/opt/my-certs/tls.crt \
	-Dtls-key-path=/opt/my-certs/tls.key \
	-jar target/doorman.jar
```
## Steps to build doorman image ##

1. To build the image, execute the following command this folder after the jar has been built. 
```
	sudo docker build -t doorman:1.0 .

```
2. The above command will create an image with tag *doorman:1.0*. If you want to upload this image to a registry, update the tag accordingly and then push to docker. Sample command below:
```
	sudo docker tag doorman:1.0 hyperledgerlabs/doorman-linuxkit:latest
	sudo docker push hyperledgerlabs/doorman-linuxkit:latest
```
