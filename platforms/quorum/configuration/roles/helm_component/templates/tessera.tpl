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
    chart: {{ charts_dir }}/quorum-tessera-node
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
      alpineutils: ghcr.io/hyperledger/bevel-alpine:latest
      tessera: quorumengineering/tessera:hashicorp-{{ network.config.tm_version }}
      busybox: busybox
      mysql: mysql/mysql-server:5.7
      pullPolicy: IfNotPresent
    node:
      name: {{ peer.name }}
      mountPath: /etc/quorum/qdata
      imagePullSecret: regcred
{% if org.cloud_provider == 'minikube' %}
      servicetype: NodePort
{% else %}
      servicetype: ClusterIP
{% endif %}
      ports:
        tm: {{ peer.transaction_manager.port }}
        db: {{ peer.db.port }}
      dbname: demodb
      mysqluser: demouser
    vault:
      address: {{ vault.url }}
      secretengine: {{ vault.secret_path | default('secretsv2') }}
      tmsecretpath: {{ component_ns }}/crypto/{{ peer.name }}/tm
      secretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}/crypto/{{ peer.name }}
      serviceaccountname: vault-auth
      keyname: quorum
      role: vault-role
      authpath: quorum{{ name }}
      type: {{ vault.type | default("hashicorp") }}
    tessera:
      dburl: "jdbc:mysql://{{ peer.name }}-tessera:3306/demodb"
      dbusername: demouser
{% if network.config.tm_tls == 'strict' %}
      url: "https://{{ peer.name }}.{{ external_url }}:{{ peer.transaction_manager.ambassador }}"
{% else %}
      url: "http://{{ peer.name }}.{{ external_url }}:{{ peer.transaction_manager.ambassador }}"
{% endif %}
      clienturl: "http://{{ peer.name }}-tessera:{{ peer.transaction_manager.clientport }}" #TODO: Enable tls strict for q2t
      othernodes:
{% for tm_node in network.config.tm_nodes %}
        - url: {{ tm_node }}
{% endfor %}
      tls: "{{ network.config.tm_tls | upper }}"
      trust: "{{ network.config.tm_trust | upper }}"
{% if network.env.proxy == 'ambassador' %}
    proxy:
      provider: "ambassador"
      external_url: {{ name }}.{{ external_url }}
      clientport: {{ peer.transaction_manager.clientport }}
{% else %}
    proxy:
      provider: "none"
      external_url: {{ name }}.{{ component_ns }}
      clientport: {{ peer.transaction_manager.clientport }}
{% endif %}
    storage:
      storageclassname: {{ sc_name }}
      storagesize: 1Gi
      dbstorage: 1Gi
