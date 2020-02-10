#!/bin/bash

mkdir indy
cd indy
git clone -b rc --depth=1 https://github.com/hyperledger/indy-sdk.git
cd indy-sdk
sudo docker build -f ci/indy-pool.dockerfile -t indy_pool .
sudo docker run --name pool_container -itd -p 9701-9708:9701-9708 indy_pool
sudo docker exec -t pool_container /bin/bash


