[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Deploying a DLT network on Minikube using Bevel

## Pre-requisites

Before proceeding, first make sure that you've completed the [Developer Pre-requisites](./dev-prereq.md).

## Setup minikube on VM

You can also setup minikube on a Ubuntu VM.
1. Setup a Ubuntu 20.04 VM with atleast 16 GB RAM, 8 vcpu and having a public ip address, either on any cloud provider or local machine

!!! example "Get public IP"

    === "For VM"
        To set and get a public ip address of VM, check associated cloud provider documentation. For example: [for azure](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/configure-public-ip-vm)

    === "For own machine"

        Open https://ipv4.icanhazip.com/ on browser to get the public ip.

1. Install minikube using instruction [here](https://minikube.sigs.k8s.io/docs/start/) and start minikube.
    ```bash
    minikube start --memory 12000 --cpus 4 --kubernetes-version=1.23.1 --apiserver-ips=<specify public ip of VM>
    ```
1. Start a proxy which is required for ansible controller(to be created later in following steps) to access the minikube k8s
    ```bash
    docker run -d --network minikube -p 18443:18443 chevdor/nginx-minikube-proxy
    ```
## Clone forked repo

!!! important
    
    For Windows, ensure that you have set the following git config before cloning the repo.
    ```bash
    git config --global core.autocrlf false
    ```

1. If you have not already done so, fork [bevel](https://github.com/hyperledger/bevel) and clone the forked repo to your machine.
    ```bash
    git clone https://github.com/<your username>/bevel
    ```
1. Add a “local” branch to your machine
    ```bash
    cd bevel
    git checkout develop # to get latest code
    git pull
    git checkout -b local
    git push --set-upstream origin local
    ```

## Update kubeconfig file

1. Create a `build` folder inside your Bevel repository:
    ```bash
    mkdir build
    ```
1. Copy ca.crt, client.key, client.crt from `~/.minikube` to build:
    ```bash
    cp ~/.minikube/ca.crt build/
    cp ~/.minikube/profiles/minikube/client.key build/
    cp ~/.minikube/profiles/minikube/client.crt build/
    ```
1. Copy `~/.kube/config` file to build:
    ```bash
    cp ~/.kube/config build/
    ```
1. Open the above `config` file in build directory and update file path for certificate-authority, client-certificate and client-key  to point to the respective files copied in build directory.

    ![](./../_static/minikube-config.jpg)

    If using Ubuntu VM, update config `server` value to following:
    ```bash
    server: https://<specify public ip of VM>:8443
    ```
!!! important    
    If a VM is created on a cloud provider please ensure that required ports are open for traffic. 
   
!!! warning

    If you ever delete and recreate minikube, the above steps have to be repeated.

## Setup Hashicorp Vault

!!! tip

    If you haven't followed [Vault setup instructions](./dev-prereq.md#setting-up-hashicorp-vault) or want to deploy Vault on Kubernetes itself, please watch this video from 17:17 minutes from this [Bevel workshop series](https://youtu.be/eKMDgKshjQ8?list=PL0MZ85B_96CFJUzic2ZF9rposfx2hr2rm&t=1038)

1. Get your local IP Address for Vault. Follow [this guide](https://www.avast.com/c-how-to-find-ip-address) to get your machine's local IP Address.

1. In a new terminal, execute the following (assuming `vault` is in your `PATH`):
    ```bash
    export VAULT_ADDR='http://<Your Vault local IP address>:8200' #e.g. http://192.168.0.1:8200
    export VAULT_TOKEN="<Your Vault root token>"

    # enable Secrets v2
    vault secrets enable -version=2 -path=secretsv2 kv   
    ```
## Additional configurations

1. For Windows, execute following to correctly set docker environment.
    ```bash
    eval $('docker-machine.exe' env)
    ```
<a name = "windows_mount"></a>
1. For Windows, mount local folder (bevel folder) to VirtualBox docker VM ( the machine named “default” by default) from right-click menu, Settings -> Shared Folders. All paths in network.yaml should be the mounted path. Shut down and restart the "default" machine after this.
    ![](./../_static/virtualbox-mountfolder.png)
<a name = "mac_mount"></a>
1. For Mac, mount the local folder using minikube mount as we are using minikube as the docker runtime.
    ```
    eval $(minikube -p minikube docker-env)
    cd project/bevel
    minikube mount $(pwd):/mnt/bevel/ --gid=root --uid=root
    ```
    This terminal window should be kept open. If you close this terminal you have to minikube stop and start to overcome the error when re-mounting.

## Edit the network configuration file

1. Choose the DLT/Blockchain platform you want to run and copy the relevant sample network.yaml to build folder; rename it to network.yaml.

    ```bash
    # For example, for Fabric
    cd project/bevel
    cp platforms/hyperledger-fabric/configuration/samples/network-proxy-none.yaml build/network.yaml
    ```

1. Open the above `build/network.yaml` in your favourite editor and update the following.

1. Update Docker configurations:
    ```yaml
    docker:
        url: "ghcr.io/hyperledger"
        # Comment username and password as it is public repo
        #username: "<your docker username>"
        #password: "<your docker password/token>"
    ```
1. For each `organization`, update ONLY the following and leave everything else as is:
    ```yaml
    cloud_provider: minikube
    k8s:
        context: "minikube"
        config_file: "/home/bevel/build/config"
    vault:
        url: "http://<Your Vault local IP address>:8200" # Use the local IP address NOT localhost e.g. http://192.168.0.1:8200
        root_token: "<your vault_root_token>"
    gitops:
        git_protocol: "https" # Option for git over https or ssh
        git_url: "<https/ssh url of your forked repo>" #e.g. "https://github.com/hyperledger/bevel.git"
        git_repo: "<url of your forked repo without the https://>" #e.g. "github.com/hyperledger/bevel.git"
        username: "<github_username>"
        password: "<github token>"
        email: "<github_email>"
    ```
!!! note

    If you have 2-Factor Authentication enabled on your GitHub account, you have to use GitHub token. Otherwise, password is fine.

    ??? note "How To Generate GitHub Token"

        1. On GitHub page, click your profile icon and then click **Settings**.
        2. On the sidebar, click **Developer settings**.
        3. On the sidebar, click **Personal access tokens**.
        4. Click **Generate new token**.
        5. Add a token description, enable suitable access and click **Generate token**.
        6. Copy the token to a secure location or password management app.

        For security reasons, after you leave the page, you can no longer see the token again.
        
If you need help, you can use each platform's sample network-minikube.yaml:

- For Besu, use `platforms/hyperledger-besu/configuration/samples/network-proxy-none.yaml`
- For Fabric, use `platforms/hyperledger-fabric/configuration/samples/network-proxy-none.yaml`
- For Indy, use `platforms/hyperledger-indy/configuration/samples/network-minikube.yaml`
- For Quorum, use `platforms/quorum/configuration/samples/network-minikube.yaml`
- For Corda, use `platforms/r3-corda/configuration/samples/network-minikube.yaml`

And simply replace the placeholder values as explained above.

!!! note 

    Deploying the sample “supplychain” chaincode for Fabric is optional on minikube, so you can delete the “chaincode” section. If deploying chaincode, update the following for the peers.
        ```yaml
        chaincodes:
        - name: "supplychain"
          repository:
            username: "<github_username>"
            password: "<github_token>"
        ```

## Execute provisioning script

Make sure that Minikube and Vault server are running. Check by running:
```bash
minikube status
vault status
```

Now run the following commands to deploy your chosen DLT on minikube:

=== "Ubuntu VM"
    Login to the VM/Ansible Controller and run following commands
    ```bash
    cd bevel
    docker run -it -v $(pwd):/home/bevel/ --network="host" ghcr.io/hyperledger/bevel-build:latest /bin/bash

    # Ensure that git config is setup
    git config --global user.name "UserName"
    git config --global user.email "UserEmailAddress"

    cd bevel
    ./run.sh
    ```

=== "Mac"

    Mac users should use following (make sure that the local volume was mounted as per [this step](#mac_mount)):
    ```bash
    docker run -it -v /mnt/bevel:/home/bevel/ --network="host" ghcr.io/hyperledger/bevel-build:latest bash
    cd bevel
    ./run.sh
    ```

=== "Windows"

    Windows users should use following (make sure that the local volume was mounted as per [this step](#windows_mount)):

    ```bash
    docker run -it -v /bevel:/home/bevel/ --network="host" ghcr.io/hyperledger/bevel-build:latest bash
    cd bevel
    ./run.sh
    ```

!!! important

    If you need public address for nodes in your `network.yaml` file, you can use the output of `minikube ip`.

!!! note

    bevel-build image is using jdk14 but Corda and Corda Enterprise requires jdk8. In this case, you can use the prebuild image tag *jdk8*  ghcr.io/hyperledger/bevel-build:jdk8-latest

While the playbook is running, you can check if pods are being deployed from a different terminal

```bash
kubectl get pods --all-namespaces -w
```

!!! tip

    There will be errors in Ansible playbook, but if they are ignored, then that is expected behaviour.

## Troubleshooting

`Failed to establish a new connection: [Errno 111] Connection refused`

:   This is because you have re-created minikube but have not updated K8s `config` file. Repeat _"Update kubeconfig file"_ steps 3 - 4 and try again.

`kubernetes.config.config_exception.ConfigException: File does not exists: /Users/.minikube/ca.crt`

:   This is because you have not removed the absolute paths to the certificates in `config` file. Repeat _"Update kubeconfig file"_ step 4 and try again.

`error during connect: Get http://%2F%2F.%2Fpipe%2Fdocker_engine/v1.40/version: open //./pipe/docker_engine: The system cannot find the file specified. In the default daemon configuration on Windows, the docker client must be run elevated to connect. This error may also indicate that the docker daemon is not running`

:   This is because docker isn't running. To start it, just close all the instances of  Docker Quickstart Terminal and open again.

`ERROR! the playbook: /home/bevel/platforms/shared/configuration/site.yaml could not be found`

:   This is because the bevel repository isn't mounted to the default VM. Check [this step](#windows_mount).

`Ansible controller could not access kubernetes or vault`
   
:   Please make sure that VM has a public IP and required ports are open. One can verify vault status or accessing K8s using kubectl commands

## Clean up the installation

```bash
minikube delete --all
docker image rm -f chevdor/nginx-minikube-proxy
sudo apt remove vault
```