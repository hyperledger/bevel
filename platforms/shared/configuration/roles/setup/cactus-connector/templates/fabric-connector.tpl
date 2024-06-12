apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ name }}-cactus
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ name }}-cactus
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/fabric-cacti-connector
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      namespace: {{ component_ns }}
      labels:
    replicaCount: 1
    images:
      repository: ghcr.io/hyperledger/cactus-cmd-api-server:1.1.3
    plugins:
      instanceId: "12345678"
      dockerBinary: "usr/local/bin/docker"
      caName: ca.{{ component_ns }}
      caAddress: ca.{{ component_ns }}:7054
      corePeerMSPconfigpath: "/opt/gopath/src/github.com/hyperledger/fabric/crypto/admin/msp"
      corePeerAdmincertFile: "/opt/gopath/src/github.com/hyperledger/fabric/crypto/admin/msp/cacerts/ca.crt"
      corePeerTlsRootcertFile: "/opt/gopath/src/github.com/hyperledger/fabric/crypto/admin/msp/tlscacerts/tlsca.crt"
      ordererTlsRootcertFile: "/opt/gopath/src/github.com/hyperledger/fabric/crypto/orderer/tls/ca.crt"
      discoveryEnabled: "true"
      asLocalhost: "true"
    envs:
      authorizationProtocol: "NONE"
      authorizationConfigJson: "{}"
      grpcTlsEnabled: "false"
    proxy:
      provider: {{ network.env.proxy }}
      external_url: {{ item.external_url_suffix }}
    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ network.env.type }}{{ component_ns }}-auth
      adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ component_ns }}/users/admin
      orderersecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ component_ns }}/orderer
      serviceaccountname: vault-auth
      tls: false
    peer:
      name: {{ member.name }}
      peerID: {{ member.name }}.{{ component_ns }}
      localmspid: {{ item.name | lower}}MSP
      tlsstatus: true
      address: {{ member.name }}.{{ component_ns }}:7051
    orderer:
      address: {{ network.orderers[0].uri }}
