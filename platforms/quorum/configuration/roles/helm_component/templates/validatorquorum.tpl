apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/node_quorum_validator
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    replicaCount: 1
    metadata:
      namespace: {{ component_ns }}
      labels:
    images:
      node: quorumengineering/quorum:{{ network.version }}
      alpineutils: {{ network.docker.url }}/alpine-utils:1.0
      busybox: busybox
      mysql: mysql/mysql-server:5.7
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
      imagePullSecret: regcred
      keystore: keystore_1
{% if item.cloud_provider == 'minikube' %}
      servicetype: NodePort
{% else %}
      servicetype: ClusterIP
{% endif %}
      lock: {{ peer.lock | lower }}
      ports:
        rpc: {{ peer.rpc.port }}
{% if network.config.consensus == 'raft' %}
        raft: {{ peer.raft.port }}
{% endif %}
        quorum: {{ peer.p2p.port }}
        db: {{ peer.db.port }}
      dbname: demodb
      mysqluser: demouser
    vault:
      address: {{ vault.url }}
      secretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}/crypto/{{ peer.name }}
      serviceaccountname: vault-auth
      keyname: quorum
      role: vault-role
      authpath: quorum{{ name }}
    genesis: {{ genesis }}
    staticnodes: {{ staticnodes }}
    proxy:
      provider: "ambassador"
      external_url: {{ peer.name }}.{{ external_url }}
      rpcport: {{ peer.rpc.ambassador }}
      quorumport: {{ peer.p2p.ambassador }}
{% if network.config.consensus == 'raft' %}
      portRaft: {{ peer.raft.ambassador }}
{% endif %}
    storage:
      storageclassname: {{ storageclass_name }}
      storagesize: 1Gi
      dbstorage: 1Gi
