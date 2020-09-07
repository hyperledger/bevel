#!/bin/sh
{{ if eq .Values.bashDebug true }}
set -x
{{ end }}

#
# main run
#
if [ -f {{ .Values.jarPath }}/networkmap.jar ]
then
{{ if eq .Values.bashDebug true }}
    sha256sum {{ .Values.jarPath }}/networkmap.jar 
{{ end }}
    echo
    echo "CENM: starting Networkmap service ..."
    echo
    cat {{ .Values.configPath }}/nmap.conf
    java -Xmx{{ .Values.cordaJarMx }}M -jar {{ .Values.jarPath }}/networkmap.jar -f {{ .Values.configPath }}/nmap.conf
    EXIT_CODE=${?}
else
    echo "Missing networkmap jar file in {{ .Values.jarPath }} folder:"
    ls -al {{ .Values.jarPath }}
    EXIT_CODE=110
fi
