#!/bin/sh

if [ ! -f /opt/cenm/etc/token ]
then
    EXIT_CODE=1
    until [ "${EXIT_CODE}" -eq "0" ]
    do
        echo "Trying to login to gateway.{{ .Release.Namespace }}:{{ .Values.global.cenm.gateway.port }} ..."
        java -jar bin/cenm-tool.jar context login -s http://gateway.{{ .Release.Namespace }}:{{ .Values.global.cenm.gateway.port }} -u config-maintainer -p p4ssWord
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
    until [ "${EXIT_CODE}" -eq "0" ]
    do
        ZONE_TOKEN=$(java -jar /opt/cenm/bin/cenm-tool.jar identity-manager config set -f=/opt/cenm/etc/idman.conf --zone-token)
        EXIT_CODE=${?}
        if [ "${EXIT_CODE}" -ne "0" ]
        then
            echo "EXIT_CODE=${EXIT_CODE}"
            sleep 5
        else
            break
        fi
    done
    java -jar bin/cenm-tool.jar identity-manager config set-admin-address -a=idman.{{ .Release.Namespace }}:{{ .Values.adminListener.port }}
fi
