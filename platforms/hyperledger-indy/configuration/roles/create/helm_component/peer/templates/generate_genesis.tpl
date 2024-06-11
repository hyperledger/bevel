apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: "{{ component_name }}"
  annotations:
    fluxcd.io/automated: "false"
  namespace: "{{ component_ns }}"
spec:
  releaseName: "{{ component_name }}"
  interval: 1m
  chart:
    spec:
      interval: 1m
      chart: "{{ charts_dir }}/indy-genesis"
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
  values:
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
    image:
      alpineutils: "{{ network.docker.url }}/bevel-alpine-ext:latest"
    settings:
      removeKeysOnDelete: true
      secondaryGenesis: {{ secondaryGenesis }}
{% if (not secondaryGenesis) and (trustee_name is defined) %}
      trustees:
        - name: "{{ trustee_name }}"
{% if steward_list is defined %}
          stewards:
{% for steward in steward_list %}
            - name: {{ steward.name }}
              publicIp: {{ steward.publicIp }}
              nodePort: {{ steward.nodePort }}
              clientPort: {{ steward.clientPort }}
{% endfor %}
{% endif %}
{% endif %}
