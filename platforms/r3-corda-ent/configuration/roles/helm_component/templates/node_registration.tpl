apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/node-initial-registration
  values:
    nodeName: {{ node_name }}-registration
    metadata:
      namespace: {{ component_ns }}
      labels:
    image:
      initContainerName: {{ network.docker.url }}/{{ init_image }}
      nodeContainerName: {{ network.docker.url }}/{{ docker_image }}
      imagepullsecret: {{ image_pull_secret }}
      pullPolicy: Always
    truststorePassword: password
    keystorePassword: password
    acceptLicence: true
    networkServices:
      doormanURL: {{ doorman_url }}
      networkMapURL: {{ networkmap_url }} 
      idmanDomain: "{{ doorman_url.split(':')[1] | regex_replace('/', '') }}"
      networkMapDomain: "{{ networkmap_url.split(':')[1] | regex_replace('/', '') }}"
      idmanName: "{{ network | json_query('orderers[?type==`idman`].name') | first }}"
      networkmapName: "{{ network | json_query('orderers[?type==`networkmap`].name') | first }}"
    vault:
      address: {{ org.vault.url }}
      role: vault-role
      authpath: cordaent{{ org.name | lower }}
      serviceaccountname: vault-auth
      certsecretprefix: secret/{{ org.name | lower }}/{{ peer.name }}
      nodePath: {{ peer.name | lower }}
      retries: 30
      retryInterval: 30
    nodeConf:
      ambassador:
        external_url_suffix: {{ org.external_url_suffix }}
        p2pPort: {{ peer.p2p.ambassador }}
        p2pAddress: {{ node_name }}.{{ org.external_url_suffix }}:{{ peer.p2p.ambassador | default('10002') }}
      legalName: "{{ org.subject }}"
      emailAddress: dev-node@baf.com
      crlCheckSoftFail: true
      tlsCertCrlDistPoint: ""
      tlsCertCrlIssuer: "{{ network | json_query('orderers[?type==`idman`].crlissuer_subject') | first }}"
      devMode: false
      volume:
        baseDir: /opt/corda
      jarPath: bin
      configPath: etc
      cordaJar:
        memorySize: 1524
        unit: M
      pod:
        resources:
          limits: 1524M
          requests: 1524M
    service:
      p2pPort: {{ peer.firewall.bridge.port if peer.firewall.enabled == true else peer.p2p.port }}
      p2pAddress: {{ peer.firewall.float.name ~ '.' ~ component_ns if peer.firewall.enabled == true else (peer.name | lower) ~ '.' ~ component_ns }}
      ssh:
        enabled: true
        sshdPort: 2222
      rpc:
        port: {{ peer.rpc.port }}
        adminPort: {{ peer.rpcadmin.port }}
        users:
        - name: {{ peer.name | lower }}
          password: {{ peer.name | lower }}P
          permissions: ALL
    dataSourceProperties:
      dataSource:
        user: {{ peer.name | lower }}-db-user
        password: {{ peer.name | lower }}-db-password
        url: "jdbc:h2:tcp://{{ peer.name | lower }}db:9101/persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=100;AUTO_RECONNECT=TRUE;"
        dataSourceClassName: org.h2.jdbcx.JdbcDataSource
        dbUrl: "{{ node_name }}db"
        dbPort: 9101
      monitoring:
        enabled: true
        port: 8090
      allowDevCorDapps:
        enabled: true
      retries: 20
      retryInterval: 15
    sleepTimeAfterError: 120
    sleepTime: 0
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold:  15
