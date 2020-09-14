#!/bin/sh

if [ -f {{ .Values.config.jarPath }}/networkmap.jar ]
then
    echo
    echo "CENM: starting Networkmap service ..."
    echo
    cat {{ .Values.config.configPath }}/nmap.conf
    java -Xmx{{ .Values.config.cordaJar.memorySize }}{{ .Values.config.cordaJar.unit }} -jar {{ .Values.config.jarPath }}/networkmap.jar -f {{ .Values.config.configPath }}/nmap.conf
    EXIT_CODE=${?}
else
    echo "Missing networkmap jar file in {{ .Values.config.jarPath }} folder:"
    ls -al {{ .Values.config.jarPath }}
    EXIT_CODE=110
fi
