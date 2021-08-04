apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: channel-{{ org.name | lower }}-{{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: channel-{{ org.name | lower }}-{{ component_name }}
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/create_channel   
  values:
    metadata:
      namespace: {{ component_ns }}
      network:
        version {{ network.version }}
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
      authpath: {{ network.env.type }}{{ component_ns }}-auth
      adminsecretprefix: {{ vault.secret_path | default('secret') }}/crypto/peerOrganizations/{{ component_ns }}/users/admin
      orderersecretprefix: {{ vault.secret_path | default('secret') }}/crypto/peerOrganizations/{{ component_ns }}/orderer 
      serviceaccountname: vault-auth
      imagesecretname: regcred

    channel:
      name: {{ component_name }}
    orderer:
      address: {{ peer.ordererAddress }}
    channeltx: |-
{{ channeltx | indent(width=6, first=True) }}