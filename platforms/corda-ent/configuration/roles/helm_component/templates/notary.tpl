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
    path: {{ charts_dir }}/notary
  values:
    nodeName: {{ component_name }}
    legalName: {{ notary_legal_name }}
    metadata:
      namespace: {{ component_ns }}
    dockerImage:
      name: {{ docker_image }}
      pullPolicy: Always
    acceptLicense: YES
    storage:
      name: {{ storageclass }}
    replicas: 1
    image:
      initContainerName: {{ init_container_name }}
      imagePullSecret: {{ image_pull_secret }}
    cordaJarMx: 3
    devMode: false
    rpcSettingsAddress: "0.0.0.0"
    rpcSettingsAddressPort: 10003
    rpcSettingsAdminAddress: "localhost"
    rpcSettingsAdminAddressPort: 10770
    rpcSettingsStandAloneBroker: false
    rpcSettingsUseSsl: false
    networkServices:
      doormanURL: {{ idman_url }}
      networkMapURL: {{ networkmap_url }}
    dataSourceProperties:
      dataSource:
        password: "{{ db_password }}"
        url: "jdbc:h2:tcp://{{ component_name }}db:{{ db_port }}/persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=100;AUTO_RECONNECT=TRUE;"
        user: "{{ db_username }}"
      dataSourceClassName: "org.h2.jdbcx.JdbcDataSource"
      dbUrl: "{{ component_name }}db"
      dbPort: {{ db_port }}
    vault:
      authpath: {{ auth_path }}
      address: {{ vault_addr }}
      serviceaccountname: {{ vault_serviceaccountname }}
      role: {{ vault_role }}
      certsecretprefix: {{ vault_cert_secret_prefix }}
    notary:
      validating: {{ is_validating }}
    rpcUsers:
      username: {{ ssh_username }}
      password: {{ ssh_password }}
    notaryPublicIP: {{ notary_public_ip }}
    sleepTimeAfterError: 120
    sleepTime: 0
    jarPath: bin
    configPath: etc
    healthCheckNodePort: 0
    bashDebug: false
    volume:
      baseDir: /opt/corda
    service:
      p2pPort: {{ p2p_port }}
      sshdPort: 2222
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
