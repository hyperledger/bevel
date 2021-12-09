#!/bin/bash

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

# Vault
echo "Starting Vault..."
read -p "Vault version (default is 1.3.4): " VAULT_VERSION
read -p "Vault port (default is 8200)": VAULT_PORT
if [[ -z ${VAULT_VERSION} ]]; then
    VAULT_VERSION="1.3.4"
fi
if [[ -z ${VAULT_PORT} ]]; then
    VAULT_PORT="8200"
fi

vault --version > /dev/null 2>&1
if [[ $? == 0 ]]; then
    vault_version=$(vault --version | grep ${VAULT_VERSION})
fi

if [[ $? != 0 || -z ${vault_version} ]]; then
    echo "Starting Vault to download..."
    curl https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o ./vault.zip
    ls -la | grep "vault.zip" > /dev/null 2>&1
    check "Vault downloading"
    echo "Starting Vault to install..."
    unzip vault.zip
    ls -la | grep -v "vault.zip" | grep "vault" > /dev/null 2>&1
    check "Vault unzipping"
    chmod +x vault
    mv vault /usr/local/bin/vault
    vault --version > /dev/null 2>&1
    check_install "Vault"
    rm -r vault.zip
else
    echo "Vault already installed."
fi

vault_config='{"backend": {"file": {"path": "'$HOME'/vault/data"}},"listener":{"tcp":{"address":"0.0.0.0:'${VAULT_PORT}'","tls_disable":1}},"ui":true}'
rm -rf $HOME/vault
mkdir -p $HOME/vault
echo ${vault_config} >> $HOME/vault/config.json
vault server -config $HOME/vault/config.json &> /dev/null &
echo "Vault is running under PID: $!"

sleep 2
export VAULT_ADDR=http://localhost:${VAULT_PORT}
initialized=$(vault status | grep "Initialized" | awk '{print $2}')
sealed=$(vault status | grep "Sealed" | awk '{print $2}')

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
    echo "Provide the unseal key first and then the root token to login."
    echo "####################################################################################"
fi
read -p "Press any key to continue..."