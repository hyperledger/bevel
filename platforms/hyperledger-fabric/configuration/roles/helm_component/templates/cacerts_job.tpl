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
      chart: {{ charts_dir }}/generate_cacerts
  values:
    metadata:
      name: {{ component }}
      component_name: {{ component }}-net
      namespace: {{ component_ns }}    
      images:
        alpineutils: {{ alpine_image }}

    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ network.env.type }}{{ component_ns }}-auth
      secretcryptoprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/{{ component_type }}Organizations/{{ component }}-net/ca
      secretcredentialsprefix: {{ vault.secret_path | default('secretsv2') }}/data/credentials/{{ component }}-net/ca/{{ component }}
      serviceaccountname: vault-auth
      type: {{ vault.type | default("hashicorp") }}
{% if network.docker.username is defined and network.docker.password is defined %}
      imagesecretname: regcred
{% else %}
      imagesecretname: ""
{% endif %}
      
    ca:
      subject: {{ subject }}
