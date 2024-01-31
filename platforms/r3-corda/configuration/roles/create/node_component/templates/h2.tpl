apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}db
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}db
  interval: 1m
  chart:
    spec:
      chart: {{ gitops.chart_source }}/corda-h2
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
  values:
    replicaCount: 1
    nodeName: {{ component_name }}
    metadata:
      namespace: {{ component_ns }}
    image:
      containerName: {{ network.docker.url }}/h2:2018
{% if network.docker.username is defined %}
      imagePullSecret: regcred
{% endif %}
    resources:
      limits: "512Mi"
      requests: "512Mi"
    storage:
      memory: 512Mi
      mountPath: "/opt/h2-data"
      name: {{ sc_name }}
    service:
      type: NodePort
      p2p:
        port: {{ node.p2p.port|e }}
      rpc:
        port: {{ node.rpc.port|e }}
      rpcadmin:
        port: {{ node.rpcadmin.port|e }}
      tcp:
        port: {{ node.dbtcp.port|e }}
        targetPort: {{ node.dbtcp.targetPort|e }}
      web:
        targetPort: {{ node.dbweb.targetPort|e }}
        port: {{ node.dbweb.port|e }}
      annotations: {}
    deployment:
      annotations: {}
    pvc:
      annotations: {}
