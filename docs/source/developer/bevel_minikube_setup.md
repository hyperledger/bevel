[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Running Bevel DLT network on Minikube

## Pre-requisites

Before proceeding, first make sure that you've completed [Developer Pre-requisites](./dev_prereq.md).

## Clone forked repo

1. If you have followed the pre-requisites, you should already have the [bevel](https://github.com/hyperledger/bevel) repo cloned; if not, follow the pre-requisite steps above.

1. Add a “local” branch to your machine
    ```bash
    cd ./project/bevel
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

1. Open the `config` file and remove the paths for `certificate-authority`, `client-certificate` and `client-key` as in the figure below.

   ![](./../_static/minikube-config.jpg)

   ***

   **NOTE**: If you ever delete and recreate minikube, the above steps have to be repeated.

   ***

1. Get your local IP Address for Vault. Follow [this guide](https://www.avast.com/c-how-to-find-ip-address) to get your machine's local IP Address.

1. In a new terminal, execute the following (assuming `vault` is in your `PATH`):
    ```bash
    export VAULT_ADDR='http://<Your Vault local IP address>:8200' #e.g. http://192.168.0.1:8200
    export VAULT_TOKEN="<Your Vault root token>"

    # enable Secrets v2
    vault secrets enable -version=2 -path=secretsv2 kv   
    ```

### Additional configurations

1. For Windows, ensure that you have set the following git config before cloning the repo.

    ```bash
    git config --global core.autocrlf false
    ```

    - If not, update the EOL to LF for platforms/hyperledger-fabric/scripts/\*.sh files.

1. For Windows, and if using Execute following to correctly set docker environment.
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
    cd ./project/bevel
    minikube mount $(pwd):/mnt/bevel/ --gid=root --uid=root
    ```
    This terminal window should be kept open. If you close this terminal you have to minikube stop and start to overcome the error when re-mounting.

## Edit the configuration file

1. Choose the DLT/Blockchain platform you want to run and copy the relevant sample network.yaml to build folder; rename it to network.yaml.

    ```bash
    cd ./project/bevel
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
      url: "http://<Your Vault local IP address>:8200" # Use the local IP address rather than localhost e.g. http://192.168.0.1:8200
      root_token: "<your vault_root_token>"
    gitops:
      git_protocol: "https" # Option for git over https or ssh
      git_url: "https://github.com/<username>/bevel.git"  #e.g. "https://github.com/hyperledger/bevel.git"
      git_repo: "github.com/<username>/bevel.git"       #e.g. "github.com/hyperledger/bevel.git"
      username: "<github_username>"
      password: "<git_access_token>"
      email: "<github_email>"
    ```

If you need help, you can use each platform's sample network-minikube.yaml:

- For Fabric, use `platforms/hyperledger-fabric/configuration/samples/network-proxy-none.yaml`
- For Besu, use `platforms/hyperledger-besu/configuration/samples/network-proxy-none.yaml`
- For Indy, use `platforms/hyperledger-indy/configuration/samples/network-minikube.yaml`
- For Quorum, use `platforms/quorum/configuration/samples/network-minikube.yaml`
- For Corda, use `platforms/r3-corda/configuration/samples/network-minikube.yaml`

And simply replace the placeholder values as explained above.

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

1. Deploying the sample “supplychain” chaincode for Fabric is optional, so you can delete the “chaincode” section. If deploying chaincode, update the following for the peers.
    ```yaml
    chaincodes:
    - name: "supplychain"
        repository:
          username: "<github_username>"
          password: "<github_token>"
    ```

## Execute

Make sure that Minikube and Vault server are running. Double-check by running:

```bash
minikube status
vault status
```

Now run the following to deploy your chosen DLT on minikube:


Mac users should use following (make sure that the local volume was mounted as per [this step](#mac_mount)):
```bash
docker run -it -v /mnt/bevel:/home/bevel/ --network="host" ghcr.io/hyperledger/bevel-build:latest
```

Windows users should use following (make sure that the local volume was mounted as per [this step](#windows_mount)):

```bash
docker run -it -v /bevel:/home/bevel/ --network="host" ghcr.io/hyperledger/bevel-build:latest
```

Meanwhile you can also check if pods are being deployed:

```bash
kubectl get pods --all-namespaces -w
```

---

**NOTE:** If you need public address for nodes in your `network.yaml` file, you can use the output of `minikube ip`.

**NOTE**. baf-build image is using jdk14 but Corda and Corda Enterprise requires jdk8. In this case, you can use the prebuild image tag *jdk8*  ghcr.io/hyperledger/bevel-build:jdk8-latest

## Troubleshooting

**`Failed to establish a new connection: [Errno 111] Connection refused`**

This is because you have re-created minikube but have not updated K8s `config` file. Repeat _"Update kubeconfig file"_ steps 3 - 4 and try again.

**`kubernetes.config.config_exception.ConfigException: File does not exists: /Users/.minikube/ca.crt`**

This is because you have not removed the absolute paths to the certificates in `config` file. Repeat _"Update kubeconfig file"_ step 4 and try again.

**`error during connect: Get http://%2F%2F.%2Fpipe%2Fdocker_engine/v1.40/version: open //./pipe/docker_engine: The system cannot find the file specified. In the default daemon configuration on Windows, the docker client must be run elevated to connect. This error may also indicate that the docker daemon is not running`**

This is because docker isn't running. To start it, just close all the instances of  Docker Quickstart Terminal and open again.

**`ERROR! the playbook: /home/bevel/platforms/shared/configuration/site.yaml could not be found`**

This is because the bevel repository isn't mounted to the default VM. Check [this step](#windows_mount).
