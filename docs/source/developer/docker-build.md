# Blockchain Automation Framework deployment using docker build

## Build the docker image for BAF deployment enviorment

Build the docker image using the docker file  `Dockerfile` provided in the blockchain-automation-framework repository.

The docker image should be built from the root directory of the repository, the image copies the entire repository and adds them to the filesystem working directory of the container.

Following is a code snippet of the docker image showing `WORKDIR` and `VOLUME`

``` shell
WORKDIR /home/build
```
The VOLUME instruction creates a mount point with the specified name and marks it as holding externally mounted volumes from native host

``` shell
VOLUME /home/build/config/
```

Use the below command to build the image
```
docker build . -t baf-build
```

This would create an image name baf-build



## Running the provisioning scripts

A shell script `run.sh` is provided in repository to set enviorment varaibles and run the network deployement playbook.

The `dockerfile` also provides defaults for the executing container using the `CMD` variable

``` shell
CMD ["/home/build/blockchain-automation-framework/run.sh"]
```
Use the below command to run the container and the provisioning scripts. The command also binds and mounts a volume 

```shell
docker run -v $(pwd)/config/:/home/build/config/ baf-build
```
Syntax for bind-mount volume from docker offical documentation 

``` shell
-v, --volume=[host-src:]container-dest[:<options>]: Bind mount a volume.
```
The `[host-src]` is this case is `$(pwd)/config/`, the volume should contain the following files  

1) K8s config file as config  
2) Network specific configuration file as network.yaml  
3) Private key file which has write-access to the git repo  

The paths in network configuration file should be changed accordingly.

