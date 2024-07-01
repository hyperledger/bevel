#!/bin/bash

set -x

CURRENT_DIR=${PWD}

echo "installing jq "
apt-get install -y jq
echo "installing wget "
apt-get wget
echo "installing sed "
apk add sed
echo "installing configtxlator"
mkdir temp
cd temp/
wget https://github.com/hyperledger/fabric/releases/download/v{{ version }}/hyperledger-fabric-{{ os }}-{{ arch }}-{{ version }}.tar.gz
tar -xvf hyperledger-fabric-{{ os }}-{{ arch }}-{{ version }}.tar.gz
mv bin/configtxlator ../
cd ../
rm -r temp
rm -r ../crypto/admin/msp/*
cp -r ./old-cert/admin/msp/* ../crypto/admin/msp
echo "converting the channel_config_block.pb to channel_config.json using configtxlator and jq"
configtxlator proto_decode --input {{ orderer_name }}_{{ channel_name }}_config_block.pb --type common.Block | jq .data.data[0].payload.data.config > {{ orderer_name }}_{{ channel_name }}_config.json
cp {{ orderer_name }}_{{ channel_name }}_config.json {{ orderer_name }}_{{ channel_name }}_modified_config.json
base64 ./old-cert/{{ orderer_name }}/server.crt | tr -d \\n > ./old-cert/{{ orderer_name }}/encodeserver.crt
base64 ./orderers/{{ orderer_name }}.{{ namespace }}/tls/server.crt | tr -d \\n > ./orderers/{{ orderer_name }}.{{ namespace }}/tls/encodeserver.crt
old_tls=$(cat ./old-cert/{{ orderer_name }}/encodeserver.crt)
new_tls=$(cat ./orderers/{{ orderer_name }}.{{ namespace }}/tls/encodeserver.crt)
sed -i "s/$old_tls/$new_tls/" "{{ orderer_name }}_{{ channel_name }}_modified_config.json"
echo "converting the channel_config.json and channel_modified_config.json to .pb files"
configtxlator proto_encode --input {{ orderer_name }}_{{ channel_name }}_config.json --type common.Config --output {{ orderer_name }}_{{ channel_name }}_config.pb
configtxlator proto_encode --input {{ orderer_name }}_{{ channel_name }}_modified_config.json --type common.Config --output {{ orderer_name }}_{{ channel_name }}_modified_config.pb
echo "calculate the delta between these two config protobufs using configtxlator"
configtxlator compute_update --channel_id {{ channel_name }} --original {{ orderer_name }}_{{ channel_name }}_config.pb --updated {{ orderer_name }}_{{ channel_name }}_modified_config.pb --output {{ orderer_name }}_{{ channel_name }}_update.pb
echo "decode the channel_update.pb to json to add headers."
configtxlator proto_decode --input {{ orderer_name }}_{{ channel_name }}_update.pb --type common.ConfigUpdate | jq . > {{ orderer_name }}_{{ channel_name }}_update.json
echo "wrapping the headers arround the channel_update.json file and create channel_update_in_envelope.json"
echo '{"payload":{"header":{"channel_header":{"channel_id":"{{ channel_name }}", "type":2}},"data":{"config_update":'$(cat {{ orderer_name }}_{{ channel_name }}_update.json)'}}}' | jq . > {{ orderer_name }}_{{ channel_name }}_update_in_envelope.json
echo "converting the channel_update_in_envelope.json to channel_update_in_envelope.pb"
configtxlator proto_encode --input {{ orderer_name }}_{{ channel_name }}_update_in_envelope.json --type common.Envelope --output {{ orderer_name }}_{{ channel_name }}_update_in_envelope.pb
mv {{ orderer_name }}_{{ channel_name }}_config_block.pb {{ orderer_name }}_{{ channel_name }}_config_block_old.pb
cd ${CURRENT_DIR}
