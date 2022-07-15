apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ name }}-inteli-api
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  chart:
    path: {{ charts_dir }}/inteli-api
    git: "{{ component_gitops.git_url }}"
    ref: "{{ component_gitops.branch }}"
  releaseName: {{ name }}-inteli-api
  values:
    fullnameOverride: {{ name }}-inteli-api
    config:
      port: {{ peer.inteli_api.port }}
      externalPostgresql: {{ db_address }}.{{ component_ns }}
      dbName: {{ peer.postgresql.database_name }}
      dbPort: {{ peer.postgresql.port }}
      dscpApiHost: {{ dscp_api_addr }}.{{ component_ns }}
      dscpApiPort: {{ peer.api.port }}
      logLevel: info
      identityServiceHost: {{ id_service_addr }}.{{ component_ns }}
      identityServicePort: {{ peer.id_service.port }}
      auth:
        type: {{ auth_type }}
        jwksUri: {{ auth_jwksUri }}
        audience: {{ auth_audience }}
        issuer: {{ auth_issuer }}
        tokenUrl: {{ auth_tokenUrl }}

    deployment:
      annotations: {}
      livenessProbe:
        enabled: true
      replicaCount: 1

    ingress:
      enabled: false
      annotations: {}
      # className: ""
      paths:
        - /v1/attachment
        - /v1/build
        - /v1/order
        - /v1/part
        - /v1/recipe

    service:
      annotations: {}
      enabled: false
      port: 

    image:
      repository: ghcr.io/digicatapult/inteli-api
      pullPolicy: IfNotPresent
      tag: 'v1.28.0'
      pullSecrets: ['ghcr-digicatapult']

    postgresql:
      enabled: false
      postgresqlDatabase: {{ peer.postgresql.database_name }}
      postgresqlUsername: postgres
      postgresqlPassword: {{ peer.postgresql.password }}


    proxy:
      provider: {{ network.env.proxy }}
      name: {{ org.name | lower }} 
      external_url_suffix: {{ org.external_url_suffix }}
      port: {{ peer.inteli_api.ambassador }}
      issuedFor: {{ org.name | lower }}
