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
    config:
      healthCheckPort: 80
      logLevel: trace
      ipfsApiPort: 5001
      ipfsSwarmPort: 4001
      ipfsDataPath: "/ipfs"
      ipfsCommand: "/usr/local/bin/ipfs"
      ipfsArgs:
        - daemon
      ipfsLogLevel: trace
      enableLivenessProbe: true
    image:
      repository: ghcr.io/digicatapult/vitalam-ipfs
      pullPolicy: IfNotPresent
      tag: 'v1.2.6'
    storage:
      storageClass: ""
      dataVolumeSize: 1  # in Gigabytes
    vitalamNode:
      enabled: true
