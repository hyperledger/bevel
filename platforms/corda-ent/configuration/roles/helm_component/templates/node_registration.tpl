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
      initContainerName: {{ init_container_name }}
      nodeContainerName: {{ docker_image }}
      imagepullsecret: {{ image_pull_secret }}
      pullPolicy: Always
    cenmServices:  
      idmanName: {{ idman_name }}
      networkmapName: {{ networkmap_name }}
    truststorePassword: password
    keystorePassword: password
    acceptLicence: true
    networkServices:
      doormanURL: {{ doorman_url }}
      networkMapURL: {{ networkmap_url }}
    vault:
      address: {{ vault_address }}
      role: {{ vault_role }}
      authpath: {{ vault_auth_path }}
      serviceaccountname: {{ vault_service_account_name }}
      certsecretprefix: {{ vault_cert_secret_prefix }}
      nodePath: {{ vault_node_path }}
    legalName: "{{ legal_name }}"
    emailAddress: {{ email_address }}
    crlCheckSoftFail: {{ crl_check_soft_fail }}
    tlsCertCrlDistPoint: ""
    tlsCertCrlIssuer: "{{ tls_cert_crl_issuer }}"
    devMode: {{ dev_mode }}
    service:
      p2pPort: {{ p2p_port }}
      p2pAddress: {{ p2p_address }}
    ssh:
      enabled: {{ ssh_enabled }}
      sshdPort: {{ ssh_port }}
    rpc:
      port: {{ rpc_port }}
      adminPort: {{ rpc_admin_port }}
      users:
      - name: {{ user_name }}
        password: {{ user_password }}
        permissions: {{ user_permissions }}
    dataSource:
      user: {{ datasource_user }}
      password: {{ datasource_password }}
      url: "{{ datasource_url }}"
      dataSourceClassName: {{ datasource_class_name }}
    monitoring:
      enabled: {{ monitoring_enabled }}
      port: {{ monitoring_port }}
    allowDevCorDapps:
      enabled: {{ allow_dev_cordapps }}
    volume:
      baseDir: {{ volume_base_dir }}
    jarPath: {{ java_path }}
    configPath: {{ config_path }}
    cordaJarMx: {{ corda_jar_mx }}
    sleepTimeAfterError: {{ sleep_time_after_error }}
    sleepTime: {{ sleep_time }}
    healthcheck:
      readinesscheckinterval: {{ readiness_check_interval }}
      readinessthreshold:  {{ readiness_threshold }}
