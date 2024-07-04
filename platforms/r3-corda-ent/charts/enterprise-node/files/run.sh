#!/bin/sh

NODE_SSL_TRUSTSTORE=/opt/corda/certificates/truststore.jks

{{- if eq .Values.global.proxy.provider "ambassador" }}
yes | keytool -importcert -file /certs/doorman/tls.crt -storepass {{ .Values.nodeConf.creds.truststore }} -alias {{ .Values.nodeConf.doormanDomain }} -keystore $NODE_SSL_TRUSTSTORE
yes | keytool -importcert -file /certs/nms/tls.crt -storepass {{ .Values.nodeConf.creds.truststore }} -alias {{ .Values.nodeConf.networkMapDomain }} -keystore $NODE_SSL_TRUSTSTORE
{{- end }}


#
# main run
#
if [ -f bin/corda.jar ]
then
    echo "running DB migration.."
    echo
    java -Djavax.net.ssl.trustStore=$NODE_SSL_TRUSTSTORE \
    -Djavax.net.ssl.keyStore=/opt/corda/certificates/sslkeystore.jks \
    -Djavax.net.ssl.keyStorePassword={{ .Values.nodeConf.creds.keystore }} \
    -jar bin/corda.jar run-migration-scripts --core-schemas --app-schemas \
    -f etc/node.conf 
    echo
    echo "Corda: starting node ..."
    echo
    java -Djavax.net.ssl.trustStore=$NODE_SSL_TRUSTSTORE \
    -Djavax.net.ssl.trustStorePassword={{ .Values.nodeConf.creds.truststore }} \
    -Djavax.net.ssl.keyStore=/opt/corda/certificates/sslkeystore.jks \
    -Djavax.net.ssl.keyStorePassword={{ .Values.nodeConf.creds.keystore }} \
    -jar bin/corda.jar \
    -f etc/node.conf
    echo
    EXIT_CODE=${?}
else
    echo "Missing node jar file in bin directory:"
    ls -al bin
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
