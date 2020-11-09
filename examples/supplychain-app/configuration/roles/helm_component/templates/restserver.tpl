apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ name }}-restserver
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  chart:
    path: {{ component_gitops.chart_source }}/fabric-restserver
    git: {{ component_gitops.git_ssh }}
    ref: {{ component_gitops.branch }}
  releaseName: {{ name }}-restserver
  values:
    metadata:
      namespace: {{ component_ns }}
    server:
      name: {{ name }}-restserver
      port: {{ peer_restserver_port }}
      localmspid: {{ name }}MSP
      image: {{ network.docker.url }}/supplychain_fabric:rest_server_latest
      username: admin
      cert_path: "/secret/tls/admin.cert"
      key_path: "/secret/tls/admin.pem"
    storage:
      storageclassname: {{ name }}sc
      storagesize: 512Mi
    vault:
      address: {{ component_vault.url }}
      role: vault-role
      authpath: {{ component_ns }}-auth
      secretprefix: {{ component_vault.secret_path | default('secret') }}/crypto/peerOrganizations/{{ component_ns }}
      serviceaccountname: vault-auth
      imagesecretname: regcred
      image: hyperledgerlabs/alpine-utils:1.0
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