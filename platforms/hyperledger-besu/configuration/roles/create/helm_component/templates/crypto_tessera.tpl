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
    chart: {{ charts_dir }}/besu-tessera-key-mgmt
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
    peer:
      name: {{ peer.name }}
    image:
      repository: quorumengineering/tessera:hashicorp-{{ network.config.tm_version }}
      pullSecret: regcred
      pullPolicy: IfNotPresent
      alpineutils: {{ network.docker.url }}/bevel-alpine-ext:{{ bevel_alpine_version }}
    vault:
      address: {{ vault.url }}
      secretEngine: {{ vault.secret_path | default('secretsv2') }}
      authPath: {{ network.env.type }}{{ org.name | lower }}
      role: vault-role
      keyprefix: {{ component_ns }}/crypto
      serviceAccountName: vault-auth
      tmprefix: data/{{ component_ns }}/crypto
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
