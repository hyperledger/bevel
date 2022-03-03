apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ name }}-api
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  chart:
    path: {{ component_gitops.chart_source }}/substrate-api
    git: "{{ component_gitops.git_url }}"
    ref: "{{ component_gitops.branch }}"
  releaseName: {{ name }}{{ network.type }}-api
  values:
    metadata:
      namespace: {{ component_ns }}
      replicaCount: 1

    images:
      alpineutils: hyperledgerlabs/alpine-utils:1.0

    vault:
      address: {{ component_vault.url }}
      secretprefix: {{ component_vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}
      serviceaccountname: vault-auth
      role: vault-role
      authpath: substrate{{ name }}

    node:
      peerName: {{ name }}
      type: {{ peer_type }}

    api:
      image:
        repository: {{ api_image }}
        tag: latest
        pullPolicy: Always
        pullSecrets:
      port: {{ peer_api_port }}
      serviceType: ClusterIP

    env:
      logLevel: info
      ipfsPort: {{ ipfs_api_port }}
      port: 80
      auth:
        jwksUri: {{ auth_jwksUri }}
        audience: {{ auth_audience }}
        issuer: {{ auth_issuer }}
        tokenUrl: {{ auth_tokenUrl }}

    proxy:
      provider: {{ network.env.proxy }}
      name: {{ organization_data.name }}
      external_url_suffix: {{ organization_data.external_url_suffix }}
      peer_name: {{ name }}
