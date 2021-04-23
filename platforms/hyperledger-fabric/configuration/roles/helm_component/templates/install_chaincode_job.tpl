apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ name | lower | e }}-net
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/install_chaincode
  values:
    metadata:
      namespace: {{ namespace }}
      network:
        version: {{ network.version }}
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
      authpath: {{ network.env.type }}{{ namespace | e }}-auth
      adminsecretprefix: {{ vault.secret_path | default('secret') }}/crypto/peerOrganizations/{{ namespace }}/users/admin 
      orderersecretprefix: {{ vault.secret_path | default('secret') }}/crypto/peerOrganizations/{{ namespace }}/orderer
      serviceaccountname: vault-auth
      imagesecretname: regcred
      secretgitprivatekey: {{ vault.secret_path | default('secret') }}/credentials/{{ namespace }}/git?git_password
      tls: false
    orderer:
      address: {{ orderer_address }}
    chaincode:
      builder: hyperledger/fabric-ccenv:{{ network.version }}
      name: {{ component_chaincode.name | lower | e }}
      version: {{ component_chaincode.version }}
      lang: {{ component_chaincode.lang | default('golang') }}
      maindirectory: {{ component_chaincode.maindirectory }}
      repository:
        hostname: "{{ component_chaincode.repository.url.split('/')[0] | lower }}"
        git_username: "{{ component_chaincode.repository.username}}"
        url: {{ component_chaincode.repository.url }}
        branch: {{ component_chaincode.repository.branch }}
        path: {{ component_chaincode.repository.path }}
      endorsementpolicies:  {{ component_chaincode.endorsements | quote}}
