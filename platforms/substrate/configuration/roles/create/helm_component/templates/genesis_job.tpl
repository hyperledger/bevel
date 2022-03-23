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
    git: {{ org.gitops.git_url }}
    ref: {{ org.gitops.branch }}
    path: {{ charts_dir }}/substrate-genesis
  values:
    node:
      name: {{ component_name }}
      image: {{ network.docker.url }}/{{ network.config.node_image }}:{{ network.version }}
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
      # Not using /data because vault cli is used in this container
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/{{ component_ns }}
    chain: {{ network.config.chain }}
    aura_keys: {{ aura_key_list }}
    grandpa_keys: {{ grandpa_key_list }}
    members: 
      {{ member_list | to_nice_yaml | indent(width=6) }}
