apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/join_channel
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
      authpath: {{ component_ns }}-auth
      adminsecretprefix: secret/crypto/peerOrganizations/{{ component_ns }}/users/admin
      orderersecretprefix: secret/crypto/peerOrganizations/{{ component_ns }}/orderer
      serviceaccountname: vault-auth
      imagesecretname: regcred

    channel:
      name: {{channel_name}}      
    orderer:
      address: {{ participant.ordererAddress }}

