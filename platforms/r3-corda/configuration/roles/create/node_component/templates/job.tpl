apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}-initial-registration
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}-initial-registration
  chart:
    path: {{ gitops.chart_source }}/{{ chart }}-initial-registration
    git: {{ gitops.git_ssh }}
    ref: {{ gitops.branch }}
  values:
    nodeName: {{ component_name }}
    replicas: 1
    metadata:
      namespace: {{ component_ns }}  
    image:
      containerName: {{ network.docker.url }}/{{ docker_image }}
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
      imagePullSecret: regcred
      privateCertificate: true
      doormanCertAlias: {{ doorman_domain | regex_replace('/', '') }}
      networkmapCertAlias: {{ nms_domain | regex_replace('/', '') }}
    nodeConf:
      p2p:
        url: {{ component_name }}.{{ component_ns }}
        port: {{ node.p2p.port|e }}
      ambassadorAddress: {{ component_name|e }}.{{ item.external_url_suffix }}:{{ node.p2p.ambassador | default('10002') }}
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
      attachmentCacheBound: 1024
      {% if chart == 'notary' %}      
      notary:
        validating: false
      {% endif %} 
      detectPublicIp: false
      database:
        transactionIsolationLevel: READ_COMMITTED
        exportHibernateJMXStatistics: false
      dbUrl: {{ component_name|e }}db
      dbPort: {{ node.dbtcp.port|e }}
      dataSourceClassName: "org.h2.jdbcx.JdbcDataSource"
      dataSourceUrl: "jdbc:h2:tcp://{{ component_name|e }}db:{{ node.dbtcp.port|e }}/persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=100;AUTO_RECONNECT=TRUE;"
      jarPath: "/data/corda-workspace/h2/bin"
{% if doorman_url|length %}
      networkMapURL: {{ nms_url | quote }}
      doormanURL: {{ doorman_url | quote }}
      compatibilityZoneURL:
{% else %}
      compatibilityZoneURL: {{ nms_url | quote }}
      networkMapURL: 
      doormanURL:
{% endif %}
      jarVersion: {{ network.version | quote }}
      devMode: false
      env:
        - name: JAVA_OPTIONS
          value: -Xmx512m
        - name: CORDA_HOME
          value: /opt/corda
        - name: BASE_DIR
          value: /base/corda
    credentials:
      dataSourceUser: sa
      rpcUser:
        - name: {{ component_name|e }}operations
          permissions: [ALL]

    volume:
      baseDir: /base/corda
    resources:
      limits: "512Mi"
      requests: "512Mi"
    
    service:
      type: ClusterIP
      p2p:
        port: {{ node.p2p.port|e }}
        targetPort: {{ node.p2p.targetPort|e }}
      rpc:
        port: {{ node.rpc.port|e }}
      rpcadmin:
        port: {{ node.rpcadmin.port|e }}

    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: corda{{ component_name }}
      serviceaccountname: vault-auth
      dbsecretprefix: {{ component_name }}/credentials/database
      rpcusersecretprefix: {{ component_name }}/credentials/rpcusers
      tokensecretprefix: {{ component_name }}/credentials/vaultroottoken
      keystoresecretprefix: {{ component_name }}/credentials/keystore
      certsecretprefix: {{ component_name }}/certs
        
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
