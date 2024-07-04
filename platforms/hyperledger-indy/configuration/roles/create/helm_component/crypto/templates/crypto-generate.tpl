apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}-{{ identity_name }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}-{{ identity_name }}
  interval: 1m
  chart:
   spec:
    chart: {{ gitops.chart_source }}/{{ chart }}
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      name: {{ component_name }}-{{ identity_name }}
      namespace: {{ component_ns }}
    network:
      name: {{ network.name }}
    image:
      name: {{ component_name }}
      repository: {{ network.docker.url }}/bevel-indy-key-mgmt:{{ network.version }}
      pullSecret: regcred
      pullPolicy: IfNotPresent
    vault:
      address: {{ vault.url }}
      version: "2"
      keyPath: {{ vault_path }}
      identity: {{ identity_name }}
      auth_path: kubernetes-{{ organization }}-admin-auth
      certsecretprefix: {{ certsecretprefix }}
    account:
      service: {{ organization }}-admin-vault-auth
      role: rw
