#!/bin/sh
{{ if eq .Values.bashDebug true }}
set -x
pwd
cat -n etc/notary.conf
{{ end }}

# we need just the filename without full path as this is going to be mounted under different folder in NM
nodeInfoFile=$(basename $(ls additional-node-infos/nodeInfo*))
export nodeInfoFile
echo ${nodeInfoFile}

envsubst <<"EOF" > additional-node-infos/network-parameters-initial.conf.tmp
notaries : [
  {
    notaryNodeInfoFile: "notary-nodeinfo/${nodeInfoFile}"
    validating = true
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
