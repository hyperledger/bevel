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
      INDY_NODE_IP: {{ stewardItem.node.port }}
      INDY_CLIENT_IP: {{ stewardItem.client.port }}
      ports:
        indyNodePort: {{ stewardItem.node.port }}
        indyClientPort: {{ stewardItem.client.port }}
    service:
      ports:
        nodePort: {{ stewardItem.node.port }}
        nodeTargetPort: {{ stewardItem.client.targetPort }}
        clientPort: {{ stewardItem.client.port }}
        clientTargetPort:: {{ stewardItem.node.targetPort }}
    configmap:
      domainGenesis: {{ domainGenesis }}
      poolGenesis: {{ poolGenesis }}
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
        storagesize: 512Mi
        storageClassName: {{ organizationItem.cloud_provider }}storageclass
      keys:
        storagesize: 512Mi
        storageClassName: {{ organizationItem.cloud_provider }}storageclass
        