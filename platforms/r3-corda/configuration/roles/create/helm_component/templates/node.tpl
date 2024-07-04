apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
    spec:
      chart: {{ gitops.chart_source }}/corda-node
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
  values:
    global:
      serviceAccountName: vault-auth
      cluster:
        provider: {{ org.cloud_provider }}
        cloudNativeServices: false
      vault:
        type: hashicorp
        network: corda
        role: vault-role
        address: {{ vault.url }}
        authPath: {{ network.env.type }}{{ name }}
        secretEngine: {{ vault.secret_path | default("secretsv2") }}
        secretPrefix: "data/{{ network.env.type }}{{ name }}"
      proxy:
        provider: {{ network.env.proxy }}
        externalUrlSuffix: {{ org.external_url_suffix }}
        p2p: {{ node.p2p.ambassador | default('15010') }}
    storage:
      size: 1Gi
      dbSize: 2Gi
      allowedTopologies:
        enabled: false
    tls:
      enabled: true
    image:
{% if network.docker.username is defined %}
      pullSecret: regcred
{% endif %}
      pullPolicy: IfNotPresent
      h2: ghcr.io/hyperledger/h2:2018
      corda: 
        repository: {{ network.docker.url }}/bevel-corda
        tag: {{ network.version }}
      initContainer: {{ network.docker.url }}/bevel-alpine:latest
      hooks:
        repository: ghcr.io/hyperledger/bevel-build
        tag: jdk8-stable
    nodeConf:
      defaultKeystorePassword: cordacadevpass
      defaultTruststorePassword: trustpass
      keystorePassword: newpass
      truststorePassword: newtrustpass
      sslkeyStorePassword: sslpass
      ssltrustStorePassword: ssltrustpass
      removeKeysOnDelete: true
      rpcUser:
        - name: nodeoperations
          password: nodeoperationsAdmin
          permissions: [ALL]
      p2pPort: {{ node.p2p.port|e }}
      rpcPort: {{ node.rpc.port|e }}
      rpcadminPort: {{ node.rpcadmin.port|e }}
      rpcSettings:
        useSsl: false
        standAloneBroker: false
        address: "0.0.0.0:{{ node.rpc.port|e }}"
        adminAddress: "0.0.0.0:{{ node.rpcadmin.port|e }}"
        ssl:
          certificatesDirectory: na-ssl-false
          sslKeystorePath: na-ssl-false
          trustStoreFilePath: na-ssl-false
      legalName: {{ node.subject|e }} #use peer-node level subject for legalName
      messagingServerAddress:
      jvmArgs:
      systemProperties:
      sshd:
        port:
      exportJMXTo:
      transactionCacheSizeMegaBytes: 8
      attachmentContentCacheSizeMegaBytes: 10    
      notary:
        enabled: false
      detectPublicIp: false
      database:
        exportHibernateJMXStatistics: false
      dbPort: {{ node.dbtcp.port|e }}
      dataSourceUser: sa
      dataSourcePassword: admin
      dataSourceClassName: "org.h2.jdbcx.JdbcDataSource"
      jarPath: "/data/corda-workspace/h2/bin"
      networkMapURL: {{ nms_url | quote }}
      doormanURL: {{ doorman_url | quote }}
      devMode: false
      javaOptions: "-Xmx512m"
{% if org.cordapps is defined %}    
    cordApps:
      getCordApps: true
      jars: {{ org.cordapps.jars }}
{% if org.cordapps.username is defined %} 
      mavenSecret: "maven-secrets"
{% endif %}
{% endif %}
    resources:
      db:
        memLimit: "1G"
        memRequest: "512M"
      node:
        memLimit: "2G"
        memRequest: "512M"
