#!/bin/sh
NETWORK_ROOT_TRUSTSTORE=/certs/network-root-truststore.jks
JAVA_ARGS="-Dcapsule.jvm.args='-Xmx3G'"

{{- if eq .Values.global.proxy.provider "ambassador" }}
CUSTOM_SSL_TRUSTSTORE=/opt/corda/certificates/corda-ssl-custom-trust-store.jks
JAVA_ARGS="-Dcapsule.jvm.args='-Xmx3G' -Djavax.net.ssl.trustStore=${CUSTOM_SSL_TRUSTSTORE}"
yes | keytool -importcert -file /certs/doorman/tls.crt -storepass {{ .Values.nodeConf.creds.truststore }} -alias {{ .Values.nodeConf.doormanDomain }} -keystore $CUSTOM_SSL_TRUSTSTORE
yes | keytool -importcert -file /certs/nms/tls.crt -storepass {{ .Values.nodeConf.creds.truststore }} -alias {{ .Values.nodeConf.networkMapDomain }} -keystore $CUSTOM_SSL_TRUSTSTORE
{{- end }}

while true
do
    if [ ! -f certificates/nodekeystore.jks ] || [ ! -f certificates/sslkeystore.jks ] || [ ! -f certificates/truststore.jks ]
    then
        echo
        echo "Node: running initial registration ..."
        echo
        java $JAVA_ARGS \
        -jar bin/corda.jar \
          initial-registration \
        --config-file=etc/node.conf \
        --log-to-console \
        --network-root-truststore ${NETWORK_ROOT_TRUSTSTORE}  \
        --network-root-truststore-password {{ .Values.network.creds.truststore }}
        EXIT_CODE=${?}
        echo
        echo "Initial registration exit code: ${EXIT_CODE}"
        echo
    else
        echo
        echo "Node: already registered to Identity Manager - skipping initial registration."
        echo
        EXIT_CODE="0"
        break
    fi
done

if [ "${EXIT_CODE}" -ne "0" ]
then
    echo
    echo "Node initial registration failed - exit code: ${EXIT_CODE} (error)"
    echo
    echo "Going to sleep for the requested {{ .Values.sleepTimeAfterError }} seconds to let you log in and investigate."
    echo
    sleep {{ .Values.sleepTimeAfterError }}
fi
echo
