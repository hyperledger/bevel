apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: channel-{{ org.name | lower }}-{{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: osn-channel-{{ org.name | lower }}-{{ component_name }}
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/fabric-osnadmin-channel-create   
  values:
    metadata:
      namespace: {{ component_ns }}
      network:
        version: {{ network.version }}
      images:
        fabrictools: {{ docker_url }}/{{ fabric_tools_image[network.version] }}
        alpineutils: {{ docker_url }}/{{ alpine_image }}

    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ org.k8s.cluster_id | default('')}}{{ network.env.type }}{{ org.name | lower }}
      adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}/ordererOrganizations/{{ component_ns }}/users/admin
      orderersecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}/ordererOrganizations/{{ component_ns }}/orderers 
      serviceaccountname: vault-auth
      type: {{ vault.type | default("hashicorp") }}
{% if network.docker.username is defined and network.docker.password is defined %}
      imagesecretname: regcred
{% else %}
      imagesecretname: ""
{% endif %}
    
    channel:
      name: {{ component_name }}
    orderers:
      orderer_info: {% for orderer in orderers_list %}{% for key, value in orderer.items() %}{% if key == 'name' %}{{ value }}{% endif %}{% endfor %}*{% endfor %}

    add_orderer: {{ add_orderer_value }}

{% if add_orderer is not defined or add_orderer is sameas false  %}
    genesis: |-
{{ genesis | indent(width=6, first=True) }}
{% else %}
    orderer:
      name: {{ first_orderer.name }}
      localmspid: {{ org.name | lower}}MSP
      address: {{ first_orderer.ordererAddress }}
{% endif %}
