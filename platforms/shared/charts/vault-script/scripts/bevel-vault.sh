##############################################################################################
#  Copyright Accenture. All Rights Reserved.
#
#  SPDX-License-Identifier: Apache-2.0
##############################################################################################
#!/bin/bash

##############################################################################################################################
################################################## Utility functions starts ##################################################
##############################################################################################################################

# This function validates hashicorp vault responses 
function validateVaultResponseHashicorp {
    if echo ${2} | grep "errors" || [[ "${2}" = "" ]]; then
        echo "ERROR: unable to retrieve ${1}: ${2}"
        exit 1
    fi
    if  [[ "$3" = "LOOKUPSECRETRESPONSE" ]]
    then
        http_code=$(curl -fsS -o /dev/null -w "%{http_code}" \
        --header "X-Vault-Token: ${VAULT_TOKEN}" \
        ${VAULT_ADDR}/v1/${1})
        curl_response=$?
        if test "$http_code" != "200" ; then
            echo "Http response code from Vault - $http_code and curl_response - $curl_response"
            if test "$curl_response" != "0"; then
                echo "Error: curl command failed with error code - $curl_response"
                exit 1
            fi
        fi
    fi
}

##############################################################################################################################
################################################## Hashicorp vault functions Starts ##########################################
##############################################################################################################################

function initHashicorpVaultToken {
    KUBE_SA_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
    VAULT_TOKEN=$(curl -sS --request POST ${VAULT_ADDR}/v1/auth/${KUBERNETES_AUTH_PATH}/login -H "Content-Type: application/json" -d \
                '{"role":"'"${VAULT_APP_ROLE}"'","jwt":"'"${KUBE_SA_TOKEN}"'"}' | jq -r 'if .errors then . else .auth.client_token end')
}

#Arg1: Vault token; Arg2: Secret Path
function readHashicorpVaultSecret {
    # Hashicorp v2 secret data path format
    #secret_path=$VAULT_SECRET_PATH/data/$1
    # Curl to the vault server
    VAULT_SECRET=$(curl --header "X-Vault-Token: ${VAULT_TOKEN}" ${VAULT_ADDR}/v1/${1} | jq -r 'if .errors then "null" else .data end')
}

function writeHashicorpVaultSecret {
    #secret_path=$VAULT_SECRET_PATH/data/$1
    VAULT_RESPONSE=$(curl \
                  -H "X-Vault-Token: ${VAULT_TOKEN}" \
                  -H "Content-Type: application/json" \
                  -X POST \
                  -d @${2} \
                  ${VAULT_ADDR}/v1/${1})
}

##############################################################################################################################
################################################## Vault main handler function ###############################################
##############################################################################################################################

vaultBevelFunc() {
    if [[ $VAULT_TYPE = "hashicorp" ]]; then
        if [[ $1 = "init" ]] 
        then
            initHashicorpVaultToken
            echo $VAULT_TOKEN 
        fi
        if [[ $1 = "readJson" ]] 
        then
            readHashicorpVaultSecret "$2"
            echo $VAULT_SECRET
        fi
        if [[ $1 = "write" ]] 
        then
            writeHashicorpVaultSecret "$2" "$3"
            echo $VAULT_RESPONSE
        fi
    fi
}
