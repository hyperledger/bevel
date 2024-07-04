apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/bevel-vault-mgmt
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    nameOverride: {{ component_name }}
    global:
      serviceAccountName: vault-auth
      cluster:
        cloudNativeServices: false
        kubernetesUrl: {{ kubernetes_url }}
      vault:
        type: hashicorp
        role: vault-role
        address: {{ vault.url }}
        authPath: {{ component_auth }}
        network: {{ network.type }}
        secretEngine: {{ vault.secret_path | default(name) }}
        secretPrefix: "data/{{ name }}"
        tls:
    image:
      repository: ghcr.io/hyperledger/bevel-alpine
      tag: latest
      pullSecret: "regcred"
