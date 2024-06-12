apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}-{{ identity_name }}-auth-job
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}-{{ identity_name }}-auth-job
  interval: 1m
  chart:
   spec:
    chart: {{ gitops.chart_source }}/{{ chart }}
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      name: {{ component_name }}-{{ identity_name }}-auth-job
      namespace: {{ component_ns }}
    network:
      name: {{ network.name }}
      kubernetes_url: {{ kubernetes_server }}
    image:
      name: {{ component_name }}
      repository: alpine:3.9.4
      pullPolicy: IfNotPresent
    vault:
      address: {{ vault.url }}
      identity: {{ identity_name }}
      admin_auth_path: kubernetes-{{ organization }}-admin-auth
      policy: {{ organization }}-{{ identity_name }}-ro
      policy_content: {{ policy_path }} {{ policy_capabilities }}
      auth_path: kubernetes-{{ organization }}-{{ identity_name }}-auth
    account:
      admin_service: {{ organization }}-admin-vault-auth
      admin_role: rw
      service: {{ organization }}-{{ identity_name }}-vault-auth
      role: ro
