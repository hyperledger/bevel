apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: channel-{{ org.name | lower }}-{{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: channel-{{ org.name | lower }}-{{ component_name }}
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/fabric-channel-create   
  values:
    metadata:
      namespace: {{ component_ns }}
      network:
        version: {{ network.version }}
      images:
        fabrictools: {{ docker_url }}/{{ fabric_tools_image[network.version] }}
        alpineutils: {{ docker_url }}/{{ alpine_image }}

    peer:
      name: {{ peer_name }}
      address: {{ peer_name }}.{{ component_ns }}:7051
      localmspid: {{ org.name | lower }}MSP
      loglevel: debug
      tlsstatus: true

    vault:
      role: vault-role
      address: {{ vault.url }}
{% if k8s.cluster_id is defined %}
      authpath: {{ k8s.cluster_id }}{{ component_ns }}-auth
{% else %}
      authpath: {{ network.env.type }}{{ component_ns }}-auth
{% endif %}
      adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ component_ns }}/users/admin
      orderersecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ component_ns }}/orderer 
      serviceaccountname: vault-auth
      type: {{ vault.type | default("hashicorp") }}
{% if network.docker.username is defined and network.docker.password is defined %}
      imagesecretname: regcred
{% else %}
      imagesecretname: ""
{% endif %}
    
    channel:
      name: {{ component_name }}
    orderer:
      address: {{ peer.ordererAddress }}
    channeltx: |-
{{ channeltx | indent(width=6, first=True) }}
