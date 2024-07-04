apiVersion: helm.toolkit.fluxcd.io/v2
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
    chart: {{ charts_dir }}/besu-tlscert-gen
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    image:
      alpineutils: {{ network.docker.url }}/bevel-alpine:{{ bevel_alpine_version }}
      pullSecret: regcred
      pullPolicy: IfNotPresent
    settings:
      tmTls: {{ tls_enabled }}
      certSubject: {{ cert_subject }}
      externalURL: {{ name }}.{{ external_url_suffix }}

    vault:
      address: {{ vault.url }}
      secretEngine: {{ vault.secret_path | default('secretsv2') }}
      authPath: {{ network.env.type }}{{ organisation }}
      secretPrefix: data/{{ component_ns }}/crypto/{{ node_name }}/tls
      role: vault-role
      serviceAccountName: vault-auth
      type: {{ vault.type | default("hashicorp") }}

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
