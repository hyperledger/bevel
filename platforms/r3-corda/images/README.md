[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Images

### Corda Node ###

For building tls-enabled Corda Node (which can be used as Corda Node as well as Notary), following are the steps:
1. Ensure the **blockchain-linuxkit:latest** is built and available. The blockchain-linuxkit image can be built from the [bevel-samples repo.](https://github.com/hyperledger/bevel-samples/tree/main/images/linuxkit-base)
(If using it from a docker repository, update line 1 of *Dockerfile-corda-tls* file).
2. Execute the following command from this folder. Argument BUILDTIME_CORDA_VERSION=4.9 will build the Corda Node with Corda version 4.9 (so please ensure that the Corda build version is available).
```
	sudo docker build --build-arg BUILDTIME_CORDA_VERSION=4.9 -t corda/node:4.9 -f Dockerfile-corda-tls .

```
3. The above command will create an image with tag *corda/node:4.9*. If you want to upload this image to a registry, update the tag accordingly and then push to docker. Sample command below:
```
	sudo docker tag corda/node:4.9 ghcr.io/hyperledger/bevel-corda:4.9
	sudo docker push ghcr.io/hyperledger/bevel-corda:4.9
```
