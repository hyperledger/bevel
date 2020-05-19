apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ peer_name }}-expressapi
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  chart:
    path: {{ component_gitops.chart_source }}/expressapp
    git: "{{ component_gitops.git_ssh }}"
    ref: "{{ component_gitops.branch }}"
  releaseName: {{ peer_name }}{{ network.type }}-expressapi
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
