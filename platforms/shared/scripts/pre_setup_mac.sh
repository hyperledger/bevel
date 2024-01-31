#!/bin/bash

echo "		 ____          ______ 		"
echo "		|  _ \   /\   |  ____|		"
echo "		| |_) | /  \  | |__   		"
echo "		|  _ < / /\ \ |  __|  		"
echo "		| |_) / ____ \| |     		"
echo "		|____/_/    \_\_|     		"

function check_install() {
    if [[ $? == 0 ]]; then
        echo "$1 successfully installed."
    else
        >&2 echo "$1 is not installed."
        exit
    fi
}

function check() {
    if [[ $? == 0 ]]; then
        echo "$1 successfully done."
    else
        >&2 echo "$1 failed."
        exit
    fi

}

# Git
git --version > /dev/null 2>&1
if [[ $? != 0 ]]; then
    echo "Git is missing in system."
    read -p "Please install Git into machine. Press any key to exit..."
    exit
else
    echo "Git already installed."
fi

read -p "Please create a github account and press any key to continue..."
read -p "Username: " GIT_USERNAME
read -p "Email: " GIT_EMAIL

username=$(git config --global user.name)
if [[ -z ${username} || ${username} != ${GIT_USERNAME} ]]; then
    git config --global user.name "${GIT_USERNAME}"
    echo "Git username successfully updated [$(git config --global user.name)]."
fi

useremail=$(git config --global user.email)
if [[ -z ${useremail} || ${useremail} != ${GIT_EMAIL} ]]; then
    git config --global user.email "${GIT_EMAIL}"
    echo "Git user email successfully updated [$(git config --global user.email)]"
fi

ls ./project/bevel > /dev/null 2>&1
if [[ $? != 0 ]]; then
	read -p "Please fork the bevel repository from browser and press any key to continue..."
	read -p "Repository URL (https url): " REPO_URL
	read -p "Branch (default is local): " REPO_BRANCH

	echo "Starting repository to clone..."
	mkdir -p project
	cd project
	git clone ${REPO_URL}
	check "Cloning repository"

	cd bevel
	if [[ -z ${REPO_BRANCH} ]]; then
    		REPO_BRANCH="local"
	fi
	git checkout ${REPO_BRANCH} > /dev/null 2>&1
	if [[ $? != 0 ]]; then
    		git checkout -b develop
    		git checkout -b ${REPO_BRANCH} develop
    		git checkout ${REPO_BRANCH}
    		git push -u origin ${REPO_BRANCH}
	fi
	echo "Branch changed to ${REPO_BRANCH}"
	cd ../..
else
	echo "Bevel code already checked out"
fi

# Docker
docker --version > /dev/null 2>&1
if [[ $? != 0 ]]; then
    echo "Starting Docker to download..."
    # For change version of Docker, please visit https://docs.docker.com/docker-for-mac/release-notes/
    # and copy link of 'Download' version which you want.
    curl https://download.docker.com/mac/stable/37199/Docker.dmg -o ./Docker.dmg
    ls -la | grep "Docker.dmg"  > /dev/null 2>&1
    check "Docker downloading"
    echo "Starting Docker to install..."
    sudo hdiutil attach ./Docker.dmg > /dev/null 2>&1
    ls -a /Volumes/Docker > /dev/null 2>&1
    check "Docker installer mounting" > /dev/null
    sudo cp -rf /Volumes/Docker/Docker.app /Applications
    sudo hdiutil detach /Volumes/Docker > /dev/null 2>&1
    check "Docker installer unmounting" > /dev/null
    open --background -a Docker
    while ! docker system info > /dev/null 2>&1
    do
        echo "Waiting for Docker to start..."
        sleep 20
    done
    check_install "Docker"
    rm ./Docker.dmg
else
    echo "Docker already installed."
fi

# Vault
echo "Starting Vault..."
read -p "Vault version (default is 1.13.1): " VAULT_VERSION
read -p "Vault port (default is 8200)": VAULT_PORT
if [[ -z ${VAULT_VERSION} ]]; then
    VAULT_VERSION="1.13.1"
fi
if [[ -z ${VAULT_PORT} ]]; then
    VAULT_PORT="8200"
fi

./project/bin/vault --version > /dev/null 2>&1
if [[ $? == 0 ]]; then
    vault_version=$(./project/bin/vault --version | grep ${VAULT_VERSION})
