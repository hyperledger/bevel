## ROLE: create/imagepullsecret
This role creates the docker pull registry secret within each namespace.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Check for ImagePullSecret for organisation
This tasks checks if the image secret for the organisation already created or not.
##### Input Variables

    kind: The k8s resource is specified here
    *namespace: The organisation's namespace
    name: The secret name
    *kubeconfig: The kubernetes config file
    *context: The kubernetes current context

##### Output Variables

    secret_present: This variable stores the output of image secret check query.

#### 2. Create the docker pull registry secret for namespace
This tasks creates the docker pull registry image secret for each namespace.
##### Input Variables

    component_ns: Namespace of organisation.
    docker-server: Docker server name, Fetched using 'network.docker.' from network.yaml.
    docker-username: Username of docker server, Fetched using 'network.docker.' from network.yaml.
    docker-password: Password of docker server, Fetched using 'network.docker.' from network.yaml.

**when**:  It runs when *secret_present.resources|length* == 0, i.e. imagesecret is not present.
