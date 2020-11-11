apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}-ca-tools
  namespace: {{ component_name }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}-ca-tools
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/catools
  values:
    metadata:
      namespace: {{ component_name }}
      name: ca-tools

    replicaCount: 1

    image:
      repository: hyperledger/fabric-ca-tools
      tag: 1.2.0
      pullPolicy: IfNotPresent
      
    storage:
      storageclassname: {{ component | lower }}sc
      storagesize: 512Mi

