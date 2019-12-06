apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  annotations:
    flux.weave.works/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}
  chart:
    path: {{ gitops.chart_source }}/{{ chart }}
    git: {{ gitops.git_ssh }}
    ref: {{ gitops.branch }}
  values:
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
    network:
      name: {{ network.name }}
    organization:
      name: {{ organizationItem.name }}
    image:
      imagePullSecret: regcred
      initContainer:
        name: {{ component_name }}-init
        repository: alpine:3.9.4
      indyNode:
        name: {{ component_name }}
        repository: {{ network.docker.url }}/indy-node:0.3.0.0
    node:
      name: {{ component_name }}
      ip: {{ stewardItem.publicIp }}
      port: {{ stewardItem.node.port }}
    client:
      ip: {{ stewardItem.publicIp }}
      port: {{ stewardItem.client.port }}
    service:
      ports:
        nodePort: {{ stewardItem.node.port }}
        nodeTargetPort: {{ stewardItem.client.targetPort }}
        clientPort: {{ stewardItem.client.port }}
        clientTargetPort: {{ stewardItem.node.targetPort }}
    configmap:
      poolGenesis: {{ organizationItem.name }}-pool-transactions-genesis
      indyConfig: |-
        NETWORK_NAME = {{ network.name }}
        # Enable stdout logging
        enableStdOutLogging = True
        logRotationBackupCount = 10
        # Directory to store ledger.
        LEDGER_DIR = '/var/lib/indy/data'
        # Directory to store logs.
        LOG_DIR = '/var/log/indy'
        # Directory to store keys.
        KEYS_DIR = '/var/lib/indy/keys'
        # Directory to store genesis transactions files.
        GENESIS_DIR = '/var/lib/indy/genesis'
        # Directory to store backups.
        BACKUP_DIR = '/var/lib/indy/backup'
        # Directory to store plugins.
        PLUGINS_DIR = '/var/lib/indy/plugins'
        # Directory to store node info.
        NODE_INFO_DIR = '/var/lib/indy/data'
    ambassador:
      annotations: |-
        apiVersion: ambassador/v1
        kind: TCPMapping
        name: {{ component_name|e }}-node-mapping
        port: {{ stewardItem.node.ambassador }}
        service: {{ component_name|e }}.{{ component_ns }}:{{ stewardItem.node.targetPort }}
        apiVersion: ambassador/v1
        kind: TCPMapping
        name: {{ component_name|e }}-client-mapping
        port: {{ stewardItem.client.ambassador }}
        service: {{ component_name|e }}.{{ component_ns }}:{{ stewardItem.client.targetPort }}
    vault:
      address: {{ vault.url }}
      serviceAccountName: {{ component_name }}-vault-auth
      keyPath: /keys/{{ network.name }}/keys/{{ component_name }}
      nodeId: {{ component_name }}
    storage:
      data:
        storagesize: 1Gi
        storageClassName: {{ organizationItem.name }}-{{ organizationItem.cloud_provider }}-storageclass
      keys:
        storagesize: 1Gi
        storageClassName: {{ organizationItem.name }}-{{ organizationItem.cloud_provider }}-storageclass
