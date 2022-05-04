apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ peer_name }}-frontend
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  chart:
    path: {{ component_gitops.chart_source }}/frontend
    git: "{{ component_gitops.git_url }}"
    ref: "{{ component_gitops.branch }}"
  releaseName: {{ peer_name }}{{ network.type }}-frontend
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
      image: {{ network.container_registry.url | lower }}/bevel-supplychain-frontend:latest
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
