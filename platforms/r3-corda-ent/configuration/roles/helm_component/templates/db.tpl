apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/corda-ent-h2
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    nodeName: {{ node_name }}
    metadata:
      namespace: {{ component_ns }}
    replicaCount: 1
    image:
      containerName: {{ container_name }}
      imagePullSecret: regcred
      pullPolicy: IfNotPresent
    resources:
      limits: 512Mi
      requests: 512Mi
    storage:
      name: {{ sc_name }}
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
