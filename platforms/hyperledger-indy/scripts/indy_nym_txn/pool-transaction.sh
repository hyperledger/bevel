#!/bin/bash


cd indy
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68DB5E88
sudo add-apt-repository "deb https://repo.sovrin.org/sdk/deb xenial stable"
sudo apt-get update
sudo apt-get install -y libindy

sudo apt-get install -y indy-cli

indy-cli generate_txn.txt > result.txt

if grep -q 'Following NYM has been received' 'result.txt'
then
	echo "Transaction successful, NYM has been received"
else
	echo "Transaction Failed"
	if grep -q 'Batch execution failed' 'result.txt'
		no=$(grep -oP "#\w" result.txt | tail -c 2)
		echo "Script Failed at line: $no"
		echo $(sed "${no}q;d" generate_txn.txt)
	fi
fi
		
	


