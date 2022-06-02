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
    chart: {{ charts_dir }}/certs-ambassador-quorum
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    name: "{{ org.name }}"
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
      external_url: {{ component_name }}.{{ external_url }}
    image:
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
      node: quorumengineering/quorum:{{ network.version }}
      certsContainerName: {{ network.docker.url }}/bevel-build:jdk8-latest
      imagePullSecret: regcred
      pullPolicy: IfNotPresent
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: quorum{{ org_name }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}-quo
      retries: 30
    subjects:
      root_subject: "{{ network.config.subject }}"
      cert_subject: "{{ network.config.subject | regex_replace(',', '/') }}"
    opensslVars:
      domain_name: "{{ name }}.{{ external_url }}"
      domain_name_api: "{{ name }}api.{{ external_url }}"
      domain_name_web: "{{ name }}web.{{ external_url }}"
      domain_name_tessera: "{{ name }}-tessera.{{ component_ns }}"
    acceptLicense: YES
    healthCheckNodePort: 0
    sleepTimeAfterError: 60
    sleepTime: 10
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 1
