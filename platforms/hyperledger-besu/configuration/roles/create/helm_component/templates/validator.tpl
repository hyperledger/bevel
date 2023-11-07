apiVersion: helm.toolkit.fluxcd.io/v2beta1
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
    chart: {{ charts_dir }}/besu-validator-node
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    replicaCount: 1

    healthcheck:
      readinessthreshold: 100
      readinesscheckinterval: 5

    staticnodes:
{% for enode in enode_data_list %}
{% if enode.enodeval != '' %}
      - "enode://{{ enode.enodeval }}@{{ enode.peer_name }}.{{ enode.external_url }}:{{ enode.p2p_ambassador }}"
{% endif %}
{% endfor %}

    metadata:
      namespace: {{ component_ns }}
      labels:

    ambassador:
      external_url_suffix: {{ external_url }}

    liveliness_check:
      enabled: false
{% if network.env.proxy == 'ambassador' %}
    proxy:
      provider: ambassador
      external_url: {{ external_url }}
      p2p: {{ peer.p2p.ambassador }}
      rpc: {{ peer.rpc.ambassador | default(80) }}
{% else %}
    proxy:
      provider: none
      external_url: {{ name }}.{{ component_ns }}
      p2p: {{ peer.p2p.port }}
      rpc: {{ peer.rpc.port }}
{% endif %}

    images:
      node: hyperledger/besu:{{ network.version }}
      alpineutils: {{ network.docker.url }}/bevel-alpine:{{ bevel_alpine_version }}
      pullPolicy: IfNotPresent

    node:
      name: {{ peer.name }}
      tls: {{ network.config.tm_tls }}
      consensus: {{ consensus }}
      mountPath: /opt/besu/data
      servicetype: ClusterIP
      imagePullSecret: regcred
      ports:
        p2p: {{ peer.p2p.port }}
        rpc: {{ peer.rpc.port }}
        ws: {{ peer.ws.port }}

      permissioning:
        enabled: {{ network.permissioning.enabled | default(false)}}
      
    storage:
      storageclassname: {{ sc_name }}
      storagesize: 1Gi

    vault:
      address: {{ vault.url }}
      secretengine: {{ vault.secret_path | default('secretsv2') }}
      secretprefix: data/{{ component_ns }}/crypto/{{ peer.name }}
      serviceaccountname: vault-auth
      keyname: data
      tlsdir: tls
      role: vault-role
      authpath: besu{{ name }}
      type: {{ vault.type | default("hashicorp") }}

    genesis: {{ genesis }}

{% if network.env.labels is defined %}   
    labels:  
      service:
{% if network.env.labels.service is defined %}
{% for key in network.env.labels.service.keys() %}
        - {{ key }}: {{ network.env.labels.service[key] | quote }}
{% endfor %}
{% endif %}
      pvc:
{% if network.env.labels.pvc is defined %}
{% for key in network.env.labels.pvc.keys() %}
        - {{ key }}: {{ network.env.labels.pvc[key] | quote }}
{% endfor %}
{% endif %}
      deployment:
{% if network.env.labels.deployment is defined %}
{% for key in network.env.labels.deployment.keys() %}
        - {{ key }}: {{ network.env.labels.deployment[key] | quote }}
{% endfor %}
{% endif %}
{% endif %}

    metrics:
      enabled: {{ peer.metrics.enabled | default(false)}}
      port: {{ peer.metrics.port | default(9545) }}    
