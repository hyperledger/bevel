apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/corda-ent-notary
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    nodeName: {{ component_name }}
    metadata:
      namespace: {{ component_ns }}
    image:
      initContainerName: {{ network.docker.url }}/{{ init_container_image }}
      nodeContainerName: {{ network.docker.url }}/{{ main_container_image }}
      imagePullSecret: regcred
      pullPolicy: IfNotPresent
      privateCertificate: true
    vault:
      address: {{ org.vault.url }}
      certSecretPrefix: {{ org.vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}
      serviceAccountName: vault-auth
      role: vault-role
      authPath: cordaent{{ org.name | lower }}
      retries: 30
      retryInterval: 10
    service:
      p2pPort: {{ notary_service.p2p.port }}
      sshdPort: 2222
      rpc:
        address: "0.0.0.0"
        addressPort: 10003
        admin:
          address: "localhost"
          addressPort: 10770
        standAloneBroker: false
        useSSL: false
        users:
          username: notary
          password: notaryP
    networkServices:
      doormanURL: {{ idman_url }}
      idmanDomain: {{ idman_domain }}
      networkMapURL: {{ networkmap_url }}
      networkMapDomain: {{ networkmap_domain }}
      idmanName: "{{ network | json_query('network_services[?type==`idman`].name') | first }}"
      networkmapName: "{{ network | json_query('network_services[?type==`networkmap`].name') | first }}"
    dataSourceProperties:
      dataSource:
        password: "{{ notary_service.name }}-db-password"
        url: "jdbc:h2:tcp://{{ component_name }}db:{{ notary_service.dbtcp.port }}/persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=100;AUTO_RECONNECT=TRUE;"
        user: "{{ notary_service.name }}-db-user"
      dataSourceClassName: "org.h2.jdbcx.JdbcDataSource"
      dbUrl: "{{ component_name }}db"
      dbPort: {{ notary_service.dbtcp.port }}
{% if (org.cordapps is defined) and (org.cordapps|length > 0) %}
    cordapps:
      getcordapps: true
      jars:
        {% for jars in org.cordapps.jars %}
- url: {{ jars.jar.url }}
        {% endfor %}
{% else %}
    cordapps:
      getcordapps: false
{% endif %}

    nodeConf:
      legalName: {{ notary_service.subject }}
      emailAddress: {{ notary_service.emailAddress }}
      notaryPublicIP: {{ notary_service.name }}.{{ org.external_url_suffix }}
      devMode: false
      notary:
        serviceLegalName: {{ notary_service.serviceName }}
        validating: {{ notary_service.validating }}
        type: {{ org.type }}
      p2p:
        url: {{ component_name }}.{{ component_ns }}
      ambassador:
        p2pPort: {{ notary_service.p2p.ambassador | default('10002') }}
        external_url_suffix: {{ org.external_url_suffix }}
        p2pAddress: {{ component_name }}.{{ org.external_url_suffix }}:{{ notary_service.p2p.ambassador | default('10002') }}
      jarPath: bin
      configPath: etc
      cordaJar:
        memorySize: 1524
        unit: M
      volume:
        baseDir: /opt/corda/base
      pod:
        resources:
          limits: 2056M
          requests: 2056M
      storage:
        name: {{ sc_name }}
        memory: 512Mi
      replicas: 1
    healthCheckNodePort: 0
    sleepTimeAfterError: 60
    sleepTime: 10
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
