#!/bin/bash

vault_addr=$1
vault_token=$2
admin_path=$3
admin_name=$4
identity_path=$5
identity_name=$6
identity_role=$7
pool_genesis_path=$8

[ -z "$vault_addr" ] && { echo "Script Failed: Vault Address Missing"; exit 1;} || echo "Vault Address Received";
[ -z "$vault_token" ] && { echo "Script Failed: Vault Token Missing"; exit 1;} || echo "VAult Token Received";
[ -z "$admin_path" ] && { echo "Script Failed: Admin DID Path Missing"; exit 1;} || echo "Admin DID Path Received";
[ -z "$admin_name" ] && { echo "Script Failed: Admin Name Missing"; exit 1;} || echo "Admin Name Received";
[ -z "$identity_path" ] && { echo "Script Failed: Identity DID Path Missing"; exit 1;} || echo "Identity DID Received";
[ -z "$identity_name" ] && { echo "Script Failed: Identity DID Name Missing"; exit 1;} || echo "Identity Name Received";
[ -z "$identity_role" ] && { echo "Script Failed: Identity Role Missing"; exit 1;} || echo "Identity Role Received";
[ -z "$pool_genesis_path" ] && { echo "Script Failed: Genesis Pool File Path Missing"; exit 1;} || echo "Genesis Pool File Path Received";

export VAULT_ADDR=$vault_addr
export VAULT_TOKEN=$vault_token

sudo apt-get install jq


QUERY_RES=$(curl -sS --header "X-Vault-Token: $vault_token" $vault_addr/$admin_path/$admin_name/identity/public | jq -r 'if .errors then . else . end')
admin_did=$(echo ${QUERY_RES} | jq -r ".data[\"did\"]")
[ -z "$admin_did" ] && { echo "Script Failed"; exit 1;} || echo "Admin DID Acquired";

QUERY_RES=$(curl -sS --header "X-Vault-Token: $vault_token" $vault_addr/$admin_path/$admin_name/identity/private | jq -r 'if .errors then . else . end')
admin_seed=$(echo ${QUERY_RES} | jq -r ".data[\"seed\"]")
[ -z "$admin_seed" ] && { echo "Script Failed"; exit 1;} || echo "Admin Seed Acquired";

QUERY_RES=$(curl -sS --header "X-Vault-Token: $vault_token" $vault_addr/$identity_path/$identity_name/identity/private | jq -r 'if .errors then . else . end')
identity_did=$(echo ${QUERY_RES} | jq -r ".data[\"did\"]")
[ -z "$identity_did" ] && { echo "Script Failed"; exit 1;} || echo "DID Acquired";

QUERY_RES=$(curl -sS --header "X-Vault-Token: $vault_token" $vault_addr/$identity_path/$identity_name/identity/private | jq -r 'if .errors then . else . end')
identity_seed=$(echo ${QUERY_RES} | jq -r ".data[\"seed\"]")
[ -z "$identity_seed" ] && { echo "Script Failed"; exit 1;} || echo "Seed Acquired";

# Creating did files
echo "{
\"version\": 1,
\"dids\": [{
\"did\": \"$admin_did\", 
\"seed\": \"$admin_seed\"
}]
}" > admindid.txt

echo "{
\"version\": 1,
\"dids\": [{
\"did\": \"$identity_did\", 
\"seed\": \"$identity_seed\"
}]
}" > identitydid.txt

echo "wallet create myIndyWallet key=12345
wallet open myIndyWallet key=12345
wallet list
exit" > indy_txn.txt

indy-cli indy_txn.txt > txn_result.txt
if grep -q 'Wallet "myIndyWallet" has been opened' 'txn_result.txt'
then
	echo "Indy Wallet has been successfully opened."
else
	echo "ERROR: Cannot open Wallet..."
	exit 1
fi

echo "wallet open myIndyWallet key=12345
did import ./admindid.txt
did import ./identitydid.txt
exit" > indy_txn.txt

indy-cli indy_txn.txt > txn_result.txt
if grep -q 'DIDs import finished' 'txn_result.txt'
then
	echo "DID imported successfully."
else
	echo "Cannot Import DID..."
	exit 1
fi

echo "wallet open myIndyWallet key=12345
did list
did use $admin_did
exit" > indy_txn.txt

indy-cli indy_txn.txt > txn_result.txt
if grep -q 'Did \"$admin_did\" has been set as active' 'txn_result.txt'
then
	echo "DID set active."
else
	echo "ERROR: Cannot use DID..."
	exit 1
fi

echo "wallet open myIndyWallet key=12345
did use $admin_did
pool create sandboxpool gen_txn_file=./genesis_pool_config
pool connect sandboxpool
pool list
exit" > indy_txn.txt

indy-cli indy_txn.txt > txn_result.txt
if grep -q 'Pool "sandboxpool" has been connected' 'txn_result.txt'
then
	echo "Pool successfully Connected"
else
	echo "Pool Connection failed..."
	exit 1
fi

QUERY_RES=$(curl -sS --header "X-Vault-Token: $vault_token" $vault_addr/$identity_path/$identity_name/client/public/verif_keys | jq -r 'if .errors then . else . end')
identity_verkey=$(echo ${QUERY_RES} | jq -r ".data[\"verification-key\"]")
[ -z "$identity_verkey" ] && { echo "Script Failed"; exit 1;} || echo "Verkey Acquired";

echo "wallet open myIndyWallet key=12345
did use $admin_did
pool connect sandboxpool
ledger nym did=$identity_did verkey=$identity_verkey role=$identity_role
ledger get-nym did=$identity_did" > indy_txn.txt

indy-cli indy_txn.txt > txn_result.txt

if grep -q 'Following NYM has been received' 'txn_result.txt'
then
	echo "Transaction Successful, NYM has been received"
	exit 0
else
	echo "Transaction Failed"
	exit 1
fi
