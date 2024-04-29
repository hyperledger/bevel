#!/bin/sh
MIGRATION_ARGS='--core-schemas --app-schemas'

# Wait for networkmap service to be up
timeout 10m bash -c '
    until printf "" 2>>/dev/null >>/dev/tcp/$0/$1; do
        echo "Waiting for Networkmap to be accessible ..."
        sleep 5
    done
    if [ $? -eq 124 ]; then
        echo "Timeout occurred!"
        exit 1  
    fi
' {{ .Values.nodeConf.networkmapDomain }} {{ .Values.nodeConf.networkmapPort }}

#
# main run
#
if [ -f bin/corda.jar ]
then
    echo "running DB migration.."
    echo
    java -jar bin/corda.jar run-migration-scripts $MIGRATION_ARGS -f etc/node.conf 
    echo
    echo "Corda: starting node ..."
    echo
    java -jar bin/corda.jar -f etc/node.conf
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