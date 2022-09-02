apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ name }}-restserver
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ name }}-restserver
  interval: 1m
  chart:
   spec:
    chart: {{ component_gitops.chart_source }}/fabric-restserver
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      namespace: {{ component_ns }}
    server:
      name: {{ name }}-restserver
      port: {{ peer_restserver_port }}
      localmspid: {{ name }}MSP
      image: {{ network.docker.url | lower }}/bevel-supplychain-fabric:rest-server-stable
      username: user1
      cert_path: "/secret/tls/user1.cert"
      key_path: "/secret/tls/user1.pem"
    storage:
      storageclassname: {{ name }}sc
      storagesize: 512Mi
    vault:
      address: {{ component_vault.url }}
      role: vault-role
      authpath: {{ network.env.type }}{{ component_ns }}-auth
      secretprefix: {{ component_vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ component_ns }}
      serviceaccountname: vault-auth
      imagesecretname: regcred
      image: ghcr.io/hyperledger/alpine-utils:1.0
    service:
      servicetype: ClusterIP
      ports:
        apiPort: {{ peer_restserver_targetport }}
        targetPort: 8000
    connection:
      peer: {{ peer_name }}.{{ component_ns }}
      peerAddress: {{ peer_url.split(':')[0] }}
      peerPort: {{ peer_url.split(':')[1] }}
      ordererAddress: {{ orderer_url.split(':')[0] }}
      ordererPort: {{ orderer_url.split(':')[1] }}
