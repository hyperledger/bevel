apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  annotations:
    flux.weave.works/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}
  chart:
    path: {{ gitops.chart_source }}/{{ chart }}
    git: {{ gitops.git_ssh }}
    ref: {{ gitops.branch }}
  values:
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
    network:
      name: {{ network.name }}
    image:
      name: {{ component_name }}
      repository: indy-key-mgmt:latest
      pullSecret: regcred
    vault:
      address: {{ vault.url }}
      keyPath: {{ organizationItem.organization }}.{{ organizationItem.node }}
      identity: {{ organizationItem.itentityName }}
    account:
      service: {{ component_name }}-vault-auth
      role: {{ roleName }}
