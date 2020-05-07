# Docker image for Indy Web Server
Docker image contains prerequisites for Indy and also scripts for running Indy Web Server. The Web Server is needed to run Identity demo. For more information follow [GitHub](https://github.com/bcgov/von-network).

For our case, we use just Web Server of this Docker image.

## Build
We don't maintain of this Docker image so we need clone from GitHub repository.
1. Open terminal/console
2. Clone repository to this directory: `git clone https://github.com/bcgov/von-network.git`
3. Go to repository: `cd von-network`
4. Build image (using script in this directory): `./manage build`
5. (Optional) Tag docker image to own name: `docker tag von-network-base <YOUR_NAME_WITH_VERSION>`
5. Push Docker image into Docker repository: `docker push <DOCKER_IMAGE_NAME>`