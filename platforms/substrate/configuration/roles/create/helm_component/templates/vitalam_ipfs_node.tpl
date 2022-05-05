apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ org.gitops.git_url }}
    ref: {{ org.gitops.branch }}
    path: {{ charts_dir }}/vitalam-ipfs-node
  values:
    fullnameOverride: {{ peer.name }}-ipfs
    config:
      healthCheckPort: 80
      nodeHost: "{{ peer.name }}"
      nodePort: "{{ peer.ws.port }}"
      logLevel: info
      ipfsApiPort: {{ peer.ipfs.apiPort }}
      ipfsSwarmPort: {{ peer.ipfs.swarmPort }}
      ipfsDataPath: "/ipfs"
      ipfsCommand: "/usr/local/bin/ipfs"
      ipfsArgs:
        - daemon
      ipfsLogLevel: fatal
{% if ipfs_bootnode is defined %}
      ipfsBootNodeAddress: {{ ipfs_bootnode[1:] | join(',') }}
{% endif %}      
      enableLivenessProbe: true
    image:
      repository: {{ docker_url }}/digicatapult/dscp-ipfs
      pullPolicy: IfNotPresent
      tag: 'v2.0.2'
    storage:
      storageClass: "{{ storageclass_name }}"
      dataVolumeSize: 20  # in Gigabytes
    vitalamNode:
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
