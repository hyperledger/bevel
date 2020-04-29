# NetworkMap #

## About ##
This directory contains the files to build networkmap jar file which includes
lib, pom.xml, source, static files. It also contains the Dockerfile for building docker image.
## Dependencies ##
* JDK 8u181
* NodeJS 11
	
## Steps to build the networkmap jar ##

1. To build the project, run the following command:
```	
      mvn clean install -DskipTests
```
2. To execute the networkmap locally:
---
**NOTE:**  the jar file is generated at the target folder.

---
```
      cd target
	  java -jar network-map-service.jar
```
Example: To run using env variables
```
	java \
	-Dtls=true \
	-Dtls-cert-path=/opt/my-certs/tls.crt \
	-Dtls-key-path=/opt/my-certs/tls.key \
	-jar target/network-map-service.jar
```
## Steps to build networkmap image ##

1. To build the image, execute the following command this folder after the jar has been built. 
```
	sudo docker build -t nms:1.0 .

```
2. The above command will create an image with tag *nms:1.0*. If you want to upload this image to a registry, update the tag accordingly and then push to docker. Sample command below:
```
	sudo docker tag nms:1.0 hyperledgerlabs/networkmap-linuxkit:latest
	sudo docker push hyperledgerlabs/networkmap-linuxkit:latest
```
