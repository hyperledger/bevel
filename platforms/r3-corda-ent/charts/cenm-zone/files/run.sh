#!/bin/sh

#
# main run
#
if [ -f {{ .Values.config.zoneJar.path }}/zone.jar ]
then
    echo
    echo "CENM: starting up zone process ..."
    echo
    set -x
    java -jar {{ .Values.config.zoneJar.path }}/zone.jar \
    --user "{{ .Values.database.user }}" \
    --password "{{ .Values.database.password }}" \
    --url "{{ .Values.database.url }}" \
    --driver-class-name "{{ .Values.database.driverClassName }}" \
    --jdbc-driver "{{ .Values.database.jdbcDriver }}" \
    --enm-listener-port "{{ .Values.listenerPort.enm }}" \
    --admin-listener-port "{{ .Values.listenerPort.admin }}" \
    --auth-host "{{ .Values.cenmServices.authName }}.{{ .Values.metadata.namespace }}" \
    --auth-port "{{ .Values.cenmServices.authPort }}" \
    --auth-trust-store-location ./DATA/trust-stores/corda-ssl-trust-store.jks \
    --auth-trust-store-password "SSL_TRUSTSTORE" \
    --auth-issuer "http://test" \
    --auth-leeway 5 \
    --run-migration="{{ .Values.database.runMigration }}" \
    --tls=true \
    --tls-keystore=./DATA/key-stores/corda-ssl-identity-manager-keys.jks \
    --tls-keystore-password="IDMAN_SSL" \
    --tls-truststore=./DATA/trust-stores/corda-ssl-trust-store.jks \
    --tls-truststore-password="SSL_TRUSTSTORE" \
    --verbose
    EXIT_CODE=${?}
else
    echo "Missing zone jar file in {{ .Values.config.zoneJar.path }} directory:"
    ls -al {{ .Values.config.zoneJar.path }}
    EXIT_CODE=110
fi
