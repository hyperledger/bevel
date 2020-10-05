apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}db
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}db
  chart:
    path: {{ gitops.chart_source }}/h2
    git: {{ gitops.git_ssh }}
    ref: {{ gitops.branch }}
  values:
    replicaCount: 1
    nodeName: {{ component_name }}
    metadata:
      namespace: {{ component_ns }}
    image:
      containerName: {{ network.docker.url }}/h2:2018
      imagePullSecret: regcred
    resources:
      limits: "512Mi"
      requests: "512Mi"
    storage:
      memory: 512Mi
      mountPath: "/opt/h2-data"
      name: {{ item.cloud_provider }}storageclass
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