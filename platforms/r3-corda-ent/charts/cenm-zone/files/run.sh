#!/bin/sh

#
# main run
#
if [ -f {{ .Values.jarPath }}/zone.jar ]
then
    echo
    echo "CENM: starting up zone process ..."
    echo
    set -x
    java -jar {{ .Values.jarPath }}/zone.jar \
    --user "{{ .Values.database.user }}" \
    --password "{{ .Values.database.password }}" \
    --url "{{ .Values.database.url }}" \
    --driver-class-name "{{ .Values.database.driverClassName }}" \
    --jdbc-driver "{{ .Values.database.jdbcDriver }}" \
    --enm-listener-port "{{ .Values.global.cenm.zone.enmPort }}" \
    --admin-listener-port "{{ .Values.global.cenm.zone.adminPort }}" \
    --auth-host "auth.{{ .Release.Namespace }}" \
    --auth-port "{{ .Values.global.cenm.auth.port }}" \
    --auth-trust-store-location /certs/corda-ssl-trust-store.jks \
    --auth-trust-store-password {{ .Values.global.cenm.sharedCreds.truststore }} \
    --auth-issuer "http://test" \
    --auth-leeway 5 \
    --run-migration="{{ .Values.database.runMigration }}" \
    --tls=true \
    --tls-keystore=/certs/corda-ssl-identity-manager-keys.jks \
    --tls-keystore-password="{{ .Values.global.cenm.sharedCreds.keystore }}" \
    --tls-truststore=/certs/corda-ssl-trust-store.jks \
    --tls-truststore-password="{{ .Values.global.cenm.sharedCreds.truststore }}" \
    --verbose
    EXIT_CODE=${?}
else
    echo "Missing zone jar file in {{ .Values.jarPath }} directory:"
    ls -al {{ .Values.jarPath }}
    EXIT_CODE=110
fi
