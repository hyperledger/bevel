apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ org_name }}-{{ orderer.name }}
  namespace: {{ namespace }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: {{ org_name }}-{{ orderer.name }}
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/fabric-orderernode
  values:
    metadata:
      namespace: {{ namespace }}
      network:
        version: {{ network.version }}
      images:
        orderer: {{ docker_url }}/{{ orderer_image[network.version] }}
        alpineutils: {{ docker_url }}/{{ alpine_image }}
{% if network.env.annotations is defined %}
    annotations:  
      service:
{% for item in network.env.annotations.service %}
{% for key, value in item.items() %}
        - {{ key }}: {{ value | quote }}
{% endfor %}
{% endfor %}
      pvc:
{% for item in network.env.annotations.pvc %}
{% for key, value in item.items() %}
        - {{ key }}: {{ value | quote }}
{% endfor %}
{% endfor %}
      deployment:
{% for item in network.env.annotations.deployment %}
{% for key, value in item.items() %}
        - {{ key }}: {{ value | quote }}
{% endfor %}
{% endfor %}
{% endif %}
    orderer:
      name: {{ orderer.name }}
      loglevel: info
      localmspid: {{ org_name }}MSP
      tlsstatus: true
      keepaliveserverinterval: 10s
      ordererAddress: {{ orderer.ordererAddress }}

    consensus:
      name: {{ orderer.consensus }}

    storage:
      storageclassname: {{ sc_name }}
      storagesize: 512Mi  

    service:
      servicetype: ClusterIP
      ports:
        grpc:
          clusteripport: {{ orderer.grpc.port }}
{% if orderer.grpc.nodePort is defined %}
          nodeport: {{ orderer.grpc.nodePort }}
{% endif %}
        metrics: 
          enabled: {{ orderer.metrics.enabled | default(false) }}
          clusteripport: {{ orderer.metrics.port | default(9443) }}

    vault:
      address: {{ vault.url }}
      role: vault-role
{% if item.k8s.cluster_id is defined %}
      authpath: {{ item.k8s.cluster_id }}{{ namespace }}-auth
{% else %}
      authpath: {{ network.env.type }}{{ namespace }}-auth
{% endif %}
      type: {{ vault.type | default("hashicorp") }}
      secretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/ordererOrganizations/{{ namespace }}/orderers/{{ orderer.name }}.{{ namespace }}
{% if network.docker.username is defined and network.docker.password is defined %}
      imagesecretname: regcred
{% else %}
      imagesecretname: ""
{% endif %}
      serviceaccountname: vault-auth
{% if orderer.consensus == 'kafka' %}
    kafka:
      readinesscheckinterval: 10
      readinessthreshold: 10
      brokers:
{% for i in range(consensus.replicas) %}
      - {{ consensus.name }}-{{ i }}.{{ consensus.type }}.{{ namespace }}.svc.cluster.local:{{ consensus.grpc.port }}
{% endfor %}
{% endif %}

    proxy:
      provider: {{ network.env.proxy }}
      external_url_suffix: {{ item.external_url_suffix }}

    genesis: |-
{{ genesis | indent(width=6, first=True) }}

    config:
      pod:
        resources:
          limits:
            memory: 512M
            cpu: 1
          requests:
            memory: 512M
            cpu: 0.25
