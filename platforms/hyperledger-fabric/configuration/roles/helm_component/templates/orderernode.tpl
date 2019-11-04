apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ org_name }}-orderer
  namespace: {{ namespace }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ org_name }}-orderer
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/orderernode
  values:
    metadata:
      namespace: {{ namespace }}

    orderer:
      name: {{ orderer.name }}
      loglevel: info
      localmspid: {{ org_name }}MSP
      tlsstatus: true
      keepaliveserverinterval: 10s

    storage:
      storageclassname: {{ org_name }}sc
      storagesize: 512Mi  

    service:
      servicetype: ClusterIP
      ports:
        grpc:
          clusteripport: {{ orderer.grpc.port }}
{% if orderer.grpc.nodePort is defined %}
          nodeport: {{ orderer.grpc.nodePort }}
{% endif %}

    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: {{ namespace }}-auth
      secretprefix: secret/crypto/ordererOrganizations/{{ namespace }}/orderers/{{ orderer.name }}.{{ namespace }}
      imagesecretname: regcred
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

    ambassador:
      annotations: |- 
          ---
          apiVersion: ambassador/v1
          kind: TLSContext
          name: tls_context_{{ orderer.name }}_{{ namespace }}
          hosts:
          - {{ orderer.name }}.{{item.external_url_suffix}}
          secret: {{ orderer.name }}-{{ namespace }}-ambassador-certs
          alpn_protocols: h2
          ---
          apiVersion: ambassador/v1
          kind: Mapping
          tls: tls_context_{{ orderer.name }}_{{ namespace }}
          grpc: True
          name: orderer_mapping_{{ orderer.name }}_{{ namespace }}
          headers:
            :authority: {{ orderer.name }}.{{item.external_url_suffix}}:8443
          prefix: /
          rewrite: /
          service: https://{{ orderer.name }}.{{ namespace }}:7050
          ---
          apiVersion: ambassador/v1
          kind: Mapping
          tls: tls_context_{{ orderer.name }}_{{ namespace }}
          grpc: True
          name: orderer_mapping_{{ orderer.name }}_{{ namespace }}_rest
          headers:
            :authority: {{ orderer.name }}.{{item.external_url_suffix}}
          prefix: /
          rewrite: /
          service: https://{{ orderer.name }}.{{ namespace }}:7050

    genesis: |-
{{ genesis | indent(width=6, indentfirst=True) }}