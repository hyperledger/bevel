#!/bin/sh

set -x

echo "Waiting for notary-nodeinfo/network-parameters-initial.conf ..."
until [ -f notary-nodeinfo/network-parameters-initial.conf ]
do
    sleep 10
done
echo "Waiting for notary-nodeinfo/network-parameters-initial.conf ... done."

if [ ! -f {{ .Values.config.configPath }}/token ]
then
    EXIT_CODE=1
    until [ "${EXIT_CODE}" -eq "0" ]
    do
        echo "Trying to login to gateway:8080 ..."
        java -jar bin/cenm-tool.jar context login -s http://{{ .Values.cenmServices.gatewayName }}.{{ .Values.metadata.namespace }}:{{ .Values.cenmServices.gatewayPort }} -u network-maintainer -p p4ssWord
        EXIT_CODE=${?}
        if [ "${EXIT_CODE}" -ne "0" ]
        then
            echo "EXIT_CODE=${EXIT_CODE}"
            sleep 5
        else
            break
        fi
    done
    cat ./notary-nodeinfo/network-parameters-initial.conf
    ZONE_TOKEN=$(java -jar bin/cenm-tool.jar zone create-subzone \
        --config-file={{ .Values.config.configPath }}/nmap.conf --network-map-address={{ .Values.nodeName }}.{{ .Values.metadata.namespace }}:{{ .Values.service.adminListener.port }} \
        --network-parameters=./notary-nodeinfo/network-parameters-initial.conf --label=Main --label-color='#941213' --zone-token)
    echo ${ZONE_TOKEN}
    echo ${ZONE_TOKEN} > {{ .Values.config.configPath }}/token
    {{ if eq .Values.bashDebug true }}
    cat {{ .Values.config.configPath }}/token
    {{ end }}
fi
