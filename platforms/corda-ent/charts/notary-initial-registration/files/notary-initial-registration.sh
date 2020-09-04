#!/bin/sh
{{ if eq .Values.bashDebug true }}
set -x
pwd
cat -n etc/notary.conf
{{ end }}

#
# wait for network-root-truststore.jks to be available
#
NETWORK_ROOT_TRUSTSTORE=DATA/trust-stores/network-root-truststore.jks
NETWORK_ROOT_TRUSTSTOR_PASSWORD=password

{{ if .Values.jksSource }}
set -x
curl {{ .Values.jksSource }} -o ${NETWORK_ROOT_TRUSTSTORE}
{{ end }}

while true
do
    if [ ! -f ${NETWORK_ROOT_TRUSTSTORE} ]
    then
        echo "no truststore"
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

#
# we start CENM services up almost in parallel so wait until idman port is open
#
server=$(echo {{ .Values.networkServices.doormanURL }} | sed 's/.*\/\/\(.*\):\(.*\)/\1/' )
port=$(echo {{ .Values.networkServices.doormanURL }} | sed 's/.*\/\/\(.*\):\(.*\)/\2/' )
printf "IdMan server:%s" "${server}"
printf "  IdMan port:%s" "${port}"
timeout 10m bash -c 'until printf "" 2>>/dev/null >>/dev/tcp/$0/$1; do sleep 1; done' ${server} ${port}

# two main reason for endless loop:
#   - repeat in case IdMan is temporarily not available (real life experience ...)
#   - kubernetes monitoring: pod stucks in initContainer which is easy to monitor
while true
do
    if [ ! -f certificates/nodekeystore.jks ] || [ ! -f certificates/sslkeystore.jks ] || [ ! -f certificates/truststore.jks ]
    then
        echo
        echo "Notary: running initial registration ..."
        echo
        pwd
        java -Dcapsule.jvm.args='-Xmx{{ .Values.cordaJarMx }}M' -jar {{ .Values.jarPath }}/corda.jar \
          initial-registration \
        --config-file={{ .Values.configPath }}/notary.conf \
        --log-to-console \
        --network-root-truststore ${NETWORK_ROOT_TRUSTSTORE}  \
        --network-root-truststore-password ${NETWORK_ROOT_TRUSTSTOR_PASSWORD}
        # --logging-level=DEBUG
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
