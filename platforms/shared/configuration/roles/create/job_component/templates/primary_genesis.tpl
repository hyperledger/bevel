# template for besu-genesis chart/job
global:
  serviceAccountName: vault-auth
  vault:
    type: {{ vault.type | default("hashicorp") }}
    network: {{ network.type }}
    address: {{ vault.url }}
    authPath: {{ network.env.type }}{{ name }}
    secretEngine: {{ vault.secret_path | default("secretsv2") }}
    secretPrefix: "data/{{ network.env.type }}{{ name }}"
    role: vault-role
  cluster:
    provider: {{ org.cloud_provider }}
    cloudNativeServices: false
    kubernetesUrl: {{ kubernetes_url }}
{% if network.docker.password is defined %}
image:
  pullSecret: regcred
{% endif %}
rawGenesisConfig:
  genesis:
    config:
      chainId: {{ network.config.chain_id | default(2018) | int }}
      algorithm:
        consensus: {{ network.config.consensus }}
        blockperiodseconds: 10
        epochlength: 30000
        requesttimeoutseconds: 20
    gasLimit: '0x1fffffffffffff' 
    difficulty: '0x1'
    coinbase: '0x0000000000000000000000000000000000000000'
    additionalAccounts: {{ network.config.accounts }}
    permissioning: {{ network.permissioning.enabled }}
  blockchain:
    nodes:
      generate: true
      count: {{ validator_count }}
    accountPassword: 'password'    
