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
    chart: {{ charts_dir }}/quorum-ibft-crypto-gen
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    peer:
      name: {{ peer.name }}
      gethPassphrase: {{ peer.geth_passphrase }}
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
    image:
      initContainerName: ghcr.io/hyperledger/bevel-alpine:latest
      node: quorumengineering/quorum:{{ network.version }}
      pullPolicy: IfNotPresent
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: {{ network.env.type }}{{ org_name }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}
      retries: 30
      type: {{ vault.type | default("hashicorp") }}
    sleepTime: 10
