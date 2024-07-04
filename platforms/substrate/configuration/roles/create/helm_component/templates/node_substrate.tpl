apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  interval: 1m
  releaseName: {{ component_name }}
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/substrate-node
  values:
    image:
      repository: {{ network.docker.url }}/{{ network.config.node_image }}
      tag: {{ network.version }}
      pullPolicy: IfNotPresent
{% if network.docker.password is defined %}
    imagePullSecrets: 
      - name: "regcred"
{% endif %}
    nameOverride: {{ peer.name }}
    fullnameOverride: {{ peer.name }}
    namespace: {{ component_ns }}

    serviceAccount:
      create: false
      name: vault-auth

    podSecurityContext:
      runAsUser: 1000
      runAsGroup: 1000
      fsGroup: 1000
    ingress:
      enabled: false

    node:
      name: {{ peer.name }}
      chain: {{ network.config.chain }}
      command: {{ command }}
      isBootnode:
        enabled: {{ isBootnode }}
        bootnodeName: validator-1
        bootnodeAddr: validator-1.{{ external_url }}
        bootnodePort: 15051
      dataVolumeSize: 10Gi
      replicas: 1
      role: {{ role }}
      customChainspecUrl: true
      customChainspecPath: "/data/chainspec.json"
      collator:
        isParachain: false

      enableStartupProbe: false
      enableReadinessProbe: false
      flags:
        - "--rpc-external"
        - "--ws-external"
        - "--rpc-methods=Unsafe"
        - "--rpc-cors=all"
        - "--unsafe-ws-external"
        - "--unsafe-rpc-external"
{% if peer.type == 'member' %}
        - "--pruning=archive"
{% endif %}
      persistGeneratedNodeKey: false

      resources: {}
      serviceMonitor:
        enabled: false

      perNodeServices:
        createApiService: true
        createP2pService: true
        p2pServiceType: ClusterIP
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
      external_url: {{ external_url }}
      p2p: {{ peer.p2p.ambassador }}
      certSecret: {{ org.name | lower }}-ambassador-certs

    storageClass: {{ storageclass_name }}

    storage:
      size: "10Gi"
      reclaimPolicy: "Delete"
      volumeBindingMode: Immediate
      allowedTopologies:
        enabled: false

    vault:
      address: {{ vault.url }}      
      secretPrefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ name }}
      authPath: {{ network.env.type }}{{ name }}
      appRole: vault-role
      image: ghcr.io/hyperledger/alpine-utils:1.0
