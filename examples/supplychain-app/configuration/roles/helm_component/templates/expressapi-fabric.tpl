apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ name }}-expressapi
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  chart:
   spec:
    chart: {{ component_gitops.chart_source }}/expressapp
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  releaseName: {{ name }}{{ network.type }}-expressapi
  values:
    nodeName: {{ name }}-expressapi
    metadata:
      namespace: {{ component_ns }}
    replicaCount: 1
    expressapp:
      serviceType: ClusterIP
      image: {{ expressapi_image }}
      pullPolicy: Always
      pullSecrets: regcred
      nodePorts:
        port: {{ peer_expressapi_port }}
        targetPort: {{ peer_expressapi_targetport }}
        name: tcp
      env:
        apiUrl: {{ url }}:{{ peer_restserver_port }}/api/v1
    proxy:
      provider: {{ network.env.proxy }}
      name: {{ name }}
      type: fabric
      external_url_suffix: {{ organization_data.external_url_suffix }}
      peer_name: {{ peer_name }}
