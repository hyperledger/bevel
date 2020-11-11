apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ org.gitops.git_ssh }}
    ref: {{ org.gitops.branch }}
    path: {{ charts_dir }}/h2
  values:
    nodeName: {{ node_name }}
    metadata:
      namespace: {{ component_ns }}
    replicaCount: 1
    image:
      containerName: {{ container_name }}
      imagePullSecret: regcred
    resources:
      limits: 512Mi
      requests: 512Mi
    storage:
      name: "cordaentsc"
      memory: 512Mi
    service:
      type: NodePort
      tcp:
        port: {{ tcp_port}}
        targetPort: {{ tcp_targetport }}
      web:
        targetPort: {{ web_targetport }}
        port: {{ web_port }}
    deployment:
      annotations: {}
    pvc:
      annotations: {}
