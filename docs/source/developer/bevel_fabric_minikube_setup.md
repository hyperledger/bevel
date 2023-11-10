[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Running Bevel DLT hyperledger fabric network on minikube

## Pre-requisites

Before proceeding, first make sure that you've completed [developer pre-requisites](./dev_prereq.md).

## Setup minikube

1. Setup a Ubuntu 20.04 VM with atleast 16 GB RAM, 8 vcpu and having a public ip address, either on any cloud provider or local machine

   1.1 How to set and get a public ip address of VM, one needs to check associated cloud provider documentation. For example: [azure](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/configure-public-ip-vm)

   OR

   1.2 Use local machine of similar configuration and get the instance public ip

2. Install minikube using instruction [here](https://minikube.sigs.k8s.io/docs/start/) and start minikube.
   ```bash
   minikube start --memory 12000 --cpus 4 --kubernetes-version=1.19.1 --apiserver-ips=<specify public ip of VM>
   ```
3. Start a proxy which is required for ansible controller(to be created later in following steps) to access the minikube k8s
   ```bash
   docker run -d --network minikube -p 18443:18443 chevdor/nginx-minikube-proxy
   ```
## Clone forked repo

1. If you have not already done so, fork [bevel](https://github.com/hyperledger/bevel) and clone the forked repo to your machine.
   ```bash
   git clone git@github.com:<githubuser>/bevel.git
   ```

## Update kubeconfig file

1. Create a `build` folder inside your Bevel repository:
   ```bash
   cd ~/bevel
   mkdir build
   ```
2. Copy ca.crt, client.key, client.crt from `~/.minikube` to build:
   ```bash
   cp ~/.minikube/ca.crt build/
   cp ~/.minikube/profiles/minikube/client.key build/
   cp ~/.minikube/profiles/minikube/client.crt build/
   ```
3. Copy `~/.kube/config` file to build:
   ```bash
   cp ~/.kube/config build/
   ```
4. Open the above config file in build directory and update file path for certificate-authority, client-certificate and client-key  to point to the respective files copied in build directory.

   ![](./../_static/minikube-config.jpg)

   Update config `server` value to following:
   ```bash
   server: https://<specify public ip of VM>:18443
   ```
If a VM is created on any cloud provider please ensure that required ports are open for traffic. 
   ***
   **NOTE**: If you ever delete and recreate minikube, the above steps have to be repeated.
   ***

## Setup Hashicorp vault
   There are two options to setup vault:
   1. Install the vault using Hashicorp Vault [official documenation](https://developer.hashicorp.com/vault/docs/install)

   OR

   2. Install vault using helm charts, please watch this video from 17:17 minutes from this Bevel workshop series [here](
   https://www.youtube.com/watch?v=eKMDgKshjQ8&list=PL0MZ85B_96CFJUzic2ZF9rposfx2hr2rm&index=2)

## Edit the network configuration file

1. Copy the sample network yaml file to create the fabric network
   ```bash
   cd ~/bevel
   cp /platforms/hyperledger-fabric/configuration/samples/network-proxy-none.yaml build/network.yaml
   ```

2. Update Docker configurations:
   ```yaml
   docker:
     url: "ghcr.io/hyperledger"
     # Comment username and password as it is public repo
     #username: "<your docker username>"
     #password: "<your docker password/token>"
   ```
3. For each `organization`, update ONLY the following and leave everything else as is:
   ```yaml
   vault:
     url: "http://<Your Vault local IP address>:8200" #This could be either public VM address or load balancer when using helm charts
     root_token: "<your vault_root_token>"
   gitops:
     git_url: "<https/ssh url of your forked repo>" #e.g. "https://github.com/hyperledger/bevel.git"
     git_repo: "<https url of your forked repo without the https://>" #e.g. "github.com/hyperledger/bevel.git"
     username: "<github_username>"
     password: "<github token/password>"
     email: "<github_email>"
   ```
---

**NOTE:** If you have 2-Factor Authentication enabled on your GitHub account, you have to use GitHub token. Otherwise, password is fine.

<details>
  <summary>How To Generate GitHub Token</summary>

   1. On GitHub page, click your profile icon and then click **Settings**.
   2. On the sidebar, click **Developer settings**.
   3. On the sidebar, click **Personal access tokens**.
   4. Click **Generate new token**.
   5. Add a token description, enable suitable access and click **Generate token**.
   6. Copy the token to a secure location or password management app.

For security reasons, after you leave the page, you can no longer see the token again.
</details>

---

4. Deploying the sample “supplychain” chaincode is optional, so you can delete the “chaincode” section. If deploying chaincode, update the following for the peers.
   ```yaml
   chaincode:
     repository:
       username: "<github_username>"
       password: "<github_token>"
   ```

## Now run the following to deploy Fabric network on minikube:

Make sure that minikube and Vault server are running. Double-check by running:
   ```bash
   minikube status
   vault status
   ```

1. Create an ansible controller
   ```bash
   cd bevel
   docker build . -t bevel-build
   ```
2. Login an ansible controller
   ```bash
   docker run -it -v $(pwd):/home/bevel/ bevel-build /bin/bash
   ```
3. Ensure that git config is setup
   ```bash
   git config --global user.name "UserName"
   git config --global user.email "UserEmailAddress"
   ```
4. Execute the scripts to setup Hyperledger fabric network
   ```bash
   cd bevel
   ./run.sh
   ```

## Troubleshooting

**`Ansible controller could not access kubernetes or vault`**
   Please make sure that VM has a public IP and required ports are open. One can verify vault status or accessing K8s using kubectl commands

**`Clean up the installation`**
   ```bash
   minikube delete --all
   docker image rm -f chevdor/nginx-minikube-proxy
   sudo apt remove vault
   ```