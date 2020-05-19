apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ peer_name }}-frontend
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  chart:
    path: {{ component_gitops.chart_source }}/frontend
    git: "{{ component_gitops.git_ssh }}"
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
      image: {{ network.docker.url }}/supplychain_frontend:latest
      pullPolicy: Always
      pullSecrets: regcred
{% if network.env.proxy == 'ambassador' %}
      env:
        webserver: https://{{ peer_name }}api.{{ organization_data.external_url_suffix }}:8443
{% else %}
      env:
        webserver: https://{{ peer_name }}api.{{ organization_data.external_url_suffix }}
{% endif %}
    deployment:
      annotations: {}
    proxy:
      provider: {{ network.env.proxy }}
      peer_name: {{ peer_name }}
      external_url_suffix: {{ organization_data.external_url_suffix }}
      ambassador_secret: {{ ambassador_secret }}
