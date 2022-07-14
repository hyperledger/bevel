apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ name }}-id-service
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  chart:
    path: {{ charts_dir }}/dscp-identity-service
    git: "{{ component_gitops.git_url }}"
    ref: "{{ component_gitops.branch }}"
  releaseName: {{ name }}-id-service
  values:
    fullNameOverride: {{ name }}-id-service
    config:
      externalNodeHost: {{ name }}
      externalPostgresql: {{ db_address }}.{{ component_ns }}
      port: {{ peer.id_service.port }}
      logLevel: info
      dbName: {{ db_name }}
      dbPort: {{ db_port }}
      enableLivenessProbe: true
      selfAddress: {{ account_addr }}
      auth:
        type: {{ auth_type }}
        jwksUri: {{ auth_jwksUri }}
        audience: {{ auth_audience }}
        issuer: {{ auth_issuer }}
        tokenUrl: {{ auth_tokenUrl }}
    ingress:
      enabled: false
      # annotations: {}
      # className
      paths:
        - /v1/members
    replicaCount: 1
    image:
      repository: ghcr.io/digicatapult/dscp-identity-service
      pullPolicy: IfNotPresent
      tag: 'v1.4.0'
      pullSecrets: ['ghcr-digicatapult']

    postgresql:
      enabled: false
      postgresqlDatabase: {{ db_name }}
      postgresqlUsername: postgres
      postgresqlPassword: {{ db_password }}
    dscpNode:
      enabled: false

    proxy:
      provider: {{ network.env.proxy }}
      name: {{ org.name | lower }} 
      external_url_suffix: {{ org.external_url_suffix }}
      port: {{ peer.id_service.ambassador }}
      issuedFor: {{ org.name | lower }}
