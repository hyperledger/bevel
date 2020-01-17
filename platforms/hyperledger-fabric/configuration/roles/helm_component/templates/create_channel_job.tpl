apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: channel-{{ org.name | lower }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: channel-{{ org.name | lower }}
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/create_channel   
  values:
    metadata:
      namespace: {{ component_ns }}
      images:
        fabrictools: {{ fabrictools_image }}
        alpineutils: {{ alpine_image }}
    peer:
      name: {{ peer_name }}
      address: {{ peer_name }}.{{ component_ns }}:7051
      localmspid: {{ org.name | lower }}MSP
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
      name: {{ component_name }}
    orderer:
      address: {{ peer.ordererAddress }}
    channeltx: |-
{{ channeltx | indent(width=6, indentfirst=True) }}