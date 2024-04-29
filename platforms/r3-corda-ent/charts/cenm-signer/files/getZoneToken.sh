#!/bin/sh

if [ ! -f /opt/cenm/etc/token ]
then
    EXIT_CODE=1
    until [ "${EXIT_CODE}" -eq "0" ]
    do
        echo "Trying to login to gateway.{{ .Release.Namespace }}:{{ .Values.global.cenm.gateway.port }} ..."
        java -jar bin/cenm-tool.jar context login -s http://gateway.{{ .Release.Namespace }}:{{ .Values.global.cenm.gateway.port }} -u config-maintainer -p p4ssWord
        EXIT_CODE=${?}
        echo "EXIT_CODE=${EXIT_CODE}"
        sleep 5
    done
    
    java -jar bin/cenm-tool.jar signer config set-admin-address -a=signer.{{ .Release.Namespace }}:{{ .Values.adminListener.port }}
fi
