apiVersion: helm.toolkit.fluxcd.io/v2
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
      chart: {{ charts_dir }}/substrate-key-mgmt
  values:
    node:
      name: {{ peer.name }}
      image: {{ network.docker.url }}/{{ network.config.node_image }}:{{ network.version }}
      pullPolicy: IfNotPresent
      command: {{ network.config.command }}
      type: {{ peer.type | lower }}
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
    initContainer:
      image: ghcr.io/hyperledger/alpine-utils:1.0
      pullPolicy: IfNotPresent
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: {{ network.env.type }}{{ name }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ name }}