fi
if [[ $? != 0 || -z ${vault_version} ]]; then
    echo "Starting Vault to download..."
    curl https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_darwin_amd64.zip -o ./vault.zip
    ls -la | grep "vault.zip" > /dev/null 2>&1
    check "Vault downloading"
    echo "Starting Vault to install..."
    unzip vault.zip
    ls -la | grep -v "vault.zip" | grep "vault" > /dev/null 2>&1
    check "Vault unzipping"
    chmod +x vault
    mkdir -p ./project/bin/
    mv vault ./project/bin/vault
    ./project/bin/vault --version > /dev/null 2>&1
    check_install "Vault"
    rm -r vault.zip
else
    echo "Vault already installed."
fi

vault_config='{"backend": {"file": {"path": "'$(pwd)'/project/vault/data"}},"listener":{"tcp":{"address":"0.0.0.0:'${VAULT_PORT}'","tls_disable":1}},"ui":true}'
rm -rf $(pwd)/project/vault/config.json
mkdir -p $(pwd)/project/vault/
echo ${vault_config} >> $(pwd)/project/vault/config.json
./project/bin/vault server -config $(pwd)/project/vault/config.json &> /dev/null &
echo "Vault is running under PID: $!"

sleep 2
export VAULT_ADDR=http://localhost:${VAULT_PORT}

initialized=$(./project/bin/vault status | grep "Initialized" | awk '{print $2}')
sealed=$(./project/bin/vault status | grep "Sealed" | awk '{print $2}')

read -p "Press any key to continue..."
if [[ ${initialized} =~ "false" && ${sealed} =~ "true" ]]; then
    echo "###################################### VAULT #######################################"
    echo "Open browser at http://localhost:${VAULT_PORT}, provide 1 and 1 in both fields and initialize"
    echo "Click Download keys or copy the keys. Then click Continue to unseal."
    echo "Provide the unseal key first and then the root token to login."
    echo "####################################################################################"
elif [[ ${initialized} =~ "true" && ${sealed} =~ "true" ]]; then
    echo "###################################### VAULT #######################################"
    echo "Open browser at http://localhost:${VAULT_PORT}."
    echo "Provide the unseal key you saved previously first and then the root token to login."
    echo "####################################################################################"
fi
read -p "Press any key to continue..."

## Hyperkit and Minikube
hyperkit -v > /dev/null 2>&1
if [[ $? != 0 ]]; then
    echo "Starting Hyperkit installation using brew"
    brew install hyperkit

    hyperkit -v > /dev/null 2>&1
    check_install "hyperkit"
else
    echo "hyperkit already installed."
fi

minikube version  > /dev/null 2>&1
if [[ $? != 0 ]]; then
    echo "Starting Minikube to download..."
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
    chmod +x minikube
    ls -la | grep "minikube"  > /dev/null 2>&1
    check "Minikube downloading"
    sudo mv minikube /usr/local/bin
    minikube version  > /dev/null 2>&1
    check_install "Minikube"
else
    echo "Minikube already installed."
fi

read -p "Enter ram to be used by minikube(MB): " RAMSIZE
read -p "Enter cpu cores to be used by minikube: " CPUCOUNT
minikube config set memory ${RAMSIZE}
minikube config set cpus ${CPUCOUNT}
minikube config set kubernetes-version v1.23.1
minikube start --vm-driver=hyperkit
minikube status

echo "		 ____          ______ 		"
echo "		|  _ \   /\   |  ____|		"
echo "		| |_) | /  \  | |__   		"
echo "		|  _ < / /\ \ |  __|  		"
echo "		| |_) / ____ \| |     		"
echo "		|____/_/    \_\_|     		"

echo "Starting tunel to Minikube for access Kubernetes to Vault..."
ssh -i $(minikube ssh-key) -oStrictHostKeyChecking=no -N docker@$(minikube ip) -R ${VAULT_PORT}:localhost:${VAULT_PORT} &
echo "Tunnel is running in background. To stop the tunnel, run this: kill $!"
echo "For opening a new tunnel, run this: ssh -i \$(minikube ssh-key) -N docker@\$(minikube ip) -R ${VAULT_PORT}:localhost:${VAULT_PORT}"
