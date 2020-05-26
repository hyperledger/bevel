apiVersion: flux.weave.works/v1beta1
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
    path: {{ charts_dir }}/node_constellation
  values:
    replicaCount: 1
    metadata:
      namespace: {{ component_ns }}
      labels: 
    images:
      node: quorumengineering/quorum:{{ network.version }}
      alpineutils: {{ network.docker.url }}/alpine-utils:1.0
      constellation: quorumengineering/constellation:{{ network.config.tm_version }}
    node:
      name: {{ peer.name }}
{% if add_new_org %}
{% if network.config.consensus == 'raft' %}
      peer_id: {{ peer_id | int }}
{% endif %}
{% endif %}
      status: {{ node_status }}
      consensus: {{ consensus }}
      subject: {{ peer.subject }}
      mountPath: /etc/quorum/qdata
      imagepullsecret: regcred
      keystore: keystore_1
      servicetype: ClusterIP
      lock: {{ peer.lock | lower }}
      ports:
        rpc: {{ peer.rpc.port }}
        raft: {{ peer.raft.port }}
        constellation: {{ peer.transaction_manager.port }}
        quorum: {{ peer.p2p.port }}
    vault:
      address: {{ vault.url }}
      secretprefix: secret/{{ component_ns }}/crypto/{{ peer.name }}
      serviceaccountname: vault-auth
      keyname: quorum
      tm_keyname: transaction
      role: vault-role
      authpath: quorum{{ name }}
    genesis: {{ genesis }}
    staticnodes: 
      {{ staticnodes }}
    constellation:
{% if network.config.tm_tls == 'strict' %}
      url: https://{{ peer.name }}.{{ external_url }}:{{ peer.transaction_manager.ambassador }}/
{% else %}
      url: http://{{ peer.name }}.{{ external_url }}:{{ peer.transaction_manager.ambassador }}/
{% endif %}
      storage: "bdb:/etc/quorum/qdata/database"
      tls: "{{ network.config.tm_tls }}"
      othernodes: {{ network.config.tm_nodes }}
      trust: "{{ network.config.tm_trust }}"
    proxy:
      provider: "ambassador"
      external_url_suffix: {{ external_url }}
      rpcport: {{ peer.rpc.ambassador }}
      quorumport: {{ peer.p2p.ambassador }}
      portConst: {{ peer.transaction_manager.ambassador }}
      portRaft: {{ peer.raft.ambassador }}
    storage:
      storageclassname: {{ storageclass_name }}
      storagesize: 1Gi
