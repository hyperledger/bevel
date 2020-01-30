apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}-{{ identity_name }}
  annotations:
    flux.weave.works/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}-{{ identity_name }}
  chart:
    path: {{ gitops.chart_source }}/{{ chart }}
    git: {{ gitops.git_ssh }}
    ref: {{ gitops.branch }}
  values:
    metadata:
      name: {{ component_name }}-{{ identity_name }}
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
      role: {{ vault.role }}
      serviceAccountName: {{ vault.serviceAccountName }}
      authpath: {{ auth_path }}
    organization:
      name: 
        adminIdentity:
          name: {{ file_var.trustee_name }}
          did: {{ file_var.trustee_did }}
        newIdentity:
          name: {{ file_var.endorser_name }}
          role: {{ newIdentity_role }}
          did: {{ file_var.endorser_did }}
          verkey: {{ file_var.endorser_verkey }}
    node:
      name: {{ component_name }}
