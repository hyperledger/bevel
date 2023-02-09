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
    chart: {{ charts_dir }}/tessera_key_mgmt
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
      # alpineutils image has the binaries like jq,curl, wget and openssl in it. 
      # having this image with binaries helps in removing the dependencies of utility binaries in the besu and tessera containers
      # dockerfile can be found at shared/images/apline-utils.Dockerfile
      alpineutils: "{{ network.docker.url }}/alpine-utils:{{ network.bevel_version | default('latest') }}"
    vault:
      address: {{ vault.url }}
      secretengine: {{ vault.secret_path | default('secretsv2') }}
      authpath: besu{{ org.name | lower }}
      role: vault-role
      keyprefix: {{ component_ns }}/crypto
      serviceaccountname: vault-auth
      tmprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}/crypto
