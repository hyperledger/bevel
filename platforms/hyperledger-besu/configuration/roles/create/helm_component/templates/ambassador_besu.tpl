apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"      
spec:
  releaseName: {{ component_name }}
  chart:
    path: {{ charts_dir }}/generate_ambassador_certs
    git: {{ gitops.git_url }}
    ref: {{ gitops.branch }}
  values:
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}      
    image:      
      alpineutils: hyperledgerlabs/alpine-utils:1.0
      pullSecret: regcred
    network:
      tmtls: {{ tls_enabled }}
    node:
      name: {{ name }}
      clientport: {{ tm_clientport }} 
    vault:
      address: {{ vault.url }}
      secretengine: {{ vault.secret_path | default('secretsv2') }}
      authpath: besu{{ organisation }}
      rootcasecret: {{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}/crypto/ambassadorcerts/rootca
      ambassadortlssecret: {{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}/crypto/{{ node_name }}/tls
      role: vault-role
      serviceaccountname: vault-auth
    subject:
      ambassadortls: {{ cert_subject }}
    opensslVars:
      domain_name_pub: {{ name }}.{{ external_url_suffix }}
      domain_name_priv: {{ name }}.{{ component_ns }}
      domain_name_tessera: {{ name }}-tessera.{{ component_ns }}
    healthcheck: 
      retries: 10
      sleepTimeAfterError: 2
