apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
    spec:
      chart: {{ gitops.chart_source }}/corda-network-service
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
  values:
    global:
      serviceAccountName: vault-auth
      cluster:
        provider: {{ org.cloud_provider }}
        cloudNativeServices: false
      vault:
        type: hashicorp
        network: corda
        address: {{ vault.url }}
        authPath: {{ network.env.type }}{{ name }}
        secretEngine: {{ vault.secret_path | default("secretsv2") }}
        secretPrefix: "data/{{ network.env.type }}{{ name }}"
        role: vault-role
      proxy:
        provider: {{ network.env.proxy }}
        externalUrlSuffix: {{ org.external_url_suffix }}
    storage:
      size: 1Gi
      dbSize: 1Gi
      allowedTopologies:
        enabled: false
    tls:
      enabled: true
      settings:
        networkServices: true
    image: 
{% if network.docker.username is defined %}
      pullSecret: regcred
{% endif %}
      pullPolicy: IfNotPresent
      mongo: 
        repository: mongo
        tag: 3.6.6
      hooks:
        repository: {{ network.docker.url }}/bevel-build
        tag: jdk8-stable
      doorman: {{ network.docker.url }}/bevel-doorman-linuxkit:latest
      nms: {{ network.docker.url }}/bevel-networkmap-linuxkit:latest

    settings:
      removeKeysOnDelete: true
      rootSubject: "CN=DLT Root CA,OU=DLT,O=DLT,L=New York,C=US"
      mongoSubject: "{{ doorman.db_subject }}"

    doorman:
      subject: "{{ doorman.subject }}"
      authPassword: admin
      dbPassword: newdbnm
      port: {{ doorman.ports.servicePort }}

    nms:
      subject: {{ nms.subject }}
      authPassword: admin
      dbPassword: newdbnm
      port: {{ nms.ports.servicePort }}
