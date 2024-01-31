apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ name }}-cactus
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ name }}-cactus
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/besu-cacti-connector
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      namespace: {{ component_ns }}
      labels:
    replicaCount: 1
    images:
      repository: ghcr.io/hyperledger/cactus-cmd-api-server:1.1.3
    plugins:
      besuNode: {{ member.name }}
      instanceId: 12345678
      rpcApiHttpHost: http://{{ member.name }}.{{ component_ns }}:{{ member.rpc.port }}
      rpcApiWsHost: ws://{{ member.name }}.{{ component_ns }}:{{ member.ws.port }}      
    envs:
      authorizationProtocol: "NONE"
      authorizationConfigJson: "{}"
      grpcTlsEnabled: "false"
    proxy:
      provider: {{ network.env.proxy }}
      external_url: {{ item.external_url_suffix }}
