<a name = "upgrading-2to3"></a>
# Upgrading a running helm2 BAF deployment to helm3
This guide enables an operator to upgrade an existing BAF helm2 deployment to helm3

- [Prerequisites](#prerequisites)
- [Deleting the existing flux deployment](#delete_flux)
- [Upgrade the helm deployments from Helm v2 to v3](#upgrade2to3)
- [Re-deployment of flux](#redeploy)

<a name = "prerequisites"></a>
## Prerequisites  
    a. A running BAF deployment based on helm v2
    b. Helm v2 binary in place and added to the path (accessible by the name `helm`)
    c. BAF repository with the latest code

<a name = "delete_flux"></a>
## Deleting the existing flux deployment
The flux deployment has changed for helm v3, and thus the older flux should be deleted.
Also, the older flux will interfere with the upgradation process, hence its removal or de-sync is necessary
To delete the existing flux deployment  

    helm del --purge flux-{{ network.env.type }}

<a name = "upgrade2to3"></a>
## Upgrade the helm deployments from Helm v2 to v3
Perform the following steps to upgrade the deployments

    # Download helm3 binary
    wget https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz
    
    # Extract the binary
    tar -xvf helm-v3.2.4-linux-amd64.tar.gz
    
    # Move helm binary to the current folder
    mv linux-amd64/helm helm3

    # Download the helm 2to3 plugin
    ./helm3 plugin install https://github.com/helm/helm-2to3

    # Convert all the releases to helm3 using
    helm ls | awk '{print $1}' | xargs -n1 helm3 2to3 convert --delete-v2-releases

    # To convert a single helm release
    ./helm3 2to3 convert RELEASE_NAME --delete-v2-releases

---
**NOTE**: After migration, you can view the helm3 releases using the command, 

    ./helm3 ls --all-namespaces
---

<a name = "redeploy"></a>
## Re-deployment of flux
With the lastest BAF repo clone and the network.yaml, you can redeploy flux using

    ansible-playbook platforms/shared/configuration/kubernetes-env-setup.yaml -e @<PATH_TO_NETWORK_YAML>
