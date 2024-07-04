apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}-{{ identity_name }}-transaction
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}-{{ identity_name }}-transaction
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
      name: {{ component_name }}-{{ identity_name }}-transaction
      namespace: {{ component_ns }}
    network:
      name: {{ network.name }}
    image:
      cli:
        name: {{ component_name }}
        repository: {{ network.docker.url }}/bevel-indy-ledger-txn:latest
        pullSecret: regcred
        pullPolicy: IfNotPresent
    vault:
      address: {{ vault.url }}
      role: {{ vault_role }}
      serviceAccountName: {{ component_name }}-admin-vault-auth
      auth_path: kubernetes-{{ component_name }}-admin-auth
    organization:
      name: {{ component_name }}
      adminIdentity:
        name: {{ file_var.trustee_name }}
        did: {{ file_var.trustee_did }}
        path: {{ admin_component_name }}/data/{{ admin_type }}
      newIdentity:
        name: {{ file_var.endorser_name }}
        role: {{ newIdentityRole }}
        did: {{ file_var.endorser_did }}
        verkey: {{ file_var.endorser_verkey }}
        path: {{ component_name }}/data/endorsers
    node:
      name: {{ component_name }}
