apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ name }}-ca-server-job
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ name }}-ca-server-job
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/ca_server
  values:
    metadata:
      name: {{ component }}
      component_name: {{ component }}-net
      namespace: {{ component_ns }}    
      images:
        fabrictools: {{ fabrictools_image }}
        alpineutils: {{ alpine_image }}

    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ network.env.type }}{{ component_ns }}-auth
      secretcryptoprefix: {{ vault.secret_path | default('secret') }}/data/crypto/{{ component_type }}Organizations/{{ component }}-net/ca
      secretcredentialsprefix: {{ vault.secret_path | default('secret') }}/data/credentials/{{ component }}-net/ca/{{ component }}
      serviceaccountname: vault-auth
      imagesecretname: regcred
      
    ca:
      subject: {{ subject }}
