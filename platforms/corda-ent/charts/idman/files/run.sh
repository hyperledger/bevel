#!/bin/sh

# main run
if [ -f {{ .Values.jarPath }}/identitymanager.jar ]
then
    sha256sum {{ .Values.jarPath }}/identitymanager.jar 
    cat etc/idman.conf
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
    echo "exit code: ${EXIT_CODE} (error)"
    echo "Going to sleep for requested ${HOW_LONG} seconds to let you login and investigate."
fi
sleep ${HOW_LONG}
echo
