#!/bin/sh
if [ -f {{ .Values.jarPath }}/corda.jar ]
then
    echo
    echo "Starting Node node ..."
    echo
    # command to run corda jar, we are setting javax.net.ssl.keyStore as ${BASE_DIR}/certificates/sslkeystore.jks since keystore gets reset when using h2 ssl 
    java -Djavax.net.ssl.keyStore={{ .Values.workspacePath }}/certificates/sslkeystore.jks -Djavax.net.ssl.keyStorePassword=password -jar {{ .Values.jarPath }}/corda.jar -f {{ .Values.workspacePath }}/node.conf --base-directory {{ .Values.workspacePath }}
    EXIT_CODE=${?}
else
    echo "Missing node jar file in {{ .Values.jarPath }} folder:"
    ls -al {{ .Values.jarPath }}
    EXIT_CODE=110
fi

if [ "${EXIT_CODE}" -ne "0" ]
then
    HOW_LONG={{ .Values.sleepTimeAfterError }}
    echo
    echo "Node failed - exit code: ${EXIT_CODE} (error)"
    echo
    echo "Going to sleep for requested ${HOW_LONG} seconds to let you login and investigate."
    echo
    sleep ${HOW_LONG}
fi
echo
