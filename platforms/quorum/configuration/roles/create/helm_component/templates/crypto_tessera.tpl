apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/quorum-tessera-key-mgmt
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    peer:
      name: {{ peer.name }}
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
    image:
      repository: quorumengineering/tessera:hashicorp-{{ network.config.tm_version }}
      pullSecret: regcred
    vault:
      address: {{ vault.url }}
      secretengine: {{ vault.secret_path | default('secretsv2') }}
      authpath: {{ network.env.type }}{{ org_name }}
      keyprefix: {{ org_name }}/crypto
      role: vault-role
      serviceaccountname: vault-auth
      tmprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org_name }}/crypto
      type: {{ vault.type | default("hashicorp") }}
