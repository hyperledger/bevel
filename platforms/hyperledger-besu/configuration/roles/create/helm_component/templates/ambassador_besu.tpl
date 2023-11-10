apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/generate_ambassador_certs
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
    image:
      alpineutils: {{ network.docker.url }}/bevel-alpine:{{ bevel_alpine_version }}
      pullSecret: regcred
      pullPolicy: IfNotPresent
    network:
      tmtls: {{ tls_enabled }}
    node:
      name: {{ name }}
      clientport: {{ tm_clientport }}
    vault:
      address: {{ vault.url }}
      secretengine: {{ vault.secret_path | default('secretsv2') }}
      authpath: besu{{ organisation }}
      rootcasecret: data/{{ component_ns }}/crypto/ambassadorcerts/rootca
      ambassadortlssecret: data/{{ component_ns }}/crypto/{{ node_name }}/tls
      role: vault-role
      serviceaccountname: vault-auth
      type: {{ vault.type | default("hashicorp") }}
    subject:
      ambassadortls: {{ cert_subject }}
    opensslVars:
      domain_name_pub: {{ name }}.{{ external_url_suffix }}
      domain_name_priv: {{ name }}.{{ component_ns }}
      domain_name_tessera: {{ name }}-tessera.{{ component_ns }}
    healthcheck:
      retries: 10
      sleepTimeAfterError: 2

{% if network.env.labels is defined %}
    labels:
      service:
{% if network.env.labels.service is defined %}
{% for key in network.env.labels.service.keys() %}
        - {{ key }}: {{ network.env.labels.service[key] | quote }}
{% endfor %}
{% endif %}
      pvc:
{% if network.env.labels.pvc is defined %}
{% for key in network.env.labels.pvc.keys() %}
        - {{ key }}: {{ network.env.labels.pvc[key] | quote }}
{% endfor %}
{% endif %}
      deployment:
{% if network.env.labels.deployment is defined %}
{% for key in network.env.labels.deployment.keys() %}
        - {{ key }}: {{ network.env.labels.deployment[key] | quote }}
{% endfor %}
{% endif %}
{% endif %}
