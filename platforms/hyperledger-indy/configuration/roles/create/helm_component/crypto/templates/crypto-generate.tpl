apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}-{{ identity_name }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}-{{ identity_name }}
  chart:
    path: {{ gitops.chart_source }}/{{ chart }}
    git: {{ gitops.git_url }}
    ref: {{ gitops.branch }}
  values:
    metadata:
      name: {{ component_name }}-{{ identity_name }}
      namespace: {{ component_ns }}
    network:
      name: {{ network.name }}
    image:
      name: {{ component_name }}
      repository: {{ network.docker.url }}/indy-key-mgmt:{{ network.version }}
      pullSecret: regcred
    vault:
      address: {{ vault.url }}
      version: "2"
      keyPath: {{ vault_path }}
      identity: {{ identity_name }}
      auth_path: kubernetes-{{ organization }}-admin-auth
    account:
      service: {{ organization }}-admin-vault-auth
      role: rw
