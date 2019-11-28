#!/usr/bin/env bash

source /usr/local/bin/virtualenvwrapper.sh
workon ${NETWORK_NAME}

if [ -z "$3" ]
then
    generate_identity --identity_name $1 --vault_path $2
else
    generate_identity --identity_name $1 --vault_path $2 --target $3 --vault_address $4
fi