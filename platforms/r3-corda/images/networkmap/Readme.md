# NetworkMap #

## About ##
This directory contains the files to build networkmap jar file which includes
lib, pom.xml, source, static files. It also contains the Dockerfile for building docker image.
## Dependencies ##
* JDK 8u181
* NodeJS 11
--------------------------------------------------------------------------------------------------------------------------------------------------------------
Sr.No   |	Property		    |Env Variable				   			|Default		|Description
--------------------------------------------------------------------------------------------------------------------------------------------------------------
1. 		auth-password			NETWORKMAP_AUTH_PASSWORD				admin			system admin password
2. 	    auth-username			NETWORKMAP_AUTH_USERNAME				sa				system admin username
3. 		cache-timeout			NETWORKMAP_CACHE_TIMEOUT				2S				http cache timeout for this service in ISO 8601 duration format
4.		db						NETWORKMAP_DB							.db				database directory for this service
5.		hostname				NETWORKMAP_HOSTNAME						0.0.0.0			interface to bind the service to
6.		mongo-connection-string	NETWORKMAP_MONGO_CONNECTION_STRING		embed			MongoDB connection string. If set to embed will start its own mongo instance
7. 		mongod-database			NETWORKMAP_MONGOD_DATABASE				nms				name for mongo database
8.		mongod-location			NETWORKMAP_MONGOD_LOCATION				----			optional location of pre-existing mongod server
9.		network-map-delay		NETWORKMAP_NETWORK_MAP_DELAY			1S				queue time for the network map to update for addition of nodes
10.		param-update-delay		NETWORKMAP_PARAM_UPDATE_DELAY			10S				schedule duration for a parameter update
11.		port					NETWORKMAP_PORT							8080			web port
12.		root-ca-name			NETWORKMAP_ROOT_CA_NAME					CN="", OU=DLT, O=DLT, L=London, ST=London, C=GB. The name for the root ca. If doorman and certman are turned off this will automatically default to Corda dev root ca
13.		tls						NETWORKMAP_TLS							false			whether TLS is enabled or not
14.		tls-cert-path			NETWORKMAP_TLS_CERT_PATH				----			path to cert if TLS is turned on
15. 	tls-key-path			NETWORKMAP_TLS_KEY_PATH				    ----			path to key if TLS turned on
16.		web-root				NETWORKMAP_WEB_ROOT					    /				for remapping the root url for all requests
------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	sudo docker tag nms:1.0 adopblockchaincloud0502.azurecr.io/nms:latest
	sudo docker push adopblockchaincloud0502.azurecr.io/nms:latest
```

	

