#!/bin/sh
{{ if eq .Values.bashDebug true }}
set -x
pwd
cat -n etc/notary.conf
{{ end }}

# For now, we are using a 'hardcoded' nodeInfo filename, to avoid having to save the hash in Vault
envsubst <<"EOF" > additional-node-infos/network-parameters-initial.conf.tmp
notaries : [
  {
    notaryNodeInfoFile: "notary-nodeinfo/notary_nodeinfo"
    validating = "{{ .Values.notary.validating }}"
  }
]
minimumPlatformVersion = 1
maxMessageSize = 10485760
maxTransactionSize = 10485760
eventHorizonDays = 1
EOF

mv additional-node-infos/network-parameters-initial.conf.tmp additional-node-infos/network-parameters-initial.conf
cat additional-node-infos/network-parameters-initial.conf
echo
