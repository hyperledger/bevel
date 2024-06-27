apiVersion: helm.toolkit.fluxcd.io/v2
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
    chart: {{ charts_dir }}/enterprise-node
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    global:
      serviceAccountName: vault-auth
      cluster:
        provider: "{{ cloud_provider }}"
        cloudNativeServices: false
        kubernetesUrl: "{{ kubernetes_server }}"
      vault:
        type: hashicorp
        role: vault-role
        network: corda-enterprise
        address: "{{ vault.url }}"
        authPath: "{{ org_name }}"
        secretEngine: secretsv2
        secretPrefix: "data/{{ org_name }}"
      proxy:
        provider: ambassador
        externalUrlSuffix: {{ external_url_suffix }}
    image:
      notary:
        repository: corda/corda-enterprise
        tag: 4.10.3-zulu-openjdk8-alpine
    network:
      creds:
        truststore: password
    tls:
      nameOverride: {{ node_name }}   # should match the release name
      enabled: true
    sleepTimeAfterError: 180
    storage:
      size: 1Gi
      dbSize: 5Gi
      allowedTopologies:
        enabled: false
    baseDir: /opt/corda
    dataSourceProperties:
      dataSource:
        user: node-db-user
        password: node-db-password
        url: "jdbc:h2:file:./h2/node-persistence;DB_CLOSE_ON_EXIT=FALSE;WRITE_DELAY=0;LOCK_TIMEOUT=10000"
        dataSourceClassName: org.h2.jdbcx.JdbcDataSource
    nodeConf:
      legalName: {{ subject }}
      devMode: false
      creds:
        truststore: cordacadevpass
        keystore: trustpass
      crlCheckSoftFail: true
      tlsCertCrlDistPoint: ""
      tlsCertCrlIssuer: ""
      monitoring:
        enabled: true
        port: 8090
      allowDevCorDapps:
        enabled: true
      p2pPort: {{ p2p_port }}
      rpc:
        port: {{ rpc_port }}
        adminPort: {{ rpc_admin_port }}
        users:
        - name: node
          password: nodeP
          permissions: ALL
      ssh:
        enabled: true
        sshdPort: 2222
      removeKeysOnDelete: false
      firewall:
        enabled: false
      notary:
        serviceLegalName: {{ service_name }}
        validating: {{ validating }}
      doormanPort: 443
      networkMapPort: 443
      doormanDomain: {{ org_name }}-cenm-doorman.{{ external_url_suffix }}
      networkMapDomain: {{ org_name }}-cenm-nms.{{ external_url_suffix }}
      doormanURL: https://{{ org_name }}-cenm-doorman.{{ external_url_suffix }}
      networkMapURL: https://{{ org_name }}-cenm-nms.{{ external_url_suffix }}
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
