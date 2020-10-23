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
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/h2
  values:
    nodeName: {{ node_name }}
    metadata:
      namespace: {{ component_ns }}
    replicaCount: 1
    image:
      containerName: {{ container_name }}
      imagePullSecret: {{ image_pull_secret }}
    resources:
      limits: 512Mi
      requests: 512Mi
    storage:
      name: {{ storageclass }}
      memory: 512Mi
    service:
      type: NodePort
      tcp:
        port: {{ tcp_port }}
        targetPort: {{ tcp_targetport }}
      web:
        targetPort: {{ web_targetport }}
        port: {{ web_port }}
    deployment:
      annotations: {}
    pvc:
      annotations: {}
