apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}-{{ identity_name }}
  annotations:
    flux.weave.works/automated: "false"
  namespace: {{ component_ns }}
spec:
  chart:
    path: {{ gitops.chart_source }}/{{ chart }}
    git: {{ gitops.git_ssh }}
    ref: {{ gitops.branch }}
  values:
    metadata:
      name: {{ component_name }}-{{ identity_name }}
      namespace: {{ component_ns }}
    network:
      name: {{ network.name }}
    image:
      name: {{ component_name }}
      repository: {{ network.docker.url }}/indy-key-mgmt:0.3.0.0
      pullSecret: regcred
    vault:
      address: {{ vault.url }}
      keyPath: {{ vault_path }}
      identity: {{ identity_name }}
    account:
      service: {{ component_name }}-vault-auth
      role: "ro"
