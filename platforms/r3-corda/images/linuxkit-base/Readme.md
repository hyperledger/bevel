[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Base Linuxkit #

## About ##
This directory contains the files to build base linuxkit docker image which is then used to build other Corda images.
## Dependencies ##
* [LinuxKit package](https://github.com/linuxkit/linuxkit)
* All the commands need to be run with root privileges
	
## Steps to build Linuxkit-base image ##

1. To build base image (for a docker registry with address **hyperledgerlabs**) run the following command in this directory:
```	
    sudo linuxkit pkg build -org=hyperledgerlabs .
```
Change the docker registry address to your own docker registry in *build.yml* as well.
Check the docker image created by running the following command:
```
	sudo docker image ls
```
Note down the image tag that has been created. For example:
```
REPOSITORY                                         TAG                                              
hyperledgerlabs/linuxkit-java   fb47dcbf8534bce1de86715569deaa42a5bb10f3  
```       

2. Update imagename:tag in line 9 of *minimal-linuxkit-os-base.yml*, then create minimal-linuxkit-os-base docker image refering to this base image created above.
```
    sudo linuxkit build -format docker -name minimal-linuxkit-os-base minimal-linuxkit-os-base.yml
```
This will create a file called *minimal-linuxkit-os-base.docker*

3. Now run the following commands to package the .docker file and upload to your docker registry

```
	mkdir -p ./temp
	mv minimal-linuxkit-os-base.docker ./temp/minimal-linuxkit-os-base.tar
	cd ./temp

	sudo tar xvf minimal-linuxkit-os-base.tar
	sudo rm -f minimal-linuxkit-os-base.tar
	sudo tar cvf minimal-linuxkit-os-base.tar *

	sudo cat minimal-linuxkit-os-base.tar | sudo docker import - minimal-linuxkit-os-base 
	sudo docker tag minimal-linuxkit-os-base hyperledgerlabs/blockchain-linuxkit:latest
	sudo docker push hyperledgerlabs/blockchain-linuxkit:latest
```
You can delete the **temp** directory after pushing the docker image.

**NOTE:** Please change the docker image/tag name according to your registry and have your own docker repository for push.
