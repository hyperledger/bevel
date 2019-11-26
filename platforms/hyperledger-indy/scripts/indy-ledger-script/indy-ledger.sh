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

vault login $vault_token

admin_did=$(vault kv get -field=did $admin_path/$admin_name/identity/public/did)

[ -z "$admin_did" ] && { echo "Script Failed"; exit 1;} || echo "Admin DID Acquired";
admin_seed=$(vault kv get -field=seed $admin_path/$admin_name)
[ -z "$admin_seed" ] && { echo "Script Failed"; exit 1;} || echo "Admin Seed Acquired";
identity_did=$(vault kv get -field=did $identity_path/$identity_name/identity/public/did)
[ -z "$identity_did" ] && { echo "Script Failed"; exit 1;} || echo "DID Acquired";
identity_seed=$(vault kv get -field=seed $identity_path/$identity_name/identity/private/seed)
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
did import ./admindid.txt
did import ./identitydid.txt
did list
exit" > indy_txn.txt

indy-cli indy_txn.txt > txn_result.txt
if grep -q 'Following NYM has been received' 'txn_result.txt'
then
	echo "Transaction Successful, NYM has been received"
else
	echo "Transaction Failed"
	exit 1
fi

identity_verkey=$(vault kv get -field=verkey $identity_path/$identity_name/client/public/verif_keys/verification-keys)


echo "wallet open myIndyWallet key=12345
did use $admin_did
pool create sandboxpool gen_txn_file=./genesis_pool_config
pool connect sandboxpool
pool list
exit" > indy_txn.txt

indy-cli indy_txn.txt > txn_result.txt
if grep -q 'Following NYM has been received' 'txn_result.txt'
then
	echo "Transaction Successful, NYM has been received"
else
	echo "Transaction Failed"
	exit 1
fi

echo "wallet open myIndyWallet key=12345
did use $admin_did
pool connect sandboxpool
ledger nym did=$identity_did verkey=$identity_verkey role=$identity_role
ledger get-nym did=$identity_did" > indy_txn.txt

indy-cli indy_txn.txt > txn_result.txt

if grep -q 'Following NYM has been received' 'txn_result.txt'
then
	echo "Transaction Successful, NYM has been received"
else
	echo "Transaction Failed"
	exit 1
fi
