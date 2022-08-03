[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## Hyperledger Bevel Indy
### Setup Hyperledger Indy Cluster on Local

Follow the steps to setup a Hyperledger Indy cluster( with 4 nodes) on your local machine.

Prerequisites: Docker should be present in your system. To install Docker:

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    apt-cache policy docker-ce
    sudo apt-get install -y docker-ce
    
To add user to docker group:

    sudo usermod -aG docker ${USER}
    su - ${USER}
    id -nG
    
    
##### Steps to run
1. Clone the Indy SDK
                    
        git clone https://github.com/hyperledger/indy-sdk.git
2. Go to ci folder. Create a docker image from the dockerfile available in that folder.

        docker build -f ci/indy-pool.dockerfile -t indy_pool .
    By running this command it will create a docker image with **four node indy cluster**, and expose the ports to outside.
3. Start docker image you freshly build using

        docker run -itd -p 9701-9708:9701-9708 indy_pool
4. Verify that the indy_pool container is running and get the indy_pool Docker container name with the following command. You'll need the Docker container name to stop and restart the Indy Docker container using the Docker command later. 

        docker ps -a
5. Log into the shell of the running Indy container by entering the following command:
        
        sudo docker exec -t <docker container id> /bin/bash
6. To install indy-sdk on the Ubuntu, perform the following commands in the ~/indy folder
    
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 68DB5E88
        sudo add-apt-repository "deb https://repo.sovrin.org/sdk/deb xenial stable"
        sudo apt-get update
        sudo apt-get install -y libindy
7. Then install the indy-cli, the command line tool for indy as below.

        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 68DB5E88
        sudo add-apt-repository "deb https://repo.sovrin.org/sdk/deb xenial stable"
        sudo apt-get update
        sudo apt-get install -y indy-cli
8. After setting up the CLI you can enter it by opening up a new terminal.
        
        indy-cli
9. Create a pool config, please save below configuration in a text file and name it “genesis-pool-config”. 
You can also use the file in “indy-sdk/cli/docker_pool_transactions_genesis” But to use it with the local port mapping from the docker container, you have to edit all the “client_ip” and “node_ip” and replace “10.0.0.2” with “127.0.0.1” (for the localhost)
Then use the file with the indy node configuration to create a pool in the CLI.

        pool create local-pool gen_txn_file=<path of the genesis file>
    
10. Connect the pool.

        pool connect local-pool