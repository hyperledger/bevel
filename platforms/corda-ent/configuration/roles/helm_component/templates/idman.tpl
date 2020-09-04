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
    path: {{ charts_dir }}/idman
  values:
    nodeName: {{ node_name }}
    metadata:
      namespace: {{ component_ns }}
    image:
      initContainerName: {{ init_container_name }}
      idmanContainerName: {{ idman_image_name }}:{{ idman_image_tag }}
      pullPolicy: Always
      imagePullSecret: {{ image_pull_secret }}
    storage:
      name: {{ storageclass }}
      memory: 700Mi
    acceptLicense: YES
    vault:
      address: {{ vault_addr }}
      certSecretPrefix: {{ vault_cert_secret_prefix }}
      role: {{ vault_role }}
      authPath: {{ auth_path }}
      serviceAccountName: {{ vault_serviceaccountname }}
      retries: 10
      sleepTimeAfterError: 15
    service:
      external:
        port: {{ idman_port }}
      internal:
        port: 5052
      revocation:
        port: 5053
      shell:
        sshdPort: 2222
        user: {{ ssh_username }}
        password: {{ ssh_password }}
    database:
      driverClassName: "org.h2.Driver"
      url: "jdbc:h2:file:./h2/identity-manager-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0"
      user: {{ db_username }}
      password: {{ db_password }}
      runMigration: "true"
    config:
      volume:
        baseDir: /opt/corda
      jarPath: bin
      configPath: etc
      cordaJar:
        memorySize: 512
        unit: M
      pod:
        resources:
          limits: 512M
          requests: 512M
      replicas: 1
      sleepTimeAfterError: 120
    ambassador:
      external_url_suffix: {{ external_url_suffix }}
