apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/vault-k8s-mgmt
  values:
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}    
      images:
        alpineutils: {{ alpine_image }}

    vault:
      reviewer_service: vault-reviewer
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ component_auth }}
      policy: vault-crypto-{{ component_type }}-{{ name }}-ro
      policydata: {{ policydata | to_nice_json }}
      secret_path: {{ vault.secret_path }}
      serviceaccountname: vault-auth
      imagesecretname: regcred
    
    k8s:
      kubernetes_url: {{ kubernetes_url }}
