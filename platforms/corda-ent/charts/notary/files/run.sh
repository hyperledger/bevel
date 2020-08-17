#!/bin/sh
{{ if eq .Values.bashDebug true }}
set -x
{{ end }}

if [ -f {{ .Values.jarPath }}/corda.jar ]
then
{{ if eq .Values.bashDebug true }}
    sha256sum {{ .Values.jarPath }}/corda.jar 
{{ end }}
    echo
    echo "CENM: starting Notary node ..."
    echo
    java -jar {{ .Values.jarPath }}/corda.jar -f {{ .Values.configPath }}/notary.conf
    EXIT_CODE=${?}
else
    echo "Missing notary jar file in {{ .Values.jarPath }} folder:"
    ls -al {{ .Values.jarPath }}
    EXIT_CODE=110
fi

if [ "${EXIT_CODE}" -ne "0" ]
then
    HOW_LONG={{ .Values.sleepTimeAfterError }}
    echo
    echo "Notary failed - exit code: ${EXIT_CODE} (error)"
    echo
    echo "Going to sleep for requested ${HOW_LONG} seconds to let you login and investigate."
    echo
    sleep ${HOW_LONG}
fi
echo
