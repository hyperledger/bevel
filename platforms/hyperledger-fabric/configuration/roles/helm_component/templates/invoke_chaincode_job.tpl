apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ namespace }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/invoke_chaincode
  values:
    metadata:
      namespace: {{ namespace }}
      images:
        fabrictools: {{ fabrictools_image }}
        alpineutils: {{ alpine_image }}
    peer:
      name: {{ peer_name }}
      address: {{ peer_address }}
      localmspid: {{ name }}MSP
      loglevel: debug
      tlsstatus: true
    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ namespace | e }}-auth
      adminsecretprefix: secret/crypto/peerOrganizations/{{ namespace }}/users/admin 
      orderersecretprefix: secret/crypto/peerOrganizations/{{ namespace }}/orderer
      serviceaccountname: vault-auth
      imagesecretname: regcred
      tls: false
    orderer:
      address: {{ participant.ordererAddress }}
    chaincode:
      builder: hyperledger/fabric-ccenv:{{ network.version }}
      name: {{ component_chaincode.name | lower | e }}
      version: {{ component_chaincode.version }}
      instantiationarguments: {{ component_chaincode.arguments | quote}}
      endorsementpolicies:  {{ component_chaincode.endorsements | quote}}
    channel:
      name: {{ item.channel_name | lower }}
