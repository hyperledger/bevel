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
  adminsecretprefix: secret/crypto/ordererOrganizations/{{ component_ns }}/users/admin
  orderersecretprefix: secret/crypto/ordererOrganizations/{{ component_ns }}/orderers/{{ orderer_component }}
  serviceaccountname: vault-auth
  imagesecretname: regcred
  tls: false
peer:
  name: {{ orderer_name }}
  localmspid: {{ org.name | lower}}MSP
  tlsstatus: true
{% if network.env.proxy == 'none' %}
  address: {{ orderer_name }}.{{ component_ns }}:7051
{% else %}
  address: {{ orderer_address }}
{% endif %}
orderer:
  address: {{ orderer_address }}
