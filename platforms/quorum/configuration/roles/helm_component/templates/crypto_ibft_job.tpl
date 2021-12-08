apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ org.gitops.git_url }}
    ref: {{ org.gitops.branch }}
    path: {{ charts_dir }}/crypto_ibft
  values:
    peer:
      name: {{ peer.name }}
      gethPassphrase: {{ peer.geth_passphrase }}
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
    image:
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
      node: quorumengineering/quorum:{{ network.version }}
      pullPolicy: Always
    acceptLicense: YES
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: quorum{{ org_name }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}-quo
