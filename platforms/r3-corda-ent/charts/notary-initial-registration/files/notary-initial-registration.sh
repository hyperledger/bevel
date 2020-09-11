#!/bin/sh
# [TODO: This needs to be moved inside the container 
# and the root store password needs to be fetched from vault]
# Future enhancement : file service to provide network-root-truststore

NETWORK_ROOT_TRUSTSTORE=DATA/trust-stores/network-root-truststore.jks
NETWORK_ROOT_TRUSTSTOR_PASSWORD=password

while true
do
    if [ ! -f certificates/nodekeystore.jks ] || [ ! -f certificates/sslkeystore.jks ] || [ ! -f certificates/truststore.jks ]
    then
        echo
        echo "Notary: running initial registration ..."
        echo
        pwd
        java -Dcapsule.jvm.args='-Xmx{{ .Values.nodeConf.cordaJar.memorySize }}{{ .Values.nodeConf.cordaJar.unit }}' -jar {{ .Values.nodeConf.jarPath }}/corda.jar \
          initial-registration \
        --config-file={{ .Values.nodeConf.configPath }}/notary.conf \
        --log-to-console \
        --network-root-truststore ${NETWORK_ROOT_TRUSTSTORE}  \
        --network-root-truststore-password ${NETWORK_ROOT_TRUSTSTOR_PASSWORD}
        
        EXIT_CODE=${?}
    else
        echo
        echo "Notary: already registered to IdMan - skipping initial registration."
        echo
        EXIT_CODE="0"
        break
    fi
done

if [ "${EXIT_CODE}" -ne "0" ]
then
    HOW_LONG={{ .Values.sleepTimeAfterError }}
    echo
    echo "Notary initial registration failed - exit code: ${EXIT_CODE} (error)"
    echo
    echo "Going to sleep for requested ${HOW_LONG} seconds to let you login and investigate."
    echo
    pwd
    ls -al 
else
    HOW_LONG={{ .Values.sleepTime }}
    echo
    echo "Notary initial registration: no errors - sleeping for requested ${HOW_LONG} seconds before disappearing."
    echo
fi

sleep ${HOW_LONG}
echo
