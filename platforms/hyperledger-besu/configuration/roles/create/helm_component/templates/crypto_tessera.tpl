apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    path: {{ charts_dir }}/tessera_key_mgmt
    git: {{ gitops.git_url }}
    ref: {{ gitops.branch }}
  values:
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
    peer:
      name: {{ peer.name }}        
    image:      
      repository: quorumengineering/tessera:{{ network.config.tm_version }}
      pullSecret: regcred
    vault:
      address: {{ vault.url }}
      authpath: besu{{ org.name | lower }}
      role: vault-role
      keyprefix: {{ component_ns }}/crypto
      serviceaccountname: vault-auth
      tmprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}/crypto
