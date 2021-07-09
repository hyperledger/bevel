apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_name }}
  helmVersion: v3
  chart:
    git: {{ gitops.git_url }}
    ref: {{ gitops.branch }}
    path: {{ charts_dir }}/node_tessera  
  values:
    replicaCount: 1
    metadata:
      namespace: {{ component_ns }}
      labels:
    images:      
      alpineutils: {{ network.docker.url }}/alpine-utils:1.0
      tessera: quorumengineering/tessera:{{ network.config.tm_version }}
      busybox: busybox
      mysql: mysql/mysql-server:5.7
      imagePullSecret: regcred
    tessera:
      name: {{ peer.name }}-tessera
      dbname: demodb      
      dburl: "jdbc:mysql://{{ peer.name }}-tessera:3306/demodb"
      dbusername: demouser
{% if network.config.tm_tls %}
      tls: "STRICT"
      url: "https://{{ peer.name }}.{{ external_url }}:{{ peer.tm_nodeport.ambassador }}"      
      clienturl: "https://{{ peer.name }}-tessera:{{ peer.tm_clientport.port }}"
{% else %}
      tls: "OFF"
      url: "http://{{ peer.name }}.{{ external_url }}:{{ peer.tm_nodeport.ambassador }}"
      clienturl: "http://{{ peer.name }}-tessera:{{ peer.tm_clientport.port }}"
{% endif %}
      othernodes:
{% for tm_node in network.config.tm_nodes %}
        - url: {{ tm_node }}
{% endfor %}
{% if network.config.tm_trust == 'ca-or-tofu' %}
      trust: "CA_OR_TOFU"
{% else %}
      trust: "{{ network.config.tm_trust | upper }}"
{% endif %}
      
{% if org.cloud_provider == 'minikube' %}     
      servicetype: NodePort
{% else %}      
      servicetype: ClusterIP
{% endif %}
      ports:
        tm: {{ peer.tm_nodeport.port }}        
        db: {{ peer.db.port }}
        client: {{ peer.tm_clientport.port }}
      mountPath: /etc/tessera/data
      ambassadorSecret: {{ peer.name }}-ambassador-certs
    vault:
      address: {{ vault.url }}
      secretprefix: {{ vault.secret_path | default('secret') }}/data/{{ component_ns }}/crypto/{{ peer.name }}
      serviceaccountname: vault-auth
      keyname: credentials
      tm_keyname: tm
      tlsdir: tls
      role: vault-role
      authpath: besu{{ org.name | lower }}
    
    proxy:
      provider: "ambassador"
      external_url: {{ peer.name }}.{{ external_url }}
      portTM: {{ peer.tm_nodeport.ambassador }}      
    storage:
      storageclassname: {{ storageclass_name }}
      storagesize: 1Gi
      dbstorage: 1Gi
