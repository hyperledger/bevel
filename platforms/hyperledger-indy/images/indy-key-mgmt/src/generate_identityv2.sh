#!/usr/bin/env bash

source /usr/local/bin/virtualenvwrapper.sh
workon ${NETWORK_NAME}

if [ -z "$3" ]
then
    generate_identityv2 --identity_name $1 --vault_path $2
else
    generate_identityv2 --identity_name $1 --vault_path $2 --target $3 --vault_address $4 --version $5
fi