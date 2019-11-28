# Images

## About
Contains Dockerfiles create various docker images needed for The Blockchain Automation Framework setup.

## Manually creating images ##

### Alpine Utils ###

Alpine-utils docker image is a light-weight utility image used in The Blockchain Automation Framework. It is mainly used as init-containers in The Blockchain Automation Framework Kubernetes deployments to connect to Hashicorp Vault to download certificates.

1. To build the image, execute the following command from this folder. 
```
	sudo docker build -t alpine-utils:1.0 -f alpine-utils.Dockerfile .

```
2. The above command will create an image with tag *alpine-utils:1.0*. If you want to upload this image to a registry, update the tag accordingly and then push to docker. Sample command below:
```
	sudo docker tag alpine-utils:1.0 adopblockchaincloud0502.azurecr.io/alpine-utils:1.0
	sudo docker push adopblockchaincloud0502.azurecr.io/alpine-utils:1.0
```

### Ansible Slave ###

Ansible-slave docker image is used for Jenkins Slave configuration. This image can be used to run The Blockchain Automation Framework Ansible commands on Jenkins without the need to install Ansible on the Jenkins master.

1. To build the image, execute the following command from this folder. 
```
	sudo docker build -t ansible-slave:1.0 -f ansibleSlave.Dockerfile .

```
2. The above command will create an image with tag *ansible-slave:1.0*. If you want to upload this image to a registry, update the tag accordingly and then push to docker. Sample command below:
```
	sudo docker tag ansible-slave:1.0 adopblockchaincloud0502.azurecr.io/ansible-slave:1.0
	sudo docker push adopblockchaincloud0502.azurecr.io/ansible-slave:1.0
```

---
**NOTE:** Depending on your Jenkins configuration, the Docker repo may have to be public for Jenkins to download this image.

---