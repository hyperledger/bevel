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

#### 7.  Check Ambassador cred exists
This task checks if Ambassador credentials exists already
##### Input Variables

    *kind: This defines the kind of Kubernetes resource
    *namespace: Namespace of the component 
    *name: The name of credentials
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    get_secret: This variable stores the output of Ambassador credentials check query.
**when**: Condition is specified here, runs only when *network.env.proxy* is ambassador.
    
#### 8. Check if ca certs already created
This tasks checks if the CA certificates are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
##### Output Variables

    vault_capem_result: This variable stores the output of ca certificates check query.
**when**: Condition is specified here, runs only when *network.env.proxy* is ambassador.

#### 9. Check if ca key already created
This tasks checks if the CA key are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
##### Output Variables

    vault_cakey_result: This variable stores the output of ca certificates check query.
**when**: Condition is specified here, runs only when *network.env.proxy* is ambassador.

#### 10.  Create the Ambassador credentials
This task creates the Ambassador TLS credentials
##### Input Variables
    *KUBECONFIG: Contains config file of cluster, Fetched using 'kubernetes.' from network.yaml
    *namespace: Namespace of the component 
**when**: Conditions is specified here, runs only when *get_secret.resources* is not found, *vault_capem_result.failed* is False, *vault_cakey_result.failed* is False and *network.env.proxy* is ambassador.

#### 11.  Check Ambassador cred exists for orderers
This task checks if Ambassador credentials exists already for orderes
##### Input Variables

    *kind: This defines the kind of Kubernetes resource
    *namespace: Namespace of the component 
    *name: The name of credentials
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    get_secret: This variable stores the output of Ambassador credentials check query.
**when**: Condition is specified here, runs only when *network.env.proxy* is ambassador.

#### 12. Check if ca certs already created for orderers
This tasks checks if the CA certificates are already created or not for orderers.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
##### Output Variables

    vault_capem_result: This variable stores the output of ca certificates check query.
**when**: Condition is specified here, runs only when *network.env.proxy* is ambassador.

#### 13. Check if ca key already created for orderers
This tasks checks if the CA key are already created or not for orderers.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
##### Output Variables

    vault_cakey_result: This variable stores the output of ca certificates check query.
**when**: Condition is specified here, runs only when *network.env.proxy* is ambassador.

#### 14.  Create the Ambassador credentials for orderers
This task creates the Ambassador TLS credentials for orderers
##### Input Variables
    *KUBECONFIG: Contains config file of cluster, Fetched using 'kubernetes.' from network.yaml
    *namespace: Namespace of the component 
**when**: Conditions is specified here, runs only when *get_orderer_secret.resources* is not found, *vault_orderercert_result.failed* is False, *vault_ordererkey_result.failed* is False and *network.env.proxy* is ambassador.
