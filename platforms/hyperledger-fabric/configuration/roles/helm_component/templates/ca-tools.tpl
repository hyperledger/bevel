apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}-ca-tools
  namespace: {{ component_name }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: {{ component_name }}-ca-tools
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/catools
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
      secretusers: {{ vault.secret_path | default('secretsv2') }}/data/crypto/{{ component_type }}Organizations/{{ component_name }}/users
      secretorderer: {{ vault.secret_path | default('secretsv2') }}/data/crypto/{{ component_type }}Organizations/{{ component_name }}/orderers
      secretpeer: {{ vault.secret_path | default('secretsv2') }}/data/crypto/{{ component_type }}Organizations/{{ component_name }}/peers
      secretpeerorderertls: {{ vault.secret_path | default('secretsv2') }}/data/crypto/{{ component_type }}Organizations/{{ component_name }}/orderer/tls
      secretambassador: {{ vault.secret_path | default('secretsv2') }}/data/crypto/{{ component_type }}Organizations/{{ component_name }}/ambassador
      secretcert: {{ vault.secret_path | default('secretsv2') }}/data/crypto/{{ component_type }}Organizations/{{ component_name | e }}/ca?ca.{{ component_name | e }}-cert.pem
      secretkey: {{ vault.secret_path | default('secretsv2') }}/data/crypto/{{ component_type }}Organizations/{{ component_name | e }}/ca?{{ component_name | e }}-CA.key
      secretcouchdb: {{ vault.secret_path | default('secretsv2') }}/data/credentials/{{ component_name }}/couchdb/{{ org_name }}
      secretconfigfile: {{ vault.secret_path | default('secretsv2') }}/data/crypto/{{ component_type }}Organizations/{{ component_name | e }}/msp/config
      serviceaccountname: vault-auth
      imagesecretname: regcred
    
    healthcheck: 
      retries: 10
      sleepTimeAfterError: 2

    
    org_data:
      external_url_suffix: {{ external_url_suffix }}
      component_subject: {{ component_subject }}
      cert_subject: {{ cert_subject }}
      component_country: {{ component_country }}
      component_state: {{ component_state }}
      component_location: {{ component_location }}
      ca_url: {{ ca_url }}

    orderers:
      name: {% for orderer in orderers_list %}{% for key, value in orderer.items() %}{% if key == 'name' %}{{ value }}-{% endif %}{% endfor %}{% endfor %}

{% if item.type  == 'peer' %}
    orderers_info:
{% for orderer in orderers_list %}
{% for key, value in orderer.items() %}
{% if key == 'name' %}
      - {{ key }}: {{ value }}
        path: "certs/{{ value }}-ca.crt"
{% endif %}
{% endfor %}
{% endfor %}

    peers:
      name: {% for peer in peers_list %}{% for key, value in peer.items() %}{% if key == 'name' %}{{ value }},{% endif %}{% if key == 'peerstatus' %}{{ value }}{% endif %}{% endfor %}-{% endfor %}
      
    peer_count: "{{ peer_count }}"
{% if item.users is defined %}
    users: 
      users_list: "{{ user_list | b64encode }}"
      users_identities: {% for user in user_list %}{% for key, value in user.items() %}{% if key == 'identity' %}{{ value }}{% endif %}{% endfor %}-{% endfor %}
{% endif %}

{% if add_peer_value  == 'true' %}
    new_peer_count: "{{ new_peer_count }}"
{% endif %}
    checks:
      refresh_cert_value: {{ refresh_cert_value }}
      add_peer_value: {{ add_peer_value }}
{% endif %}
