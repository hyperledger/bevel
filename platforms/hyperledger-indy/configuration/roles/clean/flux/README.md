[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## clean/flux
The role deletes the Helm release of Flux and git authentication secret from Kubernetes.

### Tasks:
#### 1. Delete Helm release
The task deletes a secret from kubernetes for git authentication. It also delete deployed Helm release fo Flux.
##### Variables:
 - kubernetes.config_file: A path of config file of Kubernetes cluster.
 - network.env.type: A tag for the environment from network.yaml file.

#### 2. Wait for deleting of Helm release flux-{{ network.env.type }}
The task is waiting until all pods of Flux are deleted from Kubernetes cluster.
##### Variables:
 - network.env.type: A tag for the environment from network.yaml file.
 - kubernetes.config_file: A path of config file of Kubernetes cluster.
 - network.env.retry_count: Number of repetitions.
##### Input Variables:
 - result.resources: A count of running pods of a Flux.
##### Output Variables:
 - result: A variable for storing output of resources - a count of running pods.
