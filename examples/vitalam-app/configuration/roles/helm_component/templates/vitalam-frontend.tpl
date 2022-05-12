apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ name }}-web
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  chart:
    path: {{ charts_dir }}/vitalam-frontend
    git: "{{ component_gitops.git_url }}"
    ref: "{{ component_gitops.branch }}"
  releaseName: {{ name }}-web
  values:
    fullNameOverride: {{ name }}-web
    config:
      port: 80      
      logLevel: info      
      enableLivenessProbe: true
      applicationConfig:
        authDomain: {{ auth_issuer | urlsplit('hostname') }}
        clientID: {{ auth_clientId }}
        authAudience: {{ auth_audience }}
        apiScheme: https
        apiHost: {{ name }}-api.{{ org.external_url_suffix }}
        apiPort: {{ peer.api.ambassador }}
        substrateHost: "{{ name }}"
        substratePort: {{ peer.ws.port }}         
        inteliDemoPersona: {{ peer.persona }}
        inteliCustIdentity: {{ cust_peer_id }}
        inteliAmIdentity: {{ am_peer_id }}
        inteliLabIdentity: {{ lab_peer_id }}
        inteliAmlabIdentity: {{ amlab_peer_id | default(lab_peer_id) }}
    replicaCount: 1
    image:
      repository: ghcr.io/inteli-poc/inteli-demo
      pullPolicy: Always
      tag: 'v3.0.1'

    vault:
      alpineutils: ghcr.io/hyperledger/alpine-utils:1.0
      address: {{ component_vault.url }}
      secretprefix: {{ component_vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}/{{ peer.name }}
      serviceaccountname: vault-auth
      role: vault-role
      authpath: substrate{{ org.name | lower }}

    proxy:
      provider: {{ network.env.proxy }}
      name: {{ org.name | lower }} 
      external_url_suffix: {{ org.external_url_suffix }}      
      certSecret: {{ org.name | lower }}-ambassador-certs
