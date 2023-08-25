# Images

## About
Contains Dockerfiles create various docker images needed for Hyperledger Bevel (Hyperledger Bevel) setup.

## Manually creating images ##

### Alpine Utils ###

Alpine-utils docker image is a light-weight utility image used in Hyperledger Bevel. It is mainly used as init-containers in Hyperledger Bevel Kubernetes deployments to connect to Hashicorp Vault to download certificates.

1. To build the image, execute the following command from this folder. 
```
	sudo docker build -t alpine-utils:1.0 -f alpine-utils.Dockerfile .

```
2. The above command will create an image with tag *alpine-utils:1.0*. If you want to upload this image to a registry, update the tag accordingly and then push to docker. Sample command below:
```
	sudo docker tag alpine-utils:1.0 ghcr.io/hyperledger/bevel-alpine:latest
	sudo docker push ghcr.io/hyperledger/bevel-alpine:latest
```

### Ansible Agent ###

Ansible-agent docker image is used for Jenkins Agent configuration. This image can be used to run Hyperledger Bevel Ansible commands on Jenkins Agent without the need to install Ansible on it.

1. To build the image, execute the following command from this folder. 
```
	sudo docker build -t ansible-agent:1.0 -f ansibleAgent.Dockerfile .

```
2. The above command will create an image with tag *ansible-agent:1.0*. If you want to upload this image to a registry, update the tag accordingly and then push to docker. Sample command below:
```
	sudo docker tag ansible-agent:1.0 ghcr.io/hyperledger/ansible-agent:1.0
	sudo docker push ghcr.io/hyperledger/ansible-agent:1.0
```

---
**NOTE:** Depending on your Jenkins configuration, the Docker repo may have to be public for Jenkins to download this image.

---