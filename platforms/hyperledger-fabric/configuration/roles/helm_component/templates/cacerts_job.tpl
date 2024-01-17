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
    metadata:
      name: {{ component }}
      component_name: {{ component }}-net
      namespace: {{ component_ns }}    
      images:
       alpineutils: {{ docker_url }}/{{ alpine_image }}
    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ item.k8s.cluster_id | default('')}}{{ network.env.type }}{{ item.name | lower }}
      secretcryptoprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ item.name | lower }}/{{ component_type }}Organizations/{{ component }}-net/ca
      secretcredentialsprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ item.name | lower }}/credentials/{{ component }}-net/ca/{{ component }}
      serviceaccountname: vault-auth
      type: {{ vault.type | default("hashicorp") }}
{% if network.docker.username is defined and network.docker.password is defined %}
      imagesecretname: regcred
{% else %}
      imagesecretname: ""
{% endif %}
      
    ca:
      subject: {{ subject }}
