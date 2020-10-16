# Images

## About
Contains Dockerfile and other source files to create various docker images needed for Blockchain Automation Framework Corda Enterprise setup.

### Usage  
These dockerfiles are a wrapper on Official Corda Enterprise images. These changes are needed as we update the java keystore for Ambassador proxy certificates 
which needs root access.
Build with the following command from this folder:

---
### For pki
```
	sudo docker build -t <your registry>/corda/enterprise-pki:1.2-zulu-openjdk8u242 -f pki.dockerfile .

```
You will have to upload the image to a your registry. Use this registry url in `docker` section of network.yaml. Sample command below:
```
	sudo docker push <your registry>/corda/enterprise-pki:1.2-zulu-openjdk8u242
```
---
### For networkmap
```
	sudo docker build -t <your registry>/corda/enterprise-networkmap:1.2-zulu-openjdk8u242 -f networkmap.dockerfile .

```
You will have to upload the image to a your registry. Use this registry url in `docker` section of network.yaml. Sample command below:
```
	sudo docker push <your registry>/corda/enterprise-networkmap:1.2-zulu-openjdk8u242
```
---
### For notary
```
	sudo docker build -t <your registry>/corda/enterprise-notary:1.2-zulu-openjdk8u242 -f notary.dockerfile .

```
You will have to upload the image to a your registry. Use this registry url in `docker` section of network.yaml. Sample command below:
```
	sudo docker push <your registry>/corda/enterprise-notary:1.2-zulu-openjdk8u242
```
---