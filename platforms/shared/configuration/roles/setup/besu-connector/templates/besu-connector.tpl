apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ component_ns | replace('_','-') }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_ns | replace('_','-') }}
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/besu-connector
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      # name: {{ component_name }}
      namespace: {{ component_ns }}
      labels:
    replicaCount: 1
    liveliness_check:
      enabled: false
    healthcheck:
      readinessthreshold: 100
      readinesscheckinterval: 5

    images:
      node: chary123/cplcb:latest
      pullPolicy: IfNotPresent
      # repository: chary123/cplcb:latest
      # pullSecret: regcred
      env:
        - name: AUTHORIZATION_PROTOCOL
          value: 'NONE'
        - name: AUTHORIZATION_CONFIG_JSON
          value: '{}'
        - name: GRPC_TLS_ENABLED
          value: 'false'
        # - name: PLUGINS
        #   value: plugins

    service:
      type: LoadBalancer
      name: test
      port: 3000
      targetPort: 3000
      nodePort: 30001

    storage:
      storageclassname: {{ storageclass_name }}
      storagesize: 1Gi

    vault:
      address: {{ vault.url }}
      secretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ component_ns }}/crypto/{{ name }}
      serviceaccountname: vault-auth
      keyname: data
      tmdir: tm
      tlsdir: tls
      role: vault-role
      authpath: besu{{ name }}

    plugins: 
      packageName: "@hyperledger/cactus-plugin-ledger-connector-besu"
      type: org.hyperledger.cactus.plugin_import_type.LOCAL
      action: org.hyperledger.cactus.plugin_import_action.INSTALL
      options:
        rpcApiHttpHost: http://validator1.app.bharatblockchain.io:15011
        rpcApiWsHost: ws://validator1.app.bharatblockchain.io:8546 
        instanceId: 12345678




