apiVersion: helm.toolkit.fluxcd.io/v2
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
    chart: {{ charts_dir }}/quorum-node
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
        type: {{ vault.type | default("hashicorp") }}
        network: quorum
        address: {{ vault.url }}
        secretPrefix: "data/{{ network.env.type }}{{ name }}"
        secretEngine: {{ vault.secret_path | default("secretsv2") }}
        role: vault-role
        authPath: {{ network.env.type }}{{ name }}
      proxy:
        provider: ambassador
        externalUrlSuffix: {{ org.external_url_suffix }}
        p2p: {{ peer.p2p.ambassador }}
        tmport: {{ peer.tm_nodeport.ambassador | default(443) }}
    storage:
      size: "2Gi"
    tessera:
      enabled: true
      tessera:
        port:
        resources:
          cpuLimit: 0.25
          cpuRequest: 0.05
          memLimit: "2G"
          memRequest: "1G"
        password: 'password'
      storage:
        enabled: false
        size: 1Gi
        dbSize: 2Gi
        allowedTopologies:
          enabled: false
          
    tls:
      enabled: true
{% if network.docker.password is defined %}
      image:
        pullSecret: regcred
{% endif %}
      settings:
        certSubject: {{ network.config.subject | quote }}
        tmTls: {{ network.config.tm_tls | default(false) }}


    node:
      goquorum:
        metrics:
          serviceMonitorEnabled: true
        resources:
          cpuLimit: 0.25
          cpuRequest: 0.05
          memLimit: "1G"
          memRequest: "300M"
        account:
          password: 'password'
        p2p:
          discovery: false
