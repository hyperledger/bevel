apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ config.name }}-web
  annotations:
    fluxcd.io/automated: "false"
  {{ config.metadata | to_nice_yaml | indent(2) }}
spec:
  releaseName: {{ config.name }}-web
  chart:
    path: {{ org.value.config.constants.chart_path }}/springbootwebserver
    {{ org.value.config.constants.chart | to_nice_yaml | indent(4) }}
  values:
    nodeName: {{ config.name }}
    metadata:
      {{ config.metadata | to_nice_yaml | indent(6) }}
    image:
      containerName: hyperledgerlabs/corda:3.3.0-corda-webserver-test-20190219
      initContainerName: hyperledgerlabs/alpine-utils:1.0
      imagePullSecret: regcred
    nodeConf:
      {{  config['spec']['values'].nodeConf | to_nice_yaml | indent(6) }}
      useSSL: false
      controllerName: Controller
      trustStorePath: /opt/corda/certificates/sslkeystore.jks
      trustStoreProvider: jks
      tlsAlias: cordaclienttls
      port: 10004
    credentials:
      {{  config['spec']['values'].credentials | to_nice_yaml | indent(6) }}
    resources:
      limits: "512Mi"
      requests: "512Mi"
    storage:
      memory: 512Mi
      mountPath: "/opt/h2-data"
      name: {{ dlt['corda']['storageclass']['sc']['config']['name'] }}
    vault:
      address: {{ org.value.config.constants.vault_addr }}
      {{ config['spec']['values'].vault | to_nice_yaml | indent(6) }}
    db:
      readinesscheckinterval: 10
      readinessthreshold: 15
    service:
      {{  config['spec']['values'].service | to_nice_yaml | indent(6) }}
      annotations: {}
    deployment:
      annotations: {}
    pvc:
      annotations: {}
