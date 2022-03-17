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
    path: {{ charts_dir }}/substrate-node

  values:
    image:
      repository: {{ network.docker.url }}/{{ network.config.node_image }}
      tag: {{ network.version }}
      pullPolicy: IfNotPresent
    imagePullSecrets: 
      - name: "regcred"
    serviceAccount:
      create: false
      name: vault-auth

    podSecurityContext:
      runAsUser: 1000
      runAsGroup: 1000
      fsGroup: 1000
    ingress:
      enabled: false
{% if bootnode_data is defined %}
    bootnode: {{ bootnode_data }}
{% endif %}

    node:
      name: {{ peer.name }}
      namespace: {{ component_ns }}      
      chain: "local"
      command: {{ command }}      
      dataVolumeSize: 10Gi
      replicas: 1
      role: {{ role }}
      
      collator:
        isParachain: false
                
      enableStartupProbe: false
      enableReadinessProbe: false
      flags:
      keys: {}
      persistGeneratedNodeKey: false
      
      resources: {}
      serviceMonitor:
        enabled: false
        
      perNodeServices:
        createClusterIPService: true
        createP2pNodePortService: false
        setPublicAddressToExternalIp:
          enabled: false
          ipRetrievalServiceUrl: https://ifconfig.io
      podManagementPolicy: Parallel

      ports:
        p2p: {{ peer.p2p.port }}
        ws: {{ peer.ws.port }}
        rpc: {{ peer.rpc.port }}

      tracing:
        enabled: false
      substrateApiSidecar:
        enabled: false

    proxy:
      provider: ambassador
      external_url: {{ peer.name }}.{{ external_url }}
      p2p: {{ peer.p2p.ambassador }}

    storageClass: {{ storageclass_name }}

    vault:
      address: {{ vault.url }}      
      secretPrefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}
      authPath: substrate{{ name }}
      appRole: vault-role
      image: hyperledgerlabs/alpine-utils:1.0 
