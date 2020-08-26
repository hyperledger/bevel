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
    path: {{ charts_dir }}/fabric_cli    
  values:
    metadata:
      namespace: {{ component_ns }}
      images:
        fabrictools: {{ fabrictools_image }}
        alpineutils: {{ alpine_image }}
    storage:
      class: {{ storage_class }}
      size: 256Mi
    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ component_ns }}-auth
      adminsecretprefix: secret/crypto/peerOrganizations/{{ component_ns }}/users/admin
      orderersecretprefix: secret/crypto/peerOrganizations/{{ component_ns }}/orderer
      serviceaccountname: vault-auth
      imagesecretname: regcred
      tls: false
    peer:
      name: {{ peer.name }}
      localmspid: {{ org.name | lower}}MSP
      tlsstatus: true
      address: {{ peer.gossippeeraddress }}
    orderer:
      address: {{ orderer.uri }}
