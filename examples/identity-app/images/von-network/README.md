# Docker image for Indy Web Server
Docker image contains prerequisites for Indy and also scripts for running Indy Web Server. The Web Server is needed to run Identity demo. For more information check [GitHub](https://github.com/bcgov/von-network).

For our case, we use just Web Server of this Docker image.

## Build
We don't maintain of this Docker image so we need clone from GitHub repository.
1. Open new terminal/console.
2. Clone repository to this directory: `git clone https://github.com/bcgov/von-network.git`
3. Go to repository: `cd von-network`
4. Build image (using script in this directory): `./manage build`
<br>(Must do the following step if running on cluster. Tag image according to docker and version section of network.yaml)
5. Tag docker image to own Docker repository: `docker tag von-network-base <YOUR_DOCKER_REPO>/von-network-base:<NETWORK_VERSION>`
6. Push Docker image into your Docker repository: `docker push <YOUR_DOCKER_REPO>/von-network-base:<NETWORK_VERSION>`
