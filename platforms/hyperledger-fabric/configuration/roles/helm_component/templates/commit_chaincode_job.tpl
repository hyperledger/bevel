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
    path: {{ charts_dir }}/commit_chaincode
{% if git_protocol == 'https' %}
    secretRef:
      name: gitcredentials
{% endif %}
  values:
    metadata:
      namespace: {{ namespace }}
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
      adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ namespace }}/users/admin
      orderersecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ namespace }}/orderer
      secretpath: {{ vault.secret_path | default('secretsv2') }}
      serviceaccountname: vault-auth
      imagesecretname: regcred
      tls: false
    orderer:
      address: {{ participant.ordererAddress }}
    chaincode:
      builder: hyperledger/fabric-ccenv:{{ network.version }}
      name: {{ component_chaincode.name | lower | e }}
      version: {{ component_chaincode.version }}
      sequence: {{ component_chaincode.sequence | default('1') }}
      commitarguments: {{ component_chaincode.arguments | quote}}
      endorsementpolicies:  {{ component_chaincode.endorsements | quote }}
    channel:
      name: {{ item.channel_name | lower }}
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
