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
{% if network.env.proxy == 'none' %}
  address: {{ peer.name }}.{{ component_ns }}:7051
{% else %}
  address: {{ peer.peerAddress }}
{% endif %}
orderer:
  address: {{ participant.ordererAddress }}
