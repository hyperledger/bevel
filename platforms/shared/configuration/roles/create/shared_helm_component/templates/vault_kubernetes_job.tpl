apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/vault-k8s-mgmt
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
      images:
        alpineutils: {{ network.docker.url }}/alpine-utils:1.0
        pullPolicy: IfNotPresent

    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ component_auth }}
      policy: vault-crypto-{{ component_ns }}-{{ name }}-ro
      policydata: {{ policydata | to_nice_json }}
      secret_path: {{ vault.secret_path | default(name)}}
      imagesecretname: regcred

    k8s:
      kubernetes_url: {{ kubernetes_url }}
    
    rbac:
      create: {{ create_clusterRoleBinding }}

    serviceAccount:
      create: {{ create_serviceAccount }}
      name: vault-auth
