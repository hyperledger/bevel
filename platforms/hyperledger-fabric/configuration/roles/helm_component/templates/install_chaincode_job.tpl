apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ name | lower | e }}-net
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/install_chaincode
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
      secretgitprivatekey: secret/credentials/{{ namespace }}/git?git_password
      tls: false
    orderer:
      address: {{ orderer_address }}
    chaincode:
      builder: hyperledger/fabric-ccenv:{{ network.version }}
      name: {{ component_chaincode.name | lower | e }}
      version: {{ component_chaincode.version }}
      maindirectory: {{ component_chaincode.maindirectory }}
      repository:
        hostname: "{{ component_chaincode.repository.url.split('/')[0] | lower }}"
        git_username: "{{ component_chaincode.repository.username}}"
        url: {{ component_chaincode.repository.url }}
        branch: {{ component_chaincode.repository.branch }}
        path: {{ component_chaincode.repository.path }}