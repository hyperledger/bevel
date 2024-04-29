#!/bin/sh

#
# main run
#
if [ -f /opt/cenm/bin/accounts-application.jar ]
then
    echo
    echo "CENM: starting CENM Auth service ..."
    echo
    java -jar /opt/cenm/bin/accounts-application.jar \
            --config-file authservice.conf \
            --initial-user-name {{ .Values.creds.authInitUserName }} \
            --initial-user-password {{ .Values.creds.authInitUserPassword }} \
            --keep-running --verbose
    EXIT_CODE=${?}
else
    echo "Missing Auth service jar file."
    EXIT_CODE=110
fi

if [ "${EXIT_CODE}" -ne "0" ]
then
    HOW_LONG={{ .Values.sleepTimeAfterError }}
    echo
    echo "Auth service failed - exit code: ${EXIT_CODE} (error)"
    echo
    echo "Going to sleep for the requested {{ .Values.sleepTimeAfterError }} seconds to let you log in and investigate."
    sleep {{ .Values.sleepTimeAfterError }}
    echo
fi

sleep ${HOW_LONG}
echo
