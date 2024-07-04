apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name | replace('_','-') }}
  namespace: {{ namespace }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: {{ component_name | replace('_','-') }}
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/fabric-orderernode
  values:
    global:
      version: {{ network.version }}
      serviceAccountName: vault-auth
      cluster:
        provider: {{ org.cloud_provider }}
        cloudNativeServices: false
      vault:
        type: hashicorp
        network: fabric
        address: {{ vault.url }}
        authPath: {{ network.env.type }}{{ org_name }}
        secretEngine: {{ vault.secret_path | default("secretsv2") }}
        secretPrefix: "data/{{ network.env.type }}{{ org_name }}"
        role: vault-role
        tls: false
      proxy:
        provider: {{ network.env.proxy | quote }}
        externalUrlSuffix: {{ org.external_url_suffix }}

    storage:
      size: 512Mi
      reclaimPolicy: "Delete" 
      volumeBindingMode: 
      allowedTopologies:
        enabled: false

    certs:
      generateCertificates: true
      orgData:
{% if network.env.proxy == 'none' %}
        caAddress: ca.{{ namespace }}:7054
{% else %}
        caAddress: ca.{{ namespace }}.{{ org.external_url_suffix }}
{% endif %}
        caAdminUser: {{ org_name }}-admin
        caAdminPassword: {{ org_name }}-adminpw
        orgName: {{ org_name }}
        type: orderer
        componentSubject: "{{ component_subject | quote }}"

      settings:
        createConfigMaps: {{ create_configmaps }}
        refreshCertValue: false
        addPeerValue: false
        removeCertsOnDelete: true
        removeOrdererTlsOnDelete: true

    image:
      orderer: {{ docker_url }}/{{ orderer_image }}
      alpineUtils: {{ docker_url }}/bevel-alpine:{{ bevel_alpine_version }}
{% if network.docker.username is defined and network.docker.password is defined  %}
      pullSecret: regcred
{% else %}
      pullSecret: ""
{% endif %}

    orderer:
      consensus: {{ orderer.consensus }}
      logLevel: info
      localMspId: {{ org_name }}MSP
      tlsStatus: true
      keepAliveServerInterval: 10s
      serviceType: ClusterIP
      ports:
        grpc:
          clusterIpPort: {{ orderer.grpc.port }}
{% if orderer.grpc.nodePort is defined %}
          nodeport: {{ orderer.grpc.nodePort }}
{% endif %}
        metrics: 
          enabled: {{ orderer.metrics.enabled | default(false) }}
          clusterIpPort: {{ orderer.metrics.port | default(9443) }}
      resources:
        limits:
          memory: 512M
          cpu: 1
        requests:
          memory: 512M
          cpu: 0.25

{% if orderer.consensus == 'kafka' %}
    kafka:
      readinessCheckInterval: 10
      readinessThresHold: 10
      brokers:
{% for i in range(consensus.replicas) %}
      - {{ consensus.name }}-{{ i }}.{{ consensus.type }}.{{ namespace }}.svc.cluster.local:{{ consensus.grpc.port }}
{% endfor %}
{% endif %}

    healthCheck: 
      retries: 10
      sleepTimeAfterError: 15

{% if network.env.labels is defined %}
      labels:
{% if network.env.labels.service is defined %}
        service:
{% for key in network.env.labels.service.keys() %}
          - {{ key }}: {{ network.env.labels.service[key] | quote }}
{% endfor %}
{% endif %}
{% if network.env.labels.pvc is defined %}
        pvc:
{% for key in network.env.labels.pvc.keys() %}
          - {{ key }}: {{ network.env.labels.pvc[key] | quote }}
{% endfor %}
{% endif %}
{% if network.env.labels.deployment is defined %}
        deployment:
{% for key in network.env.labels.deployment.keys() %}
          - {{ key }}: {{ network.env.labels.deployment[key] | quote }}
{% endfor %}
{% endif %}
{% endif %}
