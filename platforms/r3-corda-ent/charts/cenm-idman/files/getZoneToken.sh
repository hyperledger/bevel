#!/bin/sh

set -x
if [ ! -f etc/token ]
then
    EXIT_CODE=1
    until [ "${EXIT_CODE}" -eq "0" ]
    do
        echo "CENM: Attempting to login to gateway:8080 ..."
        java -jar bin/cenm-tool.jar context login -s http://{{ .Values.cenmServices.gatewayName }}.{{ .Values.metadata.namespace }}:{{ .Values.cenmServices.gatewayPort }} -u config-maintainer -p p4ssWord
        EXIT_CODE=${?}
        if [ "${EXIT_CODE}" -ne "0" ]
        then
            echo "EXIT_CODE=${EXIT_CODE}"
            sleep 5
        else
            break
        fi
    done
    EXIT_CODE=1
    {{ if eq .Values.bashDebug true }}
    cat etc/idman.conf
    {{ end }}
    until [ "${EXIT_CODE}" -eq "0" ]
    do
        ZONE_TOKEN=$(java -jar bin/cenm-tool.jar identity-manager config set -f=etc/idman.conf --zone-token)
        EXIT_CODE=${?}
        if [ "${EXIT_CODE}" -ne "0" ]
        then
            echo "EXIT_CODE=${EXIT_CODE}"
            sleep 5
        else
            break
        fi
    done
    echo ${ZONE_TOKEN}
    echo ${ZONE_TOKEN} > etc/token
    {{ if eq .Values.bashDebug true }}
    cat etc/token
    {{ end }}
    java -jar bin/cenm-tool.jar identity-manager config set-admin-address -a={{ .Values.nodeName }}.{{ .Values.metadata.namespace }}:{{ .Values.service.adminListener.port }}
fi
