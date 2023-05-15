apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: {{ component_name }}
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/substrate-genesis
  values:
    node:
      name: {{ component_name }}
      image: {{ network.docker.url }}/{{ network.config.node_image }}
      imageTag: {{ network.version }}
      pullPolicy: IfNotPresent
      command: {{ network.config.command }}
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: substrate{{ name }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/{{ component_ns }}
    chain: {{ network.config.chain }}
    aura_keys: {{ aura_key_list }}
    grandpa_keys: {{ grandpa_key_list }}
    members: 
      {{ member_list | to_nice_yaml | indent(width=6) }}
