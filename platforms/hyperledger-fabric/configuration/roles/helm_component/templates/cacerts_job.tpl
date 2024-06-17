apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ name }}-cacerts-job
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: {{ name }}-cacerts-job
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/fabric-cacerts-gen
  values:
    global:
      serviceAccountName: vault-auth
      cluster:
        provider: {{ org.cloud_provider }}
        cloudNativeServices: false
      vault:
        type: hashicorp
        network: fabric
        address: {{ vault.url }}
        authPath: {{ network.env.type }}{{ component }}
        secretEngine: {{ vault.secret_path | default("secretsv2") }}
        secretPrefix: "data/{{ network.env.type }}{{ component }}"
        role: vault-role
      proxy:
        provider: {{ network.env.proxy }}
        externalUrlSuffix: {{ org.external_url_suffix }}

    image:
      alpineUtils: {{ docker_url }}/bevel-alpine:{{ bevel_alpine_version }}
{% if network.docker.username is defined and network.docker.password is defined  %}
      pullSecret: regcred
{% else %}
      pullSecret: ""
{% endif %}
    
    ca:
      orgName: {{ name }}
      subject: {{ subject }}
