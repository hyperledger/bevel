apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  annotations:
    fluxcd.io/automated: "false"
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
    organization:
      name: {{ organizationItem.name }}
    configmap:
      poolGenesis: |-
        {{ pool_genesis_values | indent(width=8) }}
