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
      repository: {{ image }}
      tag: latest
      pullPolicy: Always
    initContainer:
      image: 
        repository: crazymax/7zip
        tag: latest
    kubectl:
      image: 
      repository: bitnami/kubectl
      tag: latest
    googleCloudSdk:
      image:
        repository: google/cloud-sdk
        tag: slim
    imagePullSecrets: 

    nameOverride: 
    fullnameOverride:

    serviceAccount:
      create: false
      annotations: 
      name:
    podSecurityContext:
      runAsUser: 1000
      runAsGroup: 1000
      fsGroup: 1000
    ingress:
      enabled: false
      annotations: 
      rules:
      tls:

    bootnode: {{ bootnode_data }}

    node:
      namespace: {{ component_ns }}
      replicaCount: 1
      chain:
      command: {{ command }}
      peerName: {{ peers.name }}
      chainPath:
      dataVolumeSize: 100Gi
      role: {{ role }} 
      customChainspecUrl:
      chainDataSnapshotUrl: "https://dot-rocksdb.polkashots.io/snapshot"
      chainDataSnapshotFormat: 7z
      chainDataKubernetesVolumeSnapshot:
      chainDataGcsBucketUrl:
      collator:
        isParachain: false
        relayChain: polkadot
        relayChainCustomChainspecUrl: 
        relayChainDataSnapshotUrl: "https://dot-rocksdb.polkashots.io/snapshot"
        relayChainDataSnapshotFormat: 7z
        relayChainPath:
        relayChainDataKubernetesVolumeSnapshot:
        relayChainDataGcsBucketUrl: ""
        relayChainFlags:
      enableStartupProbe: false
      enableReadinessProbe: false
      flags:
      keys: 
      persistGeneratedNodeKey: false
      customNodeKey:
      resources:
      serviceMonitor:
        enabled: false
        namespace: 
        interval: 
        scrapeTimeout: 
      perNodeServices:
        createClusterIPService: true
        createP2pNodePortService: false
        setPublicAddressToExternalIp:
          enabled: false
          ipRetrievalServiceUrl: https://ifconfig.io
      podManagementPolicy:

      ports:
        p2p: {{ peers.p2p.port }}
        ws: {{ peers.ws-rpc.port }}
        rpc: {{ peers.rpc.port }}

      tracing:
        enabled: false
      substrateApiSidecar:
        enabled: false

    proxy:
      provider: ambassador
      external_url: {{ name }}.{{ external_url }}
      p2p: {{ peers.p2p.ambassador }}

    substrateApiSidecar:
      image:
        repository: parity/substrate-api-sidecar
        tag: latest
      env: 
      resources: 

    jaegerAgent:
      image:
        repository: jaegertracing/jaeger-agent
        tag: latest
      ports:
        compactPort: 6831
        binaryPort: 6832
        samplingPort: 5778
      collector:
        url: null
        port: 14250
      env:
      resources:

    podAnnotations:
    nodeSelector:
    terminationGracePeriodSeconds:
    tolerations:
    affinity:

    storageClass: {{ storageclass_name }}

    vault:
      address: {{ vault.url }}
      serviceaccountname: vault-auth
      secretPrefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}
      authPath: substrate{{ name }}
      appRole: vault-role
      image: hyperledgerlabs/alpine-utils:1.0 
