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
      fullNameOverride: {{ fullNameOverride }}
      healthCheckPort: {{ healthCheckPort }}
      logLevel: {{ logLevel }}
      ipfsApiPort: {{ ipfsApiPort }}
      nodeHost: {{ nodeHost }}
      ipfsSwarmPort: {{ ipfsSwarmPort }}
      ipfsDataPath: {{ ipfsDataPath }}
      ipfsCommand: {{ ipfsCommand }}
      ipfsArgs: {{ ipfsArgs }}
      ipfsLogLevel: {{ ipfsLogLevel }}
      enableLivenessProbe: {{ enableLivenessProbe }}
    image:
      repository: {{ imageRepo }}
      pullPolicy: IfNotPresent
      tag: {{ imageVersion }}
    storage:
      storageClass: ""
      dataVolumeSize: 1  # in Gigabytes
    vitalamNode:
      enabled: {{ vitalamNode }}
