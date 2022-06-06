apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ name }}-vaultkubenertes-job
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ name }}-vaultkubenertes-job
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/vault_kubernetes
{% if git_protocol == 'https' %}
    secretRef:
      name: gitcredentials
{% endif %}
  values:
    metadata:
      name: {{ name }}
      component_type: {{ component_type }}
      namespace: {{ component_ns }}    
      images:
        alpineutils: {{ alpine_image }}

    vault:
      reviewer_service: vault-reviewer
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ network.env.type }}{{ component_ns }}-auth
      policy: vault-crypto-{{ component_type }}-{{ name }}-net-ro
      secret_path: {{ vault.secret_path }}
      serviceaccountname: vault-auth
      imagesecretname: regcred
    
    k8s:
      kubernetes_url: {{ kubernetes_url }}
