apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ name | lower | e }}-net
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: {{ component_name }}
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/install_external_chaincode
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
      chaincodesecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ namespace }}/peers/{{ peer_name }}.{{ namespace }}/chaincodes
      adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ namespace }}/users/admin 
      orderersecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ namespace }}/orderer
      serviceaccountname: vault-auth
      imagesecretname: regcred
      secretgitprivatekey: {{ vault.secret_path | default('secretsv2') }}/data/credentials/{{ namespace }}/git?git_password
      tls: false
      chaincodepackageprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ namespace }}/chaincodes/{{ component_chaincode.name | lower | e }}/package/v{{ component_chaincode.version }}
    chaincode:
      name: {{ component_chaincode.name | lower | e }}
      version: {{ component_chaincode.version }}
      tls: {{ component_chaincode.tls }}
      address: chaincode-{{ component_chaincode.name | lower | e }}-{{ component_chaincode.version }}-{{ name | lower | e }}.{{ namespace }}.svc.cluster.local:7052
