apiVersion: helm.toolkit.fluxcd.io/v2beta1
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
    chart: {{ charts_dir }}/crypto_ibft
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
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
      node: quorumengineering/quorum:{{ network.version }}
      pullPolicy: IfNotPresent
    acceptLicense: YES
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: quorum{{ org_name }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}-quo
      retries: 30
    healthCheckNodePort: 0
    sleepTimeAfterError: 60
    sleepTime: 10
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 1
