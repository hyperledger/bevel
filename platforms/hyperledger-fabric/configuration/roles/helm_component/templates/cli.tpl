apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: {{ component_name }}
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/fabric-cli    
  values:
    metadata:
      namespace: {{ component_ns }}
      images:
        fabrictools: {{ docker_url }}/{{ fabric_tools_image[network.version] }}
        alpineutils: {{ docker_url }}/{{ alpine_image }}
    storage:
      class: {{ sc_name }}
      size: 256Mi
    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ org.k8s.cluster_id | default('')}}{{ network.env.type }}{{ org.name | lower }}
      adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}/peerOrganizations/{{ component_ns }}/users/admin
      orderersecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}/peerOrganizations/{{ component_ns }}/orderer
      serviceaccountname: vault-auth
      type: {{ vault.type | default("hashicorp") }}
{% if network.docker.username is defined and network.docker.password is defined %}
      imagesecretname: regcred
{% else %}
      imagesecretname: ""
{% endif %}
      tls: false
    peer:
      name: {{ peer.name }}
      localmspid: {{ org.name | lower}}MSP
      tlsstatus: true
{% if network.env.proxy == 'none' %}
      address: {{ peer.name }}.{{ component_ns }}:7051
{% else %}
      address: {{ peer.peerAddress }}
{% endif %}
    orderer:
      address: {{ orderer.uri }}
{% if network.env.labels is defined %}
    labels:
{% if network.env.labels.service is defined %}
      service:
{% for key in network.env.labels.service.keys() %}
        - {{ key }}: {{ network.env.labels.service[key] | quote }}
{% endfor %}
{% endif %}
{% if network.env.labels.pvc is defined %}
      pvc:
{% for key in network.env.labels.pvc.keys() %}
        - {{ key }}: {{ network.env.labels.pvc[key] | quote }}
{% endfor %}
{% endif %}
{% if network.env.labels.deployment is defined %}
      deployment:
{% for key in network.env.labels.deployment.keys() %}
        - {{ key }}: {{ network.env.labels.deployment[key] | quote }}
{% endfor %}
{% endif %}
{% endif %}
