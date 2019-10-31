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
      name: {{ organizationItem.organization }}
    image:
      imagePullSecret: regcred
      initContainer:
        name: {{ component_name }}-init
        repository: alpine:3.9.4
      indyNode:
        name: {{ component_name }}
        repository: {{ network.docker.url }}
    node:
      name: {{ component_name }}
      INDY_NODE_IP: {{ organizationItem.stewardItem.node.port }}
      INDY_CLIENT_IP: {{ organizationItem.stewardItem.client.port }}
      ports:
        indyNodePort: {{ organizationItem.stewardItem.node.port }}
        indyClientPort: {{ organizationItem.stewardItem.client.port }}
    service:
      ports:
        nodePort: {{ organizationItem.stewardItem.node.port }}
        nodeTargetPort: {{ organizationItem.stewardItem.client.targetPort }}
        clientPort: {{ organizationItem.stewardItem.client.port }}
        clientTargetPort:: {{ organizationItem.stewardItem.node.targetPort }}
    configmap:
      domainGenesis: {{ domainGenesis }}
      poolGenesis: {{ poolGenesis }}
    ambassador:
      annotations: |-
        apiVersion: ambassador/v1
        kind: TCPMapping
        name: {{ component_name|e }}-node-mapping
        port: {{ organizationItem.stewardItem.node.ambassador }}
        service: {{ component_name|e }}.{{ component_ns }}:{{ organizationItem.stewardItem.node.targetPort }}
        apiVersion: ambassador/v1
        kind: TCPMapping
        name: {{ component_name|e }}-client-mapping
        port: {{ organizationItem.stewardItem.client.ambassador }}
        service: {{ component_name|e }}.{{ component_ns }}:{{ organizationItem.stewardItem.client.targetPort }}
    vault:
      address: {{ vault.url }}
      serviceAccountName: {{ component_name }}-vault-auth
      keyPath: /keys/{{ network.name }}/keys/{{ component_name }}
      nodeId: {{ component_name }}
    storage:
      keys:
        storagesize: 1Gi
        storageClassName: {{ organizationItem.cloud_provider }}storageclass
