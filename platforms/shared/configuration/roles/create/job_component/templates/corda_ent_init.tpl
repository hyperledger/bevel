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
settings:
  secondaryInit: {{ secondaryInit }}
