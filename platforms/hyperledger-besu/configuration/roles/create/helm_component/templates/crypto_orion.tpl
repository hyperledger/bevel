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
    chart: {{ charts_dir }}/orion_key_mgmt
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
    image:
      repository: pegasyseng/orion:{{ network.config.tm_version }}
      pullSecret: regcred
      pullPolicy: IfNotPresent
    vault:
      address: {{ vault.url }}
      authpath: besu{{ org.name | lower }}
      role: vault-role
      serviceaccountname: vault-auth
      secretengine: {{ vault.secret_path | default('secretsv2') }}
      tmprefix: data/{{ component_ns }}/crypto/{{ peer.name }}/tm
      type: {{ vault.type | default("hashicorp") }}
      retries: 30
    sleepTimeAfterError: 60
    sleepTime: 10
    healthcheck:
      readinesscheckinterval: 5
      readinessthreshold: 2

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
