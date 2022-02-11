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
    path: {{ charts_dir }}/substrate-key-mgmt
  values:
    node:
      name: {{ peer.name }}
      image: {{ network.docker.url }}/{{ network.config.node_image }}:{{ network.version }}
      pullPolicy: IfNotPresent
      command: {{ network.config.command }}
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
    initContainer:
      image: hyperledgerlabs/alpine-utils:1.0
      pullPolicy: IfNotPresent
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: substrate{{ name }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}
