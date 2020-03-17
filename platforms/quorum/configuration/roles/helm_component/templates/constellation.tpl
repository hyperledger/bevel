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
      node: quorumengineering/quorum:2.1.1
      alpineutils: adopblockchaincloud0502.azurecr.io/alpine-utils:1.0
      constellation: quorumengineering/constellation:0.3.2
    node:
      name: {{ peer.name }}
      consensus: {{ consensus }}
      mountPath: /etc/quorum/qdata
      imagepullsecret: regcred
      keystore: keystore_1
      servicetype: ClusterIP
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
{% if network.config.consensus == 'ibft' %}
{% for enode in enode_data_list %}
      - enode://{{ enode.enodeval }}@{{ enode.peer_name }}.{{ external_url }}:{{ enode.p2p_ambassador }}?discport=0
{% endfor %}
{% endif %}
{% if network.config.consensus == 'raft' %}
{% for enode in enode_data_list %}
      - enode://{{ enode.enodeval }}@{{ enode.peer_name }}.{{ external_url }}:{{ enode.p2p_ambassador }}?discport=0&raftport={{ enode.raft_ambassador }}
{% endfor %}
{% endif %}
    constellation:
      url: {{ network.config.tm_nodes }}
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
