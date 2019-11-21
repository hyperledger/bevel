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
  releaseName: {{ peer_name }}-frontend
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
      env:
        webserver: https://{{ peer_name }}api.{{ organization_data.external_url_suffix }}:8443
    deployment:
      annotations: {}
    ambassador:
      annotations: |-
        ---
        apiVersion: ambassador/v1
        kind: TLSContext
        name: {{ peer_name }}_web_context
        hosts:
        - {{ peer_name }}web.{{ organization_data.external_url_suffix }}
        secret: {{ ambassador_secret }}
        ---
        apiVersion: ambassador/v1
        kind: Mapping
        name: {{ peer_name }}_web_p2p_mapping
        prefix: /
        host: {{ peer_name }}web.{{ organization_data.external_url_suffix }}:8443
        service: {{ peer_name }}-frontend.{{ component_ns }}:{{ peer_frontend_port }}
        tls: false 