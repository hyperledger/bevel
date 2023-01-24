[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# **GitOps** 

[GitOps](https://www.weave.works/technologies/gitops/) introduces an approach that can make K8s cluster management easier and also guarantee the latest application delivery is on time.

Hyperledger Bevel uses Weavework's Flux for the implementation of GitOps and executes an Ansible role called [*setup/flux*](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/roles) defined in its GitHub repo that will:

* Scan for existing SSH Hosts
* Authorize client machine as per kube.yaml
* Add weavework flux repository in helm local repository
* Install flux
