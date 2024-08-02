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
    chart: {{ charts_dir }}/enterprise-node
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    global:
      serviceAccountName: vault-auth
      cluster:
        provider: "{{ cloud_provider }}"
        cloudNativeServices: false
        kubernetesUrl: "{{ kubernetes_server }}"
      vault:
        type: hashicorp
        role: vault-role
        network: corda-enterprise
        address: "{{ vault.url }}"
        authPath: "{{ org_name }}"
        secretEngine: secretsv2
        secretPrefix: "data/{{ org_name }}"
      proxy:
        provider: ambassador
        externalUrlSuffix: {{ external_url_suffix }}
    image:
      node:
        repository: corda/corda-enterprise
        tag: 4.10.3-zulu-openjdk8-alpine
    network:
      creds:
        truststore: password
    tls:
      nameOverride: {{ node_name }}   # should match the release name
      enabled: true
    storage:
      size: 1Gi
      dbSize: 5Gi
    nodeConf:
      legalName: {{ subject }}
      doormanPort: 443
      networkMapPort: 443
      doormanDomain: {{ network.organizations[0].name }}-cenm-doorman.{{ external_url_suffix }}
      networkMapDomain: {{ network.organizations[0].name }}-cenm-nms.{{ external_url_suffix }}
      doormanURL: https://{{ network.organizations[0].name }}-cenm-doorman.{{ external_url_suffix }}
      networkMapURL: https://{{ network.organizations[0].name }}-cenm-nms.{{ external_url_suffix }}
