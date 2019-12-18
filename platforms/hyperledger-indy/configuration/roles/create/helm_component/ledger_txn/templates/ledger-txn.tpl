apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}-{{ identity_name }}
  annotations:
    flux.weave.works/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}-{{ identity_name }}
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
      repository: {{ network.docker.url }}/indy-ledger:latest
      pullSecret: regcred
    vault:
      address: {{ vault.url }}
      keyPath: {{ vault_path }}
      identity: {{ identity_name }}
      auth_path: kubernetes-{{ organization }}-admin-auth
    account:
      service: {{ organization }}-admin-vault-auth
      role: {{ vault.role }}
    organization:
      name: 
        adminIdentity:
          name: {{ admin_name }}
          path: {{ admin_path }}
        newIdentity:
          name: {{ newIdentity_name }}
          path: {{ newIdentity_path }}
          role: {{ newIdentity_role }}
    node:
      name: {{ component_name }}
