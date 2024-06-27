global:
  serviceAccountName: vault-auth
  cluster:
    provider: "{{ cloud_provider }}"
    cloudNativeServices: false
    kubernetesUrl: "{{ kubernetes_server }}"
  vault:
    type: hashicorp
    role: vault-role
    network: corda-enterprise
    address: "{{ vault.url }}"
    authPath: "{{ org_name }}"
    secretEngine: secretsv2
    secretPrefix: "data/{{ org_name }}"
  proxy:
    provider: ambassador
    externalUrlSuffix: {{ external_url_suffix }}
  cenm:
    sharedCreds:
      truststore: password
      keystore: password
    identityManager:
      port: 10000
      revocation:
        port: 5053
      internal:
        port: 5052
    auth:
      port: 8081
    gateway:
      port: 8080
    zone:
      enmPort: 25000
      adminPort: 12345
    networkmap:
      internal:
        port: 5050
settings:
  removeKeysOnDelete: true
tls:
  enabled: true
  settings:
    networkServices: true
storage:
  size: 1Gi
  dbSize: 5Gi
  allowedTopologies:
    enabled: false
subjects:
  auth: {{ auth_subject }}
  tlscrlsigner: {{ signer_subject}}
  tlscrlissuer: {{ idman_crlissuer_subject }}
  rootca: {{ root_ca }}
  subordinateca: {{ subordinate_ca }}
  idmanca: {{ idman_subject }}
  networkmap: {{ networkmap_subject }}
