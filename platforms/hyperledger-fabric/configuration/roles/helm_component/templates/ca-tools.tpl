apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}-ca-tools
  namespace: {{ component_name }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}-ca-tools
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/catools
  values:
    metadata:
      namespace: {{ component_name }}
      name: ca-tools
      component_type: {{ component_type }}
      org_name: {{ org_name }}
      proxy: {{ proxy }}
{% if network.env.annotations is defined %}
    annotations:  
      service:
{% for item in network.env.annotations.service %}
{% for key, value in item.items() %}
        - {{ key }}: {{ value | quote }}
{% endfor %}
{% endfor %}
      pvc:
{% for item in network.env.annotations.pvc %}
{% for key, value in item.items() %}
        - {{ key }}: {{ value | quote }}
{% endfor %}
{% endfor %}
      deployment:
{% for item in network.env.annotations.deployment %}
{% for key, value in item.items() %}
        - {{ key }}: {{ value | quote }}
{% endfor %}
{% endfor %}
{% endif %}
    replicaCount: 1

    image:
      repository: hyperledger/fabric-ca-tools
      tag: 1.2.1
      pullPolicy: IfNotPresent
      alpineutils: {{ alpine_image }}
      
    storage:
      storageclassname: {{ component | lower }}sc
      storagesize: 512Mi
    
    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ network.env.type }}{{ component_name }}-auth
      secretmsp: {{ vault.secret_path | default('secret') }}/data/crypto/{{ component_type }}Organizations/{{ component_name }}/users/admin/msp
      secrettls: {{ vault.secret_path | default('secret') }}/data/crypto/{{ component_type }}Organizations/{{ component_name }}/users/admin/tls
      secretorderer: {{ vault.secret_path | default('secret') }}/data/crypto/{{ component_type }}Organizations/{{ component_name }}/orderers
      secretambassador: {{ vault.secret_path | default('secret') }}/data/crypto/{{ component_type }}Organizations/{{ component_name }}/ambassador
      secretcert: {{ vault.secret_path | default('secret') }}/data/crypto/{{ component_type }}Organizations/{{ component_name | e }}/ca?ca.{{ component_name | e }}-cert.pem
      secretkey: {{ vault.secret_path | default('secret') }}/data/crypto/{{ component_type }}Organizations/{{ component_name | e }}/ca?{{ component_name | e }}-CA.key
      serviceaccountname: vault-auth
      imagesecretname: regcred
    
    org_data:
      external_url_suffix: {{ external_url_suffix }}
      component_subject: {{ component_subject }}
      cert_subject: {{ cert_subject }}
      component_country: {{ component_country }}
      component_state: {{ component_state }}
      component_location: {{ component_location }}
      ca_url: {{ ca_url }}

{% if item.type  == 'orderer' %}
    orderers:
      name: {% for orderer in orderers_list %}{% for key, value in orderer.items() %}{% if key == 'name' %}{{ value }}-{% endif %}{% endfor %}{% endfor %}
{% endif %}
