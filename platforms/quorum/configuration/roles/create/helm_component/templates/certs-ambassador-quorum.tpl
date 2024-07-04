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
    chart: {{ charts_dir }}/quorum-tlscert-gen
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    name: "{{ org.name }}"
    metadata:
      namespace: {{ component_ns }}
    image:
      initContainerName: ghcr.io/hyperledger/bevel-alpine:latest
      certsContainerName: ghcr.io/hyperledger/bevel-build:jdk8-latest
      imagePullSecret: regcred
      pullPolicy: IfNotPresent
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: {{ network.env.type }}{{ org_name }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}
      retries: 30
      type: {{ vault.type | default("hashicorp") }}
    subjects:
      root_subject: "{{ network.config.subject }}"
      cert_subject: "{{ network.config.subject | regex_replace(',', '/') }}"
    opensslVars:
      domain_name: "{{ name }}.{{ external_url }}"
      domain_name_api: "{{ name }}api.{{ external_url }}"
      domain_name_web: "{{ name }}web.{{ external_url }}"
      domain_name_tessera: "{{ name }}-tessera.{{ component_ns }}"
      clientport: {{ node.transaction_manager.clientport | default("8888") }}
