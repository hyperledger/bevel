apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: joinchannel-{{ peer.name }}-{{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: joinchannel-{{ peer.name }}-{{ component_name }}
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/join_channel
  values:
    metadata:
      namespace: {{ component_ns }}
      images:
        fabrictools: {{ fabrictools_image }}
        alpineutils: {{ alpine_image }}

    peer:
      name: {{ peer_name }}
{% if network.env.proxy == 'none' %}
      address: {{ peer.name }}.{{ component_ns }}:7051
{% else %}
      address: {{ peer.peerAddress }}
{% endif %}
      localmspid: {{ org.name | lower}}MSP
      loglevel: debug
      tlsstatus: true

    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ network.env.type }}{{ component_ns }}-auth
      adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ component_ns }}/users/admin
      orderersecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ component_ns }}/orderer
      serviceaccountname: vault-auth
      imagesecretname: regcred

    channel:
      name: {{channel_name}}      
    orderer:
      address: {{ participant.ordererAddress }}
