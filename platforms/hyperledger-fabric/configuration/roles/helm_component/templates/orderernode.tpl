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
      secretambassador: secret/crypto/ordererOrganizations/{{ namespace }}/ambassador
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
      external_url_suffix: {{ item.external_url_suffix }}

    genesis: |-
{{ genesis | indent(width=6, indentfirst=True) }}
