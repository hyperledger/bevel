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
    git: {{ org.gitops.git_ssh }}
    ref: {{ org.gitops.branch }}
    path: {{ charts_dir }}/idman
  values:
    nodeName: {{ org.services.idman.name | lower }}
    metadata:
      namespace: {{ component_ns }}
    image:
      initContainerName: {{ network.docker.url }}/{{ init_image }}
      idmanContainerName: {{ network.docker.url }}/{{ docker_image }}
      pullPolicy: Always
      imagePullSecret: "regcred"
    storage:
      name: "cordaentsc"
      memory: 700Mi
    acceptLicense: YES
    vault:
      address: {{ org.vault.url }}
      certSecretPrefix: secret/{{ org.name | lower }}
      role: vault-role
      authPath: cordaent{{ org.name | lower }}
      serviceAccountName: vault-auth
      retries: 10
      sleepTimeAfterError: 15
    service:
      external:
        port: {{ org.services.idman.port }}
      internal:
        port: 5052
      revocation:
        port: 5053
      shell:
        sshdPort: 2222
        user: "{{ org.services.idman.name }}"
        password: "{{ org.services.idman.name }}P"
    database:
      driverClassName: "org.h2.Driver"
      url: "jdbc:h2:file:./h2/identity-manager-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0"
      user: "{{ org.services.idman.name }}-db-user"
      password: "{{ org.services.idman.name }}-db-password"
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
      external_url_suffix: "{{ org.external_url_suffix }}"
