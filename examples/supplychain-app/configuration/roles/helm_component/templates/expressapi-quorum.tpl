apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ name }}-expressapi
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  chart:
    path: {{ component_gitops.chart_source }}/expressapp-quorum
    git: "{{ component_gitops.git_ssh }}"
    ref: "{{ component_gitops.branch }}"
  releaseName: {{ name }}{{ network.type }}-expressapi
  values:
    nodeName: {{ name }}-expressapi
    metadata:
      namespace: {{ component_ns }}
    replicaCount: 1
    vault:
      address: {{ organization_data.vault.url }}
      secretprefix: secret/{{ component_ns }}/smartContracts
      serviceaccountname: vault-auth
      keyname: General
      role: vault-role
      authpath: quorum{{ name }}
    images:
      alpineutils: {{ network.docker.url }}/alpine-utils:1.0
    expressapp:
      serviceType: ClusterIP
      image: {{ network.docker.url }}/{{ expressapi_image }}
      pullPolicy: Always
      pullSecrets: regcred
      nodePorts:
        port: {{ peer_expressapi_port }}
        targetPort: {{ peer_expressapi_targetport }}
        name: tcp
      env:
        geth_address: {{ geth_address }}
        node_subject: {{ peer_data.subject }}
        node_organization: {{ organization_data.unit }}
        node_organization_unit: {{ organization_data.unit | lower }}
    proxy:
      provider: {{ network.env.proxy }}
      name: {{ organization_data.name }}
      type: quorum
      external_url_suffix: {{ organization_data.external_url_suffix }}
      peer_name: {{ name }}
