Developer Prerequisites
=======================

The following mandatory pre-requisites must be completed to set up a development environment for BAF.

**The estimated total effort is 55 mins.**

---
**NOTE:** You will need at least 8GB RAM to run BAF on local machine.

---

## Setting up Git on your machine
*Estimated Time: 10 minutes*

To use Git, you need to install the software on your local machine.
1. Download and install **git bash** from [http://git-scm.com/downloads](http://git-scm.com/downloads).
1. Open 'git bash' (For Windows, Start > Run, `C:\Program Files (x86)\Git\bin\sh.exe --login -i` )
1. After the install has completed you can test whether Git has installed correctly by running the command `git --version`
1. If this works successfully you will need to configure your Git instance by specifying your username and email address. This is done with the following two commands (Use your GitHub username and email address, if you already have a Github Account):
   ```bash
   git config --global user.name "<username>"
   git config --global user.email "<useremail>"
   ```
1. To verify that the username and password was entered correctly, check by running
   ```bash
   git config user.name
   git config user.email
   ```
   
## Setting up Github
*Estimated Time: 5 minutes*

[GitHub](https://github.com/) is a web-based Git repository hosting service. It offers all of the distributed revision control and source code management (SCM) functionality of Git as well as adding its own features. You can create projects and repositories for you and your teams’ need.

Complete the following steps to download and configure BAF repository on your local machine.
1. If you already have an account from previously, you can use the same account. If you don't have an account, create one.
1. Go to [blockchain-automation-framework](https://github.com/hyperledger-labs/blockchain-automation-framework) on GitHub and click **Fork** button on top right. This will create a copy of the repo to your own GitHub account.
1. In git bash, write and execute the command: 

   ```bash
   ssh-keygen -q -N "" -f ~/.ssh/gitops
   ```    
   This generates an SSH key-pair in your user/.ssh directory: gitops (private key) and gitops.pub (public key).
1. Add the public key contents from gitops.pub (starts with ssh-rsa) as an Access Key (with read-write permissions) in your Github repository by following [this guide](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account).
1. Execute the following command to add the key to your ssh-agent
   ```bash
   eval "$(ssh-agent)"
   ssh-add ~/.ssh/gitops
   ```
1. Create a `project` directory and clone the forked repostory to your local machine.
   ```bash
   mkdir project
   cd project
   git clone git@github.com:<githubuser>/blockchain-automation-framework.git
   ```
1. Checkout the develop branch. 
   ```bash
   cd blockchain-automation-framwork
   git checkout develop
   ```

## Setting up Docker
*Estimated Time: 10 minutes*

Install [Docker Engine](https://docs.docker.com/install/) to make sure your local environment has the capbility to execute `docker` commands.
You can check the version of Docker you have installed with the following
command from a terminal prompt:
```bash
docker --version
```

## Setting up HashiCorp Vault
*Estimated Time: 15 minutes*

We need [Hashicorp Vault](https://www.vaultproject.io/) for the certificate and key storage.
1. To install the precompiled binary, [download](https://www.vaultproject.io/downloads/) the appropriate package for your system. 
1. Once the zip is downloaded, unzip it into any directory. The `vault` binary inside is all that is necessary to run Vault (or `vault.exe` for Windows). Any additional files, if any, aren't required to run Vault.

1. Create a directory `project/bin` and copy the binary there. Add `project/bin` directory to your `PATH`.
1. Create a `config.hcl` file in the `project` directory with the following contents (use a file path in the `path` attribute which exists on your local machine)
   ```
   storage "file" {
      path    = "/project/vault"
   }
   ui = true
   listener "tcp" {
      address     = "0.0.0.0:8200"
      tls_disable = 1
   }
   ```
1. Start the Vault server by executing (this will occupy one terminal). Do not close this terminal.
   ```
   vault server -config=config.hcl
   ```
1. Open browser at [http://localhost:8200/](http://localhost:8200/). And initialize the Vault by providing your choice of key shares and threshold. (below example uses 1)
![](./../_static/vault-init.png)
1. Click **Download Keys** or copy the keys, you will need them. Then click **Continue to Unseal**. Provide the unseal key first and then the root token to login.
1. In a new terminal, execute the following (assuming `vault` is in your `PATH`)
   ```bash
   export VAULT_ADDR='http://127.0.0.1:8200'
   export VAULT_TOKEN="s.XmpNPoi9sRhYtdKHaQhkHP6x"
   vault secrets enable -version=1 -path=secret kv
   ```

## Setting up Minikube
*Estimated Time: 15 minutes*

For development environment, minikube can be used as the Kubernetes cluster on which the DLT network will be deployed.

1. Follow platform specific [instructions](https://kubernetes.io/docs/tasks/tools/install-minikube/) to install minikube on your local machine. Also install [Virtualbox](https://www.virtualbox.org/wiki/Downloads) as the Hypervisor.
1. minikube is also a binary, so move it into your `project/bin` directory as it is already added to `PATH`.
1. Configure minikube to use 4GB memory and default kubernetes version
   ```bash
   minikube config set memory 4096
   minikube config set kubernetes-version v1.15.4
   ```
1. Then start minikube. This will take longer the first time.
   ```bash
   minikube start --vm-driver=virtualbox
   ```
1. Check status of minikube by running
   ```bash
   minikube status
   ```
   The Kubernetes config file is generated at `~/.kube/config`
1. To use the minikube's docker environment (so that you do not have to run another VM for docker), execute
   ```bash
   eval $(minikube docker-env)
   ```
1. To stop (do not delete) minikube execute the following
   ```bash
   minikube stop
   ```
Now your development environment is ready!
