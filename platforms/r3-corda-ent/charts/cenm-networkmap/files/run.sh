#!/bin/sh

#
# main run
#
if [ -f bin/networkmap.jar ]
then
    echo
    echo "CENM: starting Network Map process ..."
    echo
    java -jar bin/angel.jar \
    --jar-name=bin/networkmap.jar \
    --zone-host=zone.{{ .Release.Namespace }} \
    --zone-port={{ .Values.global.cenm.zone.enmPort }} \
    --token=${TOKEN} \
    --service=NETWORK_MAP \
    --polling-interval=10 \
    --working-dir=/opt/cenm/etc/ \
    --network-truststore=/certs/network-root-truststore.jks \
    --truststore-password={{ .Values.global.cenm.sharedCreds.truststore }} \
    --root-alias=cordarootca \
    --network-parameters-file=/opt/cenm/notary-nodeinfo/network-parameters-initial.conf \
    --tls=true \
    --tls-keystore=/certs/corda-ssl-network-map-keys.jks \
    --tls-keystore-password={{ .Values.global.cenm.sharedCreds.keystore }} \
    --tls-truststore=/certs/corda-ssl-trust-store.jks \
    --tls-truststore-password={{ .Values.global.cenm.sharedCreds.truststore }} \
    --verbose
    EXIT_CODE=${?}
else
    echo "Missing Network Map jar file in bin/ directory:"
    ls -al bin
    EXIT_CODE=110
fi

if [ "${EXIT_CODE}" -ne "0" ]
then
    HOW_LONG={{ .Values.sleepTimeAfterError }}
    echo
    echo "Network Map failed - exit code: ${EXIT_CODE} (error)"
    echo
    echo "Going to sleep for requested 120 seconds to let you login and investigate."
    echo
fi

sleep ${HOW_LONG}
echo
