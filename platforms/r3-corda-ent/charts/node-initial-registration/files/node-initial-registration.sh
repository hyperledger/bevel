#!/bin/sh

# Network root trust store path and password
NETWORK_ROOT_TRUSTSTORE=DATA/trust-stores/network-root-truststore.jks
NETWORK_ROOT_TRUSTSTOR_PASSWORD=password

# Check for network root trust store
while true
do
    if [ ! -f ${NETWORK_ROOT_TRUSTSTORE} ]
    then
        echo "no network-root-truststore"
        sleep 10
    else
        echo
        echo "md5/sha256 of ${NETWORK_ROOT_TRUSTSTORE}: "
        md5sum ${NETWORK_ROOT_TRUSTSTORE}    | awk '{print $1}' | xargs printf "   md5sum: %65s\n"
        sha256sum ${NETWORK_ROOT_TRUSTSTORE} | awk '{print $1}' | xargs printf "sha256sum: %65s\n"
        echo
        echo
        break
    fi
done

# Check for Idman and networkmap service links are up
server=$(echo {{ .Values.networkServices.doormanURL }} | sed 's/.*\/\/\(.*\):\(.*\)/\1/' )
port=$(echo {{ .Values.networkServices.doormanURL }} | sed 's/.*\/\/\(.*\):\(.*\)/\2/' )
printf "IdMan server:%s" "${server}"
printf "  IdMan port:%s" "${port}"
timeout 10m bash -c 'until printf "" 2>>/dev/null >>/dev/tcp/$0/$1; do sleep 1; done' ${server} ${port}

while true
do
    if [ ! -f certificates/nodekeystore.jks ] || [ ! -f certificates/sslkeystore.jks ] || [ ! -f certificates/truststore.jks ]
    then
        echo
        echo "Node: running initial registration ..."
        echo
        pwd
        java -jar {{ .Values.nodeConf.jarPath }}/corda.jar \
          initial-registration \
        --config-file={{ .Values.nodeConf.configPath }}/node.conf \
        --log-to-console \
        --network-root-truststore ${NETWORK_ROOT_TRUSTSTORE}  \
        --network-root-truststore-password ${NETWORK_ROOT_TRUSTSTOR_PASSWORD}
        EXIT_CODE=${?}
    else
        echo
        echo "Node: already registered to IdMan - skipping initial registration."
        echo
        EXIT_CODE="0"
        break
    fi
done

if [ "${EXIT_CODE}" -ne "0" ]
then
    HOW_LONG={{ .Values.sleepTimeAfterError }}
    echo
    echo "Node initial registration failed - exit code: ${EXIT_CODE} (error)"
    echo
    echo "Going to sleep for requested ${HOW_LONG} seconds to let you login and investigate."
    echo
    pwd
    ls -al 
else
    HOW_LONG={{ .Values.sleepTime }}
    echo
    echo "Node initial registration: no errors - sleeping for requested ${HOW_LONG} seconds before disappearing."
    echo
fi
sleep ${HOW_LONG}
