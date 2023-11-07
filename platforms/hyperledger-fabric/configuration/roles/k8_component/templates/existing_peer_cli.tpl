metadata:
  namespace: {{ component_ns }}
  images:
    fabrictools: {{ docker_url }}/{{ fabric_tools_image[network.version] }}
    alpineutils: {{ docker_url }}/{{ alpine_image }}

storage:
  class: {{ storage_class }}
  size: 256Mi
vault:
  role: vault-role
  address: {{ vault.url }}
{% if org.k8s.cluster_id is defined %}
  authpath: {{ org.k8s.cluster_id }}{{ component_ns }}-auth
{% else %}
  authpath: {{ network.env.type }}{{ component_ns }}-auth
{% endif %}
  adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ component_ns }}/users/admin
  orderersecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ component_ns }}/orderer
  serviceaccountname: vault-auth
  type: {{ vault.type | default("hashicorp") }}
{% if network.docker.username is defined and network.docker.password is defined %}
  imagesecretname: regcred
{% else %}
  imagesecretname: ""
{% endif %}
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

