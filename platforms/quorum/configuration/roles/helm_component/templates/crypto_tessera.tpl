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
    image:      
      repository: quorumengineering/tessera:{{ network.config.tm_version }}
      pullSecret: regcred
    vault:
      address: {{ vault.url }}
      authpath: quorum{{ peer.name }}
      role: vault-role
      serviceaccountname: vault-auth
      tmprefix: {{ vault.secret_path | default('secret') }}/data/{{ component_ns }}/crypto/{{ peer.name }}/transaction
