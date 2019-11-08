#!/bin/bash


cd indy
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68DB5E88
sudo add-apt-repository "deb https://repo.sovrin.org/sdk/deb xenial stable"
sudo apt-get update
sudo apt-get install -y libindy

sudo apt-get install -y indy-cli

indy-cli generate_txn.txt


