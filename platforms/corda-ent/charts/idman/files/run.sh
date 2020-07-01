#!/bin/sh
{{ if eq .Values.bashDebug true }}
set -x
{{ end }}

#
# main run
#
if [ -f {{ .Values.jarPath }}/identitymanager.jar ]
then
{{ if eq .Values.bashDebug true }}
    sha256sum {{ .Values.jarPath }}/identitymanager.jar 
    cat etc/idman.conf
{{ end }}
    echo
    echo "CENM: starting Identity Manager process ..."
    echo
    java -Xmx{{ .Values.cordaJarMx }}G -jar {{ .Values.jarPath }}/identitymanager.jar -f {{ .Values.configPath }}/idman.conf
    EXIT_CODE=${?}
else
    echo "Missing Identity Manager jar file in {{ .Values.jarPath }} folder:"
    ls -al {{ .Values.jarPath }}
    EXIT_CODE=110
fi

if [ "${EXIT_CODE}" -ne "0" ]
then
    HOW_LONG={{ .Values.sleepTimeAfterError }}
    echo
    echo "Notary initial registration failed - exit code: ${EXIT_CODE} (error)"
    echo
    echo "Going to sleep for requested ${HOW_LONG} seconds to let you login and investigate."
    echo
else
    HOW_LONG={{ .Values.sleepTime }}
    echo
    echo "Notary initial registration: no errors - sleeping for requested ${HOW_LONG} seconds before disappearing."
    echo
fi

sleep ${HOW_LONG}
echo