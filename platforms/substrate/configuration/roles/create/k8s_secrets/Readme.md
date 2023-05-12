[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: k8s_secrets
This role creates secrets to store the following resources: root token, reviewer token, and docker credentials
#### 1. Check if root token exists in the namespace
This task checks if the root token exists
##### Input Variables

    *kind: This defines the kind of Kubernetes resource
    *namespace: Namespace of the component 
    *name: The name of secret
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    root_token_secret: This variable stores the output of root token check query.
    
#### 2. Put root token of every organization
This task creates the root tooken secret
##### Input Variables
    *namespace: Namespace of the component 
    *vault: Contains the root token, Fetched using 'vault.' from network.yaml
**when**: Condition is specified here, runs only when *root_token_secret.resources* is not found.

#### 3. Check if reviewer token exists in the namespace
This task checks if the reviewer token exists
##### Input Variables

    *kind: This defines the kind of Kubernetes resource
    *namespace: Namespace of the component 
    *name: The name of secret
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    reviewer_token_secret: This variable stores the output of reviewer token check query.
    
#### 4. Put reviewer token of every organization
This task creates the reviewer tooken secrets
##### Input Variables
    *KUBECONFIG: Contains config file of cluster, Fetched using 'kubernetes.' from network.yaml 
    *namespace: Namespace of the component 
**shell** : This command creates the reviewer token secret.
**when**: Condition is specified here, runs only when *reviewer_token_secret.resources* is not found.

#### 5.  Check docker cred exists
This task checks if the docker credentials exists
##### Input Variables

    *kind: This defines the kind of Kubernetes resource
    *namespace: Namespace of the component 
    *name: The name of credentials
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    get_regcred: This variable stores the output of docker credentials check query.
    
#### 6.  Create the docker pull credentials
This task creates the docker pull credentials
##### Input Variables
    *KUBECONFIG: Contains config file of cluster, Fetched using 'kubernetes.' from network.yaml
    *namespace: Namespace of the component 
**when**: Condition is specified here, runs only when *get_regcred.resources* is not found.
