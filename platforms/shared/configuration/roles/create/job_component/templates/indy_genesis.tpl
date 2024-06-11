global:
  serviceAccountName: vault-auth
  cluster:
    provider: "{{ cloud_provider }}"
    cloudNativeServices: false
    kubernetesUrl: "{{ kubernetes_server }}"
  vault:
    type: hashicorp
    role: vault-role
    network: indy
    address: "{{ vault.url }}"
    authPath: "{{ org_name }}"
    secretEngine: secretsv2
    secretPrefix: "data/{{ org_name }}"
proxy:
  provider: ambassador
settings:
  removeKeysOnDelete: true
  secondaryGenesis: {{ secondaryGenesis }}
{% if (not secondaryGenesis) and (trustee_list is defined) %}
  trustees:
{% for trustee in trustee_list %}
    - name: "{{ trustee }}"
{% endfor %}
{% if steward_list is defined %}
      stewards:
{% for steward in steward_list %}
        - name: "{{ steward.name }}"
          publicIp: {{ steward.publicIp }}
          nodePort: {{ steward.nodePort }}
          clientPort: {{ steward.clientPort }}
{% endfor %}
{% endif %}
{% endif %}
