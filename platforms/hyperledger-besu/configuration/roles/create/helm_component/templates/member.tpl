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
        tmport: {{ peer.tm_nodeport.ambassador | default(443) }}
    storage:
      size: "2Gi"
    tessera:
{% if network.config.transaction_manager == 'tessera' %}
      enabled: true
{% else %}
      enabled: false
{% endif %}
      storage:
        enabled: false
        size: 1Gi
        dbSize: 2Gi
        allowedTopologies:
          enabled: false
      image:  
        tessera: 
          repository: quorumengineering/tessera
          tag: {{ network.config.tm_version | default("22.1.7")}}
        mysql: 
          repository: mysql/mysql-server
          tag: 5.7
{% if network.docker.password is defined %}
        pullSecret: regcred
{% endif %}
      tessera:
        removeKeysOnDelete: true
{% if org.type == 'member' or org.type is not defined %}
        peerNodes: 
{% for tm_node in network.config.tm_nodes %}
          - url: {{ tm_node | quote }}
{% endfor %}
{% endif %}
        resources:
          cpuLimit: 0.25
          cpuRequest: 0.05
          memLimit: "2G"
          memRequest: "1G"
        password: 'password'
        port: {{ peer.tm_nodeport.port }}
        tpport: 9080
        q2tport: {{ peer.tm_clientport.port }}
        metrics:
          enabled: {{ peer.metrics.enabled | default(false) }}
          port: {{ peer.metrics.port | default(9545) }}
          serviceMonitorEnabled: {{ network.prometheus.enabled | default(false) }}
{% if network.config.tm_tls %}
        tlsMode: "STRICT"
{% if network.config.tm_trust == 'ca-or-tofu' %}
        trust: "CA_OR_TOFU"
{% else %}
        trust: "{{ network.config.tm_trust | upper }}"
{% endif %}
{% else %}
        tlsMode: "OFF"
{% endif %}
    tls:
      enabled: true
{% if network.docker.password is defined %}
      image:
        pullSecret: regcred
{% endif %}
      settings:
        certSubject: {{ network.config.subject | quote }}
        tmTls: {{ network.config.tm_tls | default(false) }}
    image:
{% if network.docker.password is defined %}
      pullSecret: regcred
{% endif %}
      besu:
        repository: hyperledger/besu
        tag: {{ network.version }}
    node:
      removeKeysOnDelete: false
      isBootnode: false
      usesBootnodes: false
      besu:
        identity: {{ peer.subject | quote }}
        envBesuOpts: ""
        resources:
          cpuLimit: 0.25
          cpuRequest: 0.05
          memLimit: "1G"
          memRequest: "300M"
        account:
          password: {{ peer.geth_passphrase | quote }}
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
          serviceMonitorEnabled: {{ network.prometheus.enabled | default(false)}}
        privacy:
          clientport: {{ peer.tm_clientport.port }}
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
