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
  name: {{ peer_name }}
  localmspid: {{ org.name | lower}}MSP
  tlsstatus: true
  address: {{ peer_address }}
orderer:
  address: {{ participant.ordererAddress }}
