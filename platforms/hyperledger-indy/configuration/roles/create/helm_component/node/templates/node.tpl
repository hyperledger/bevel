apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
   spec:
    chart: {{ gitops.chart_source }}/{{ chart }}
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
    proxy:
      provider: {{ network.env.proxy }}
    network:
      name: {{ network.name }}
    organization:
      name: {{ organizationItem.name }}
    add_new_org: {{ add_new_org | default(false) }}
    image:
      pullSecret: regcred
      pullPolicy: IfNotPresent
      initContainer:
        name: {{ component_name }}-init
        repository: alpine:3.9.4
      cli:
        name: {{ component_name }}-ledger-txn
        repository: {{ network.docker.url }}/bevel-indy-ledger-txn:latest
        pullSecret: regcred
      indyNode:
        name: {{ component_name }}
        repository: {{ network.docker.url }}/bevel-indy-node:{{ network.version }}
    node:
      name: {{ stewardItem.name }}
      ip: 0.0.0.0
      publicIp: {{ stewardItem.publicIp }}
      port: {{ stewardItem.node.port }}
      ambassadorPort: {{ stewardItem.node.ambassador }}
    client:
      publicIp: {{ stewardItem.publicIp }}
      ip: 0.0.0.0
      port: {{ stewardItem.client.port }}
      ambassadorPort: {{ stewardItem.client.ambassador }}
    service:
{% if organizationItem.cloud_provider != 'minikube' %}
      type: ClusterIP
{% else %}
      type: NodePort
{% endif %}
      ports:
        nodePort: {{ stewardItem.node.port }}
        nodeTargetPort: {{ stewardItem.node.targetPort }}
        clientPort: {{ stewardItem.client.port }}
        clientTargetPort: {{ stewardItem.client.targetPort }}
    configmap:
      indyConfig: |-
        NETWORK_NAME = '{{ network.name }}'
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
{% if organizationItem.cloud_provider == 'minikube' and network.env.proxy != 'ambassador' %}
      disabled: true
{% endif %}
    vault:
      address: {{ vault.url }}
      serviceAccountName: {{ organizationItem.name }}-{{ stewardItem.name }}-vault-auth
      keyPath: /keys/{{ network.name }}/keys/{{ stewardItem.name }}
      authPath: kubernetes-{{ organizationItem.name }}-{{ stewardItem.name }}-auth
      nodeId: {{ stewardItem.name }}
      role: ro
    storage:
      data:
        storagesize: 3Gi
        storageClassName: {{ sc_name }}
      keys:
        storagesize: 3Gi
        storageClassName: {{ sc_name }}

