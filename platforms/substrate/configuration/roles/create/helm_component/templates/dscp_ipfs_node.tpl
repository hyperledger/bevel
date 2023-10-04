apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
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
      chart: {{ charts_dir }}/dscp-ipfs-node
  values:
    fullnameOverride: {{ peer.name }}-ipfs
    namespace: {{ component_ns }}
    config:
      healthCheckPort: 80
      healthCheckPollPeriod: 30000
      healthCheckTimeout: 2000
      nodeHost: "{{ peer.nodeHost }}"
      nodePort: "{{ peer.ws.port }}"
      logLevel: info
      ipfsApiPort: {{ peer.ipfs.apiPort }}
      ipfsSwarmPort: {{ peer.ipfs.swarmPort }}
      ipfsDataPath: "/ipfs"
      ipfsCommand: "/usr/local/bin/ipfs"
      ipfsArgs:
        - daemon
        - "--migrate"
      ipfsSwarmAddrFilters: null
      ipfsLogLevel: info
{% if ipfs_bootnode is defined %}
      ipfsBootNodeAddress: {{ ipfs_bootnode[1:] | join(',') }}
{% endif %}      
    service:
      swarm:
        annotations: {}
        enabled: true
        port: {{ peer.ipfs.swarmPort }}
      api:
        annotations: {}
        enabled: true
        port: {{ peer.ipfs.apiPort }}

    statefulSet:
      annotations: {}
      livenessProbe:
        enabled: true
    image:
      repository: {{ docker_url }}/inteli-poc/dscp-ipfs
      pullPolicy: IfNotPresent
      tag: 'v2.6.2'
    storage:
      storageClass: "{{ storageclass_name }}"
      dataVolumeSize: 20  # in Gigabytes
    dscpNode:
      enabled: false
    proxy:
      provider: ambassador
      external_url: {{ peer.name }}-ipfs-swarm.{{ external_url }}
      port: {{ peer.ipfs.ambassador }}
      certSecret: {{ org.name | lower }}-ambassador-certs
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: substrate{{ name }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}/{{ peer.name }}
