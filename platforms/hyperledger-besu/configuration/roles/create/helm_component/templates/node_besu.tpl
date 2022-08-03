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
    chart: {{ charts_dir }}/node_besu
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      namespace: {{ component_ns }}
      labels:
    replicaCount: 1
    staticnodes:
{% for enode in enode_data_list %}
      - "enode://{{ enode.enodeval }}@{{ enode.peer_name }}.{{ enode.external_url }}:{{ enode.p2p_ambassador }}"
{% endfor %}

    liveliness_check:
      enabled: false
    healthcheck:
      readinessthreshold: 100
      readinesscheckinterval: 5
{% if network.env.proxy == 'ambassador' %}
    proxy:
      provider: ambassador
      external_url: {{ name }}.{{ external_url }}
      p2p: {{ peer.p2p.ambassador }}
      rpc: {{ peer.rpc.ambassador }}
{% else %}
    proxy:
      provider: none
      external_url: {{ name }}.{{ component_ns }}
      p2p: {{ peer.p2p.port }}
      rpc: {{ peer.rpc.port }}
{% endif %}

    images:
      node: hyperledger/besu:{{ network.version }}
      alpineutils: {{ network.docker.url }}/alpine-utils:1.0
      pullPolicy: IfNotPresent

    node:
      name: {{ peer.name }}
      consensus: {{ consensus }}
      subject: {{ peer.subject }}
      mountPath: /opt/besu/data
      servicetype: ClusterIP
      imagePullSecret: regcred
      ports:
        p2p: {{ peer.p2p.port }}
        rpc: {{ peer.rpc.port }}
        ws: {{ peer.ws.port }}

    tm:
      type: {{ network.config.transaction_manager }}
      tls: {{ network.config.tm_tls }}
{% if network.config.tm_tls %}
      url: "https://{{ peer.name }}-tessera.{{ component_ns }}:{{ peer.tm_clientport.port }}"
{% else %}
      url: "http://{{ peer.name }}-tessera.{{ component_ns }}:{{ peer.tm_clientport.port }}"
{% endif %}

    storage:
      storageclassname: {{ storageclass_name }}
      storagesize: 1Gi

    vault:
      address: {{ vault.url }}
      secretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}/crypto/{{ peer.name }}
      serviceaccountname: vault-auth
      keyname: data
      tmdir: tm
      tlsdir: tls
      role: vault-role
      authpath: besu{{ name }}

    genesis: {{ genesis }}
