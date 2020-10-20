apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}-{{ identity_name }}-transaction
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}-{{ identity_name }}-transaction
  chart:
    path: {{ gitops.chart_source }}/{{ chart }}
    git: {{ gitops.git_ssh }}
    ref: {{ gitops.branch }}
  values:
    metadata:
      name: {{ component_name }}-{{ identity_name }}-transaction
      namespace: {{ component_ns }}
    network:
      name: {{ network.name }}
    image:
      cli:
        name: {{ component_name }}
        repository: {{ network.docker.url }}/indy-ledger-txn:latest
        pullSecret: regcred
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
        path: {{ admin_component_name }}/{{ admin_type }}
      newIdentity:
        name: {{ file_var.endorser_name }}
        role: {{ newIdentityRole }}
        did: {{ file_var.endorser_did }}
        verkey: {{ file_var.endorser_verkey }}
        path: {{ component_name }}/endorsers
    node:
      name: {{ component_name }}
