# This function validates HashiCorp Vault responses
function validateVaultResponseHashicorp {
    if [[ $3 == "LOOKUPSECRETRESPONSE" ]]; then
        http_code=$(curl -fsS -o /dev/null -w "%{http_code}" \
            --header "X-Vault-Token: ${VAULT_TOKEN}" \
            "${VAULT_ADDR}/v1/${1}")
        curl_response=$?
        if [[ $http_code != "200" ]]; then
            echo "Http response code from Vault - $http_code and curl_response - $curl_response"
            if [[ $curl_response != "0" ]]; then
                echo "Error: curl command failed with error code - $curl_response"
                exit 1
            fi
        fi
    fi
}

# Initialize Vault token
function initHashicorpVaultToken {
    # Retrieve the Kubernetes service account token
    KUBE_SA_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
    # Request a Vault token using the Kubernetes authentication method
    RESPONSE=$(curl -sS --request POST "${VAULT_ADDR}/v1/auth/${KUBERNETES_AUTH_PATH}/login" -H "Content-Type: application/json" -d \
        '{"role":"'${VAULT_APP_ROLE}'","jwt":"'${KUBE_SA_TOKEN}'"}')
    # Print the Vault API response
    echo "Vault token API call response: $RESPONSE"

    # Extract error message (if any) from the response using jq
    ERROR=$(echo "$RESPONSE" | jq -r '.errors[0]')
    # Extract the Vault secret data from the response using jq
    VAULT_TOKEN=$(echo "$RESPONSE" | jq -r '.auth.client_token')

    # Check if the Vault token is empty, null, or contains errors
    if [[ $VAULT_TOKEN == "" || $VAULT_TOKEN == "null" || $VAULT_TOKEN == *"errors"* ]]; then
        echo "Error: Failed to obtain Vault token."
        echo "Error Details: $ERROR"
        exit 1
    else
        echo "Vault token successfully obtained."
        validateVaultResponseHashicorp 'vault login token' "$VAULT_TOKEN"
    fi
}

# Read Vault secret
function readHashicorpVaultSecret {
    # Send a request to Vault API to read a secret
    RESPONSE=$(curl --header "X-Vault-Token: ${VAULT_TOKEN}" "${VAULT_ADDR}/v1/${1}")
    # Print the Vault API response
    echo "Vault read API call response: $RESPONSE"

    # Extract error message (if any) from the response using jq
    ERROR=$(echo "$RESPONSE" | jq -r '.errors[0]')
    # Extract the Vault secret data from the response using jq
    VAULT_SECRET=$(echo "$RESPONSE" | jq -r '.data')

    # Check if the Vault Secret is empty, null, or contains errors
    if [[ $VAULT_SECRET == "" || $VAULT_SECRET == "null" || $VAULT_SECRET == *"errors"* ]]; then
        echo "Error: Failed to read Vault secret."
        echo "Error Details: $ERROR"
        exit 1
    fi
}

# Write a secret to the Vault
function writeHashicorpVaultSecret {
    # Send a request to Vault API to write a secret
    VAULT_RESPONSE=$(curl \
        -H "X-Vault-Token: ${VAULT_TOKEN}" \
        -H "Content-Type: application/json" \
        -X POST \
        -d @"${2}" \
        "${VAULT_ADDR}/v1/${1}")

    # Print the Vault API response
    echo "Vault write API call response: ${VAULT_RESPONSE}"

    # Check if the Vault API response indicates a failure
    if [[ $VAULT_RESPONSE == "" || $VAULT_RESPONSE == "null" || $VAULT_RESPONSE == *"errors"* ]]; then
        echo "Error: Failed to write to Vault"
        exit 1
    fi
}

vaultBevelFunc() {
    if [[ $VAULT_TYPE == "hashicorp" ]]; then
        case $1 in
            "init")
                # Initialize Vault token
                initHashicorpVaultToken
                ;;
            "readJson")
                # Read Vault secret
                readHashicorpVaultSecret "$2"
                ;;
            "write")
                # Write a secret to the Vault
                writeHashicorpVaultSecret "$2" "$3"
                ;;
            *)
                # Invalid option
                echo "Invalid option"
                exit 1
                ;;
        esac
    fi
}
