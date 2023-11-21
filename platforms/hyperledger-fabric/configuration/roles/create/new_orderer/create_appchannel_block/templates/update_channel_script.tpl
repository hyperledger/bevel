#!/bin/bash

set -x

CURRENT_DIR=${PWD}
NETWORK_VERSION="{{ version }}"

echo "installing jq "
apt-get install -y jq
if [ "$NETWORK_VERSION" != "2.5.4" ]; then
    echo "installing configtxlator"
    mkdir temp
    cd temp/
    wget https://github.com/hyperledger/fabric/releases/download/v{{ version }}/hyperledger-fabric-{{ os }}-{{ arch }}-{{ version }}.tar.gz
    tar -xvf hyperledger-fabric-{{ os }}-{{ arch }}-{{ version }}.tar.gz
    mv bin/configtxlator ../
    cd ../
    rm -r temp
fi

echo "converting the channel_config_block.pb to channel_config.json using configtxlator and jq"
configtxlator proto_decode --input {{ channel_name }}_config_block.pb --type common.Block | jq .data.data[0].payload.data.config > {{ channel_name }}_config.json
echo "adding new organization crypto material from config.json to the channel_config.json to make channel_modified_config.json"
if [ "$NETWORK_VERSION" != "2.5.4" ]; then
    echo "version 2.2.2++++"
    jq --argjson a "$(cat ./orderer)" '.channel_group.values.OrdererAddresses.value.addresses += $a' {{ channel_name }}_config.json > {{ channel_name }}_modified_intermediate_config.json
    jq --argjson a "$(cat ./orderer-tls)" '.channel_group.groups.Orderer.values.ConsensusType.value.metadata.consenters += $a' {{ channel_name }}_modified_intermediate_config.json > {{ channel_name }}_modified_config.json
else
    echo "version 2.5.4++++"
    jq --argjson a "$(cat ./orderer)" '.channel_group.values.OrdererAddresses.value.addresses += $a' {{ channel_name }}_config.json > {{ channel_name }}_modified_intermediate_address_config.json
    jq --argjson a "$(cat ./orderer)" '.channel_group.groups.Orderer.groups.{{ component_name }}MSP.values.Endpoints.value.addresses += $a' {{ channel_name }}_modified_intermediate_address_config.json > {{ channel_name }}_modified_intermediate_endpoints_config.json
    jq --argjson a "$(cat ./orderer-tls)" '.channel_group.groups.Orderer.values.ConsensusType.value.metadata.consenters += $a' {{ channel_name }}_modified_intermediate_endpoints_config.json > {{ channel_name }}_modified_config.json
fi
echo "converting the channel_config.json and channel_modified_config.json to .pb files"
configtxlator proto_encode --input {{ channel_name }}_config.json --type common.Config --output {{ channel_name }}_config.pb
configtxlator proto_encode --input {{ channel_name }}_modified_config.json --type common.Config --output {{ channel_name }}_modified_config.pb
echo "calculate the delta between these two config protobufs using configtxlator"
configtxlator compute_update --channel_id {{ channel_name }} --original {{ channel_name }}_config.pb --updated {{ channel_name }}_modified_config.pb --output {{ channel_name }}_update.pb
echo "decode the channel_update.pb to json to add headers."
configtxlator proto_decode --input {{ channel_name }}_update.pb --type common.ConfigUpdate | jq . > {{ channel_name }}_update.json
echo "wrapping the headers arround the channel_update.json file and create channel_update_in_envelope.json"
echo '{"payload":{"header":{"channel_header":{"channel_id":"{{ channel_name }}", "type":2}},"data":{"config_update":'$(cat {{ channel_name }}_update.json)'}}}' | jq . > {{ channel_name }}_update_in_envelope.json
echo "converting the channel_update_in_envelope.json to channel_update_in_envelope.pb"
configtxlator proto_encode --input {{ channel_name }}_update_in_envelope.json --type common.Envelope --output {{ channel_name }}_update_in_envelope.pb
mv {{ channel_name }}_config_block.pb {{ channel_name }}_config_block_old.pb
cd ${CURRENT_DIR}
