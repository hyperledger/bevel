apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ namespace }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/invoke_chaincode
{% if git_protocol == 'https' %}
    secretRef:
      name: gitcredentials
{% endif %}
  values:
    metadata:
      namespace: {{ namespace }}
      network:
        version: {{ network.version }}
      add_organization: {{ add_organization }}
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
      secretpath: {{ vault.secret_path | default('secretsv2') }}
      adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ namespace }}/users/admin 
      orderersecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ namespace }}/orderer
      serviceaccountname: vault-auth
      imagesecretname: regcred
      tls: false
    orderer:
      address: {{ participant.ordererAddress }}
    chaincode:
      builder: hyperledger/fabric-ccenv:{{ network.version }}
      name: {{ component_chaincode.name | lower | e }}
      version: {{ component_chaincode.version }}
      invokearguments: {{ component_chaincode.arguments | quote}}
      endorsementpolicies:  {{ component_chaincode.endorsements | quote }}
    channel:
      name: {{ item.channel_name | lower }}
{% if '2.' in network.version %}
    endorsers:
      creator: {{ namespace }}
      name: {% for name in endorsers_list %}{%- for key, value in name.items() %}{% if key == 'name' %} {{ value }} {% endif %}{%- endfor %}{% endfor %}

      corepeeraddress: {% for address in endorsers_list %}{%- for key, value in address.items() %}{% if key == 'peercoreaddress' %} {{ value }} {% endif %}{% endfor -%}{% endfor %}

      nameslist: 
{% for name in endorsers_list %}
{% for key, value in name.items() %}
{% if key == 'name' %}
        - {{ key }}: {{ value }}
{% endif %}
{% endfor %}
{% endfor %}
{% else %}
    endorsers:
        creator: {{ namespace }}
        name: {{ peer_name }}
        corepeeraddress: {{ peer_address }}
{% endif %}
