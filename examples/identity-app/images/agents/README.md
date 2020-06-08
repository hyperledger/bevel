# Docker image for Aries Agents
Docker image contains prerequisites for Indy and also scripts for running Agents like "Faber" or "Alice" of demo. For more information follow [GitHub](https://github.com/hyperledger/aries-cloudagent-python).

The base image is used from Github. In our case we just update "faber.py", "alice.py" and "agent.py" scripts which override a base Docker image.

## Build a base image
We don't maintain of this Docker image so we need clone from GitHub repository.
1. Open terminal/console
2. Clone repository to this directory: `git clone https://github.com/hyperledger/aries-cloudagent-python.git`
3. Go to repository: `cd aries-cloudagent-python`
4. Build image: `docker build -t faber-alice-demo -f ./docker/Dockerfile.demo .`
5. (Optional) Tag docker image to own name: `docker tag faber-alice-demo <YOUR_NAME_WITH_VERSION>`
5. Push Docker image into Docker repository: `docker push <DOCKER_IMAGE_NAME>`

## Build a custom image
1. Build image from this directory: `docker build -t aries-agents .`
2. (Optional) Tag docker image to own name: `docker tag aries-agents <YOUR_NAME_WITH_VERSION>`
3. Push Docker image into Docker repository: `docker push <DOCKER_IMAGE_NAME>`
