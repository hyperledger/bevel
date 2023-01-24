[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: k8s_secrets
This role creates secrets to store the following resources: ambassador credentials.
#### 1. Check Ambassador cred exists
This tasks check if the Check Ambassador credentials exists or not.
##### Input Variables

    *kind: This defines the kind of Kubernetes resource
    *namespace: The namespace of the component
    *name: Name of the component 
    *kubeconfig: The config file of the cluster
    *context: This refer to the required kubernetes cluster context
##### Output Variables

    get_ambassador_secret: This variable stores the output of Ambassador credentials check query.

#### 2. Check if ambassador tls certs already created
This tasks checks if ambassador tls certificates are already created or not.
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
    ignore_errors: Ignore if any error occurs

##### Output Variables

    certs: This variable stores the output of root certificates check query.


#### 3. Gets the existing ambassador tls certs
This tasks get ambassador and tls certs from Vault
##### Input Variables

    *VAULT_ADDR: Contains Vault URL, Fetched using 'vault.' from network.yaml
    *VAULT_TOKEN: Contains Vault Token, Fetched using 'vault.' from network.yaml
##### Output Variables

    certs_yaml: This variable stores the output of ambassador tls certificates check query.

**when**: It runs when *certs*.failed == False, i.e. ambassador tls certs are present.

#### 4. Get ambassador tls certs
This task fetches the generated ambassador tls certificates by calling role *setup/get_crypto

##### Input Variables
    *cert_path: The path where to check/create is specified here.
    *vault_output: Yaml with certs_yaml output.
    type:  ambassador 
    
**when**: It runs when *certs*.failed == False, i.e. ambassador tls certs are present.
 
#### 5. Create the Ambassador credentials
This task creates the Ambassador TLS credentials
##### Input Variables
    *KUBECONFIG: Contains config file of cluster, Fetched using 'kubernetes.' from network.yaml
    *namespace: Namespace of the component 
**when**: Conditions is specified here, runs only when *get_ambassador_secret.resources* are not found and *certs*.failed == False

#### Note: 
vars folder has environment variable for ambassador role.
