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
    path: {{ charts_dir }}/nmap
  values:
    nodeName: {{ node_name }}
    idmanName: {{ idman_name }}
    metadata:
      namespace: {{ component_ns }}
    notaryName: {{ notary_name }}
    storage:
      name: {{ storageclass }}
    replicas: 1
    image:
      initContainerName: {{ init_container_name }}
      imagepullsecret: {{ image_pull_secret }}
    dockerImage:
      name: {{ docker_image }}
      pullPolicy: Always
      imagePullSecret: {{ image_pull_secret }}
    acceptLicense: YES
    vault:
      role: vault-role
      authpath: {{ authpath }}
      serviceaccountname: {{ serviceaccountname }}
      address: {{ vault_addr }}
      certsecretprefix: {{ vault_cert_secret_prefix }}
    ambassador:
      external_url_suffix: {{ external_url_suffix }}
    volume:
      baseDir: /opt/corda
    service:
      port: {{ nmap_port.servicePort }}
    serviceInternal:
      port: 5050
    shell:
      sshdPort: 2222
      user: {{ ssh_username }}
      password: {{ ssh_password }}
    database:
      driverClassName: "org.h2.Driver"
      url: "jdbc:h2:file:./h2/networkmap-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0"
      user: {{ db_username }}
      password: {{ db_password }}
      runMigration: "true"
    identityManager:
      host: {{ idman_name }}.{{ component_ns }}
      port: 5052
    revocation:
      port: 5053
    cordaJarMx: 1
    healthCheckNodePort: 0
    jarPath: bin
    bashDebug: false
    configPath: etc
    sleepTimeAfterError: 120
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
