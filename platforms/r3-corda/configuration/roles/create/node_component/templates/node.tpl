apiVersion: helm.toolkit.fluxcd.io/v2beta1
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
      chart: {{ gitops.chart_source }}/{{ chart }}
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
  values:
    nodeName: {{ component_name }}
    replicas: 1
    metadata:
      namespace: {{ component_ns }}
    image:
      containerName: {{ network.docker.url }}/{{ docker_image }}
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
{% if network.docker.username is defined %}
      imagePullSecret: regcred
{% endif %}
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
      {% if chart == 'notary' %}      
      notary:
        validating: {{ node.validating }}
        serviceLegalName: {{ node.serviceName | default() }}
      {% endif %} 
      detectPublicIp: false
      database:
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

{% if cordapps_details|length %}
    cordapps:
      getcordapps: true
      jars:
        {% for jars in cordapps.jars %}
- url: {{ jars.jar.url }}
        {% endfor %}
{% else %}
    cordapps:
      getcordapps: false
{% endif %}

    volume:
      baseDir: /base/corda
    resources:
      limits: "1Gi"
      requests: "1Gi" 
    pvc:
      name: {{ component_name|e }}-pvc
      annotations: {}
      memory: 512Mi
      storageClassName: {{ sc_name }}

    service:
      name: {{ component_name|e }}
      type: ClusterIP
      p2p:
        port: {{ node.p2p.port|e }}
        targetPort: {{ node.p2p.targetPort|e }}
      rpc:
        port: {{ node.rpc.port|e }}
        targetPort: {{ node.rpc.targetPort|e }} 
      rpcadmin:
        port: {{ node.rpcadmin.port|e }}
        targetPort: {{ node.rpcadmin.targetPort|e }}
         
    deployment:
      annotations: {}
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: corda{{ component_name }}
      serviceaccountname: vault-auth
      dbsecretprefix: {{ component_name }}/data/credentials/database
      rpcusersecretprefix: {{ component_name }}/data/credentials/rpcusers
      keystoresecretprefix: {{ component_name }}/data/credentials/keystore
      certsecretprefix: {{ component_name }}/data/certs
      networkmapsecretprefix: {{ component_name }}/data/credentials/networkmappassword
      cordappsreposecretprefix: {{ component_name }}/data/credentials/cordapps
      retries: 10

          
    healthcheck:
      readinesscheckinterval: 20
      readinessthreshold: 20
{% if network.env.proxy == 'ambassador' %}
    ambassador:
      component_name: {{ component_name | e }}
      external_url_suffix: {{ item.external_url_suffix }}
      p2p_ambassador: {{ node.p2p.ambassador | default('10002') }}
{% endif %}
