#!/bin/sh

# main run
if [ -f {{ .Values.config.jarPath }}/identitymanager.jar ]
then
    sha256sum {{ .Values.config.jarPath }}/identitymanager.jar 
    cat etc/idman.conf
    echo
    echo "CENM: starting Identity Manager process ..."
    echo
    java -Xmx{{ .Values.config.cordaJar.memorySize }}{{ .Values.config.cordaJar.unit }} -jar {{ .Values.config.jarPath }}/identitymanager.jar -f {{ .Values.config.configPath }}/idman.conf
    EXIT_CODE=${?}
else
    echo "Missing Identity Manager jar file in {{ .Values.config.jarPath }} folder:"
    ls -al {{ .Values.config.jarPath }}
    EXIT_CODE=110
fi

if [ "${EXIT_CODE}" -ne "0" ]
then
    HOW_LONG={{ .Values.config.sleepTimeAfterError }}
    echo
    echo "exit code: ${EXIT_CODE} (error)"
    echo "Going to sleep for requested ${HOW_LONG} seconds to let you login and investigate."
fi
sleep ${HOW_LONG}
echo
