apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ peer_name }}-expressapi
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  chart:
    spec:
      chart: {{ component_gitops.chart_source }}/expressapp
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
  releaseName: {{ peer_name }}{{ network.type }}-expressapi
  interval: 1m
  values:
    nodeName: {{ peer_name }}-expressapi
    metadata:
      namespace: {{ component_ns }}
    replicaCount: 1
    expressapp:
      serviceType: ClusterIP
      image: {{ network.docker.url }}/{{ expressapi_image }}
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
      type: corda
      external_url_suffix: {{ organization_data.external_url_suffix }}
      peer_name: {{ peer_name }}
