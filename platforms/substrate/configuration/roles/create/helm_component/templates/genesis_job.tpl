apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name | replace('_','-') }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: {{ component_name | replace('_','-') }}
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/substrate-genesis
  values:
    global:
      serviceAccountName: vault-auth
      cluster:
        provider: azure
        cloudNativeServices: false
        kubernetesUrl: {{ kubernetes_url }}
      vault:
        type: hashicorp
        role: vault-role
        network: substrate
        address: {{ vault.url }}
        authPath: {{ network.env.type }}
        secretEngine: {{ vault.secret_path | default("secretsv2") }}
        certPrefix: {{ network.env.type }}{{ org_name }}
        secretPrefix: "data/{{ network.env.type }}{{ org_name }}"
    removeGenesisOnDelete:
      enabled: true
      image:
        repository: ghcr.io/hyperledger/bevel-k8s-hooks
        tag: qgt-0.2.12
        pullPolicy: IfNotPresent
    chain: {{ network.config.chain }}
    node:
      name: {{ component_name }}
      image: {{ network.docker.url }}/{{ network.config.node_image }}
      imageTag: {{ network.version }}
      pullPolicy: IfNotPresent
      command: {{ network.config.command }}
      validator:
        count: {{ validator_count }}
      member:
        count: {{ member_count }}
        balance: 1152921504606846976
