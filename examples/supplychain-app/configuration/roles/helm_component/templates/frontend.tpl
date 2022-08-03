apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ peer_name }}-frontend
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ peer_name }}{{ network.type }}-frontend
  interval: 1m
  chart:
   spec:
    chart: {{ component_gitops.chart_source }}/frontend
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    nodeName: {{ peer_name }}-frontend
    metadata:
      namespace: {{ component_ns }}
    replicaCount: 1
    frontend:
      serviceType: ClusterIP
      nodePorts:
        port: {{ peer_frontend_port }}
        targetPort: {{ peer_frontend_targetport }}
      image: {{ network.docker.url }}/bevel-supplychain-frontend:stable
      pullPolicy: Always
      pullSecrets: regcred
      env:
        webserver: https://{{ peer_name }}api.{{ organization_data.external_url_suffix }}
    deployment:
      annotations: {}
    proxy:
      provider: {{ network.env.proxy }}
      peer_name: {{ peer_name }}
      external_url_suffix: {{ organization_data.external_url_suffix }}
      ambassador_secret: {{ ambassador_secret }}
