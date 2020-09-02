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
    path: {{ charts_dir }}/node
  values:
    nodeName: {{ node_name }}
    metadata:
      namespace: {{ component_ns }}
      labels:
    image:
      initContainerName: {{ init_container_name }}
      nodeContainerName: {{ docker_image }}
      imagepullsecret: regcred
      pullPolicy: Always
    acceptLicence: true
    storage:
      name: cordaentsc
    replicas: 1
    networkServices:
      doormanURL: {{ doorman_url }}
      networkMapURL: {{ networkmap_url }}
    cenmServices:  
      idmanName: {{ idman_name }}
      networkmapName: {{ networkmap_name }}
    vault:
      address: {{ vault_address }}
      role: vault-role
      authpath: {{ vault_auth_path }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault_cert_secret_prefix }}
      nodePath: {{ vault_node_path }}
    ambassador:
      external_url_suffix: {{ external_url_suffix }}
      p2pPort: {{ ambassador_p2p_port }}
    legalName: "{{ legal_name }}"
    emailAddress: "dev-node@baf.com"
    crlCheckSoftFail: true
    tlsCertCrlDistPoint: ""
    tlsCertCrlIssuer: "{{ tls_cert_crl_issuer }}"
    devMode: false
    service:
      p2pPort: {{ p2p_port }}
      p2pAddress: {{ p2p_address }}
    ssh:
      enabled: true
      sshdPort: 2222
    rpc:
      port: {{ rpc_port }}
      adminPort: {{ rpc_admin_port }}
      users:
      - name: {{ user_name }}
        password: {{ user_password }}
        permissions: ALL
    dataSource:
      user: {{ datasource_user }}
      password: {{ datasource_password }}
      url: "{{ datasource_url }}"
      dataSourceClassName: org.h2.jdbcx.JdbcDataSource
      dbUrl: "{{ component_name }}db"
      dbPort: 9101
    monitoring:
      enabled: true
      port: 8090
    allowDevCorDapps:
      enabled: true
    volume:
      baseDir: /opt/corda
    jarPath: bin
    configPath: etc
    cordaJarMx: 3
    sleepTimeAfterError: 120
    sleepTime: 0
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
