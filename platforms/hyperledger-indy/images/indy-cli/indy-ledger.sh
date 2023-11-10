#!/bin/bash

admin_did=$1
admin_seed=$2
identity_did=$3
identity_role=$4
identity_verkey=$5
pool_genesis_path=$6

[ -z "$admin_did" ] && { echo "Script Failed: Admin DID Missing"; exit 1;} || echo "Admin DID Received";
[ -z "$admin_seed" ] && { echo "Script Failed: Admin seed Missing"; exit 1;} || echo "Admin Seed Received";
[ -z "$identity_did" ] && { echo "Script Failed: Identity DID Missing"; exit 1;} || echo "Identity DID Received";
[ -z "$identity_role" ] && { echo "Script Failed: Identity Role Missing"; exit 1;} || echo "Identity Role Received";
[ -z "$identity_verkey" ] && { echo "Script Failed: Identity Verkey Missing"; exit 1;} || echo "Identity Verkey Received";
[ -z "$pool_genesis_path" ] && { echo "Script Failed: Genesis Pool File Path Missing"; exit 1;} || echo "Genesis Pool File Path Received";

# Creating did files
echo "{
\"version\": 1,
\"dids\": [{
\"did\": \"$admin_did\", 
\"seed\": \"$admin_seed\"
}]
}" > admindid.txt;

echo "wallet create myIndyWallet key=12345
wallet open myIndyWallet key=12345
wallet list
exit" > indy_txn.txt;

indy-cli indy_txn.txt > txn_result.txt;
if grep -q 'Wallet "myIndyWallet" has been opened' 'txn_result.txt'
then
	echo "Indy Wallet has been successfully opened.";
else
	echo "ERROR: Cannot open Wallet...";
	exit 1
fi

echo "wallet open myIndyWallet key=12345
did import ./admindid.txt
exit" > indy_txn.txt;

indy-cli indy_txn.txt > txn_result.txt;
if grep -q 'DIDs import finished' 'txn_result.txt'
then
	echo "DID imported successfully.";
else
	echo "Cannot Import DID...";
	exit 1
fi

echo "wallet open myIndyWallet key=12345
did list
did use $admin_did
exit" > indy_txn.txt;

indy-cli indy_txn.txt > txn_result.txt;
if grep -Fxq "Did \"$admin_did\" has been set as active" txn_result.txt
then
	echo "DID set active.";
else
	echo "ERROR: Cannot use DID...";
	exit 1
fi

echo "wallet open myIndyWallet key=12345
did use $admin_did
pool create sandboxpool gen_txn_file=$pool_genesis_path
pool connect sandboxpool
pool list
exit" > indy_txn.txt;

indy-cli indy_txn.txt > txn_result.txt
if grep -Fxq "Pool \"sandboxpool\" has been connected" txn_result.txt
then
	echo "Pool successfully Connected";
else
	echo "Pool Connection failed...";
	exit 1
fi

echo "wallet open myIndyWallet key=12345
did use $admin_did
pool connect sandboxpool
ledger nym did=$identity_did verkey=$identity_verkey role=$identity_role
ledger get-nym did=$identity_did" > indy_txn.txt;

indy-cli indy_txn.txt > txn_result.txt;

if grep -Fxq "Following NYM has been received." txn_result.txt
then
	echo "Transaction Successful, NYM has been received";
else
	echo "Transaction Failed";
	exit 1
fi

# It parses a output of indy-cli. It reads values of columns Desc(did), verkey and role for correct check.
file=$(cat txn_result.txt)
if [[ ${file} =~ \|[[:space:]]([[:alnum:]]*)[[:space:]]\|[[:space:]](${identity_did})[[:space:]]\|[[:space:]](${identity_verkey})[[:space:]]\|[[:space:]](${identity_role})[[:space:]]\| ]]; then
  echo "Role [${identity_role}] successfuly created."
  exit 0
else
  echo "Transaction Failed."
  exit 1
fi
