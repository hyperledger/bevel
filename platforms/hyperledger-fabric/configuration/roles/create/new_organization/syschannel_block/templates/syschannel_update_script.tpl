#!/bin/bash

set -x

CURRENT_DIR=${PWD}

echo "installing jq "
apt-get install -y jq
echo "installing configtxlator"
mkdir temp
cd temp/
wget https://github.com/hyperledger/fabric/releases/download/v{{ version }}/hyperledger-fabric-{{ os }}-{{ arch }}-{{ version }}.tar.gz
tar -xvf hyperledger-fabric-{{ os }}-{{ arch }}-{{ version }}.tar.gz
mv bin/configtxlator ../
cd ../
rm -r temp
echo "converting the channel_config_block.pb to channel_config.json using configtxlator and jq"
configtxlator proto_decode --input {{ channel_name }}_config_block.pb --type common.Block | jq .data.data[0].payload.data.config > {{ channel_name }}_config_block.json
echo "adding new organization crypto material from config.json to the channel_config.json to make channel_modified_config.json"
echo "adding org to the existing consortium"
jq -s '.[0] * {"channel_group":{"groups":{"Consortiums":{"groups": {"{{ channel.consortium }}": {"groups": {"{{ new_org.name | lower }}MSP":.[1]}}}}}}}' {{ channel_name }}_config_block.json ./config.json >& {{ channel_name }}_updated_config.json
configtxlator proto_encode --input {{ channel_name }}_config_block.json --type common.Config --output {{ channel_name }}_config.pb
configtxlator proto_encode --input {{ channel_name }}_updated_config.json --type common.Config --output {{ channel_name }}_updated_config.pb
echo "calculate the delta between these two config protobufs using configtxlator"
configtxlator compute_update --channel_id {{ channel_name }} --original {{ channel_name }}_config.pb --updated {{ channel_name }}_updated_config.pb --output {{ channel_name }}_diff_config.pb
echo "decode the channel_update.pb to json to add headers."
configtxlator proto_decode --input {{ channel_name }}_diff_config.pb --type common.ConfigUpdate | jq . > {{ channel_name }}_diff_config.json
echo "wrapping the headers arround the channel_update.json file and create channel_update_in_envelope.json"
echo '{"payload":{"header":{"channel_header":{"channel_id":"{{ channel_name | lower }}", "type":2}},"data":{"config_update":'$(cat {{ channel_name }}_diff_config.json)'}}}' | jq . > {{ channel_name }}_diff_config_envelope.json
echo "converting the channel_update_in_envelope.json to channel_update_in_envelope.pb"
configtxlator proto_encode --input {{ channel_name }}_diff_config_envelope.json --type common.Envelope --output {{ channel_name }}_diff_config_envelope.pb
mv {{ channel_name }}_config_block.pb {{ channel_name }}_config_block_old.pb
cd ${CURRENT_DIR}
