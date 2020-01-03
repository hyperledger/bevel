# Setting up a test environment on Mac OSX:

## Install Kubectl using Homebrew: 

Use a package manager of your choice to install kubectl. In this guide, Homebrew was used. Installation guide for Homebrew could be found [here](https://brew.sh).

Install kubectl with homebrew:<br/>  `brew install kubectl` <br/><br/>

## Install Minikube using Homebrew:

Using Homebrew package manager, enter the following command: <br/>  `brew install minikube`

Add minikube executable to your path:  `sudo mv minikube /usr/local/bin`

Let’s confirm the minikube was installed correctly by starting your first cluster:<br/> `minikube start`

And now we will check the status: `minikube status`. You should see an output that looks similar to this:

host: Running<br/>
kubelet: Running<br/>
apiserver: Running<br/>
kubeconfig: Configured<br/><br/>

## Install Hashicorp Vault:

Install go language if you do not have it installed. Installation guide for go could be found [here](https://golang.org).


Make sure you have **GOPATH** environment variable in your PATH. One way to do this is to edit ~/.bash_profile and add the following:<br/>
```
export GOPATH=/Users/$USER/go<br/>
export PATH=$GOPATH/bin:$PATH
```


Once you set the GOPATH environment variable, follow the installation guide for [Hashicorp Vault](https://www.vaultproject.io/docs/install/#precompiled-binaries).<br/><br/>

## Install Ansible using pip:

The recommend method for installing Ansible is to use pip, see    [Ansible instruction](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-via-pip).

When you use pip to install Ansible, pip will not include the configuration file, ansible.cfg . Therefore, you will need to create a folder in the /etc directory:

`mkdir /etc/ansible`

Add a file called hosts and copy the contents from this [page](https://github.com/hyperledger-labs/blockchain-automation-framework/blob/master/platforms/shared/inventory/ansible_provisoners). 



You do not need to install ambassador in a Dev environment. 


# Editing the network-fabricv2.yaml

Add the following to the top of the network-fabricv2.yaml file:

```
install_os: "darwin"                #Default to linux OS
install_arch:  "amd64"              #Default to amd64 architecture
bin_install_dir:  "/usr/local/bin"      #Default to /bin install directory for 
```
Use ```uname -a ```to verify that darwin is the architecture code for your operating system. If it's not, then change the install_os. <br/><br/>


**cloud_provider** : change from aws to minikube

**k8s** : comment out provider and region. change context to "minikube" and config_file to the path of the config file. You should be able to find the config file in the .kube directory. Should look similar to this:
```
k8s:
     #  provider: "EKS"
     #  region: "cluster_region"
        context: "minikube"
        config_file: "/Users/username/.kube/config" 
```

 ## Potential issues when using Ansible playbook to setup DLT Network on OSX


* If you get an error message "_the required library is installed, but Ansible is using the wrong Python interpreter"_, you will need to specify which interpreter to use when running the ansible-playbook

   ` -e "ansible_python_interpreter=/Library/Frameworks/Python.framework/Versions/3.8/bin/python3" `
<br/><br/>

* If ansible is stuck on a task where it checks to see if Tiller is  installed in the Kubernetes clusters and you get a message similar to this: 
_"MODULE FAILURE\nSee stdout/stderr for the exact error"_, It is probably because the kubernetes version is 16 or higher. You will need to delete the kubernetes cluster and create a another cluster with v1.15.4. 
<br/><br/>

* 
   It is recommended that you use virtual box as the vm driver when deploying the DLT network. If you use hyperkit as the vm driver, your k8 cluster will not have access to the internet. 

   `minikube start --vm-driver=virtualbox --kubernetes-version v1.15.4`
