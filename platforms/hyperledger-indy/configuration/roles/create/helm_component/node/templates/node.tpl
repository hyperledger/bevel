apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  annotations:
    fluxcd.io/automated: "false"
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
      pullSecret: regcred
      initContainer:
        name: {{ component_name }}-init
        repository: alpine:3.9.4
      indyNode:
        name: {{ component_name }}
        repository: {{ network.docker.url }}/indy-node:{{ network.version }}
    node:
      name: {{ stewardItem.name }}
      ip: 0.0.0.0
      port: {{ stewardItem.node.port }}
    client:
      ip: 0.0.0.0
      port: {{ stewardItem.client.port }}
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
{% if organizationItem.cloud_provider != 'minikube' and network.env.proxy == 'ambassador' %}
      annotations: |-
        ---
        apiVersion: ambassador/v1
        kind: TCPMapping
        name: {{ component_name|e }}-node-mapping
        port: {{ stewardItem.node.ambassador }}
        service: {{ component_name|e }}.{{ component_ns }}:{{ stewardItem.node.targetPort }}
        ---
        apiVersion: ambassador/v1
        kind: TCPMapping
        name: {{ component_name|e }}-client-mapping
        port: {{ stewardItem.client.ambassador }}
        service: {{ component_name|e }}.{{ component_ns }}:{{ stewardItem.client.targetPort }}
{% else %}
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
        storagesize: 512Mi
        storageClassName: {{ organizationItem.name }}-{{ organizationItem.cloud_provider }}-storageclass
      keys:
        storagesize: 512Mi
        storageClassName: {{ organizationItem.name }}-{{ organizationItem.cloud_provider }}-storageclass
