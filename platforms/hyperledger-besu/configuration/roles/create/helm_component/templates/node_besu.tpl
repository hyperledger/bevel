apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/node_besu
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

    proxy:
      provider: ambassador
      external_url: {{ name }}.{{ external_url }}
      p2p: {{ peer.p2p.ambassador }}
      rpc: {{ peer.rpc.ambassador }}      

    images:
      node: hyperledger/besu:{{ network.version }}
      alpineutils: hyperledgerlabs/alpine-utils:1.0     

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
      secretprefix: {{ vault.secret_path | default('secret') }}/data/{{ component_ns }}/crypto/{{ peer.name }}
      serviceaccountname: vault-auth
      keyname: data
      tmdir: tm
      tlsdir: tls
      role: vault-role
      authpath: besu{{ name }}

    genesis: {{ genesis }}
