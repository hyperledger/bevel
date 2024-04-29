#!/bin/sh

if [ ! -f /opt/cenm/etc/token ]
then
    EXIT_CODE=1
    until [ "${EXIT_CODE}" -eq "0" ]
    do
        echo "Trying to login to gateway.{{ .Release.Namespace }}:{{ .Values.global.cenm.gateway.port }} ..."
        java -jar bin/cenm-tool.jar context login -s http://gateway.{{ .Release.Namespace }}:{{ .Values.global.cenm.gateway.port }} -u network-maintainer -p p4ssWord
        EXIT_CODE=${?}
        if [ "${EXIT_CODE}" -ne "0" ]
        then
            echo "EXIT_CODE=${EXIT_CODE}"
            sleep 5
        else
            break
        fi
    done
    ZONE_TOKEN=$(java -jar bin/cenm-tool.jar zone create-subzone \
        --config-file=etc/networkmap.conf --network-map-address=cenm-networkmap.{{ .Release.Namespace }}:{{ .Values.adminListener.port }} \
        --network-parameters=./notary-nodeinfo/network-parameters-initial.conf --label=Main --label-color='#941213' --zone-token)
    echo ${ZONE_TOKEN} > etc/token
fi
