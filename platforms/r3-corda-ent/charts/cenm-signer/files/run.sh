#!/bin/sh

#
# main run
#

if [ -f bin/signer.jar ]
then
    echo
    echo "CENM: starting Signer process ..."
    echo
    java -Xmx1G -jar bin/signer.jar --config-file etc/signer.conf
    EXIT_CODE=${?}
else
    echo "Missing Signer jar file in bin directory:"
    ls -al bin
    EXIT_CODE=110
fi

if [ "${EXIT_CODE}" -ne "0" ]
then
    HOW_LONG={{ .Values.sleepTimeAfterError }}
    echo
    echo "Signer failed - exit code: ${EXIT_CODE} (error)"
    echo
    echo "Going to sleep for requested ${HOW_LONG} seconds to let you login and investigate."
    echo
fi

sleep ${HOW_LONG}
echo
