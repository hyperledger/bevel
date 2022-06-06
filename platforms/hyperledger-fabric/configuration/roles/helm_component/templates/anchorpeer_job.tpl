apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/anchorpeer
{% if git_protocol == 'https' %}
    secretRef:
      name: gitcredentials
{% endif %}
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
    anchorstx: |-
{{ anchorstx | indent(width=6, first=True) }}

