# Docker image for Aries Agents
Docker image contains prerequisites for Indy and also scripts for running Agents like "Faber" or "Alice" of demo. For more information follow [GitHub](https://github.com/hyperledger/aries-cloudagent-python).

The base image is used from Github. In our case we just update "faber.py", "alice.py", "acme.py" and "agent.py" scripts which override a base Docker image.

## Build a base image
We don't maintain of this Docker image so we need clone from GitHub repository.
1. Open new terminal/console.
2. Clone repository to this directory: `git clone https://github.com/hyperledger/aries-cloudagent-python.git`
3. Go to repository: `cd aries-cloudagent-python`
4. Build image: `docker build -t faber-alice-demo -f ./docker/Dockerfile.demo .`
5. (Optional) Tag docker image to own name: `docker tag faber-alice-demo <YOUR_NAME_WITH_VERSION>`
5. Push Docker image into Docker repository: `docker push <DOCKER_IMAGE_NAME>`

## Build a custom image
1. Come back to this directory: `cd examples/identity-app/images/agents/`
2. Build image from this directory: `docker build -t aries-agents .`
<br>(Must do the following step if running on cluster. Tag image according to docker and version section of network.yaml)
1. Tag docker image to own name: `docker tag aries-agents <YOUR_DOCKER_REPO>/aries-agents:<NETWORK_VERSION>` 
1. Push Docker image into Docker repository: `docker push <YOUR_DOCKER_REPO>/aries-agents:<NETWORK_VERSION>`
