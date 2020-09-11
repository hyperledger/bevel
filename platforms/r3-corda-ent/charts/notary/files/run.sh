#!/bin/sh
if [ -f {{ .Values.nodeConf.jarPath }}/corda.jar ]
then
    echo
    echo "CENM: starting Notary node ..."
    echo
    # command to run corda jar, we are setting javax.net.ssl.keyStore as ${BASE_DIR}/certificates/sslkeystore.jks since keystore gets reset when using h2 ssl 
    java -Djavax.net.ssl.keyStore=${BASE_DIR}/certificates/sslkeystore.jks -Djavax.net.ssl.keyStorePassword=cordacadevpass -jar {{ .Values.nodeConf.jarPath }}/corda.jar -f ${BASE_DIR}/etc/notary.conf --base-directory=${BASE_DIR}
        
    EXIT_CODE=${?}
else
    echo "Missing notary jar file in {{ .Values.nodeConf.jarPath }} folder:"
    ls -al {{ .Values.nodeConf.jarPath }}
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
