#!/bin/sh
NETWORK_ROOT_TRUSTSTORE=/certs/network-root-truststore.jks

#
# we start CENM services up almost in parallel so wait until idman port is open
#

timeout 10m bash -c 'until printf "" 2>>/dev/null >>/dev/tcp/$0/$1; do echo "Waiting for Identity Manager to be accessible ..."; sleep 5; done' {{ .Values.nodeConf.doormanDomain }} {{ .Values.nodeConf.doormanPort }}

# two main reason for endless loop:
#   - repeat in case IdMan is temporarily not available (real life experience ...)
#   - kubernetes monitoring: pod stuck in initContainer stage - helps with monitoring
while true
do
    if [ ! -f certificates/nodekeystore.jks ] || [ ! -f certificates/sslkeystore.jks ] || [ ! -f certificates/truststore.jks ]
    then
        sleep 30 # guards against "Failed to find the request with id: ... in approved or done requests. This might happen when the Identity Manager was restarted during the approval process."
        echo
        echo "Node: running initial registration ..."
        echo
        java -Dcapsule.jvm.args='-Xmx3G' -jar bin/corda.jar \
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