apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name | replace('_','-') }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_name | replace('_','-') }}
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/besu-node
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    global:
      serviceAccountName: vault-auth
      cluster:
        provider: {{ org.cloud_provider }}
        cloudNativeServices: false
      vault:
        type: hashicorp
        network: besu
        address: {{ vault.url }}
        authPath: {{ network.env.type }}{{ name }}
        secretEngine: {{ vault.secret_path | default("secretsv2") }}
        secretPrefix: "data/{{ network.env.type }}{{ name }}"
        role: vault-role
      proxy:
        provider: {{ network.env.proxy }}
        externalUrlSuffix: {{ org.external_url_suffix }}
        p2p: {{ peer.p2p.ambassador }}
    storage:
      enabled: true
      size: "2Gi"
    tessera:
      enabled: false
    tls:
      enabled: false
    image:
{% if network.docker.password is defined %}
      pullSecret: regcred
{% endif %}
      besu:
        repository: hyperledger/besu
        tag: {{ network.version }}
    node:
      removeKeysOnDelete: false
      isBootnode: {{ peer.bootnode | default(false) }}
      usesBootnodes: false
      besu:
        identity: {{ component_name }}
        envBesuOpts: ""
        resources:
          cpuLimit: 0.25
          cpuRequest: 0.05
          memLimit: "1G"
          memRequest: "300M"
        p2p:
          port: {{ peer.p2p.port }}
          discovery: false
        rpc:
          port: {{ peer.rpc.port }}
        ws:
          port: {{ peer.ws.port }}
        metrics:
          enabled: {{ peer.metrics.enabled | default(false) }}
          port: {{ peer.metrics.port | default(9545) }}
          serviceMonitorEnabled: {{ network.prometheus.enabled | default(false) }}
        permissions:
          enabled: {{ network.permissioning.enabled | default(false) }} #Add other permissioning params below this
{% if network.env.labels is defined %}
    labels:
{% if network.env.labels.service is defined %}
      service:
{% for key in network.env.labels.service.keys() %}
        - {{ key }}: {{ network.env.labels.service[key] | quote }}
{% endfor %}
{% endif %}
{% if network.env.labels.pvc is defined %}
      pvc:
{% for key in network.env.labels.pvc.keys() %}
        - {{ key }}: {{ network.env.labels.pvc[key] | quote }}
{% endfor %}
{% endif %}
{% if network.env.labels.deployment is defined %}
      deployment:
{% for key in network.env.labels.deployment.keys() %}
        - {{ key }}: {{ network.env.labels.deployment[key] | quote }}
{% endfor %}
{% endif %}
{% endif %}
