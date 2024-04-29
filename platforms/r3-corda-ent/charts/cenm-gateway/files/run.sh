#!/bin/sh

#
# main run
#
if [ -f /opt/cenm/bin/gateway.jar ]
then
    echo
    echo "CENM: starting CENM Gateway service ..."
    echo
    java -jar /opt/cenm/bin/gateway.jar --config-file gateway.conf
    EXIT_CODE=${?}
else
    echo "Missing gateway service jar file."
    EXIT_CODE=110
fi

if [ "${EXIT_CODE}" -ne "0" ]
then
    HOW_LONG={{ .Values.sleepTimeAfterError }}
    echo
    echo "Gateway service failed - exit code: ${EXIT_CODE} (error)"
    echo
    echo "Going to sleep for requested ${HOW_LONG} seconds to let you login and investigate."
    echo
fi

sleep ${HOW_LONG}
echo
