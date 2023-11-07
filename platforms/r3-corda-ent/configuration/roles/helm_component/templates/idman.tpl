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
    chart: {{ charts_dir }}/cenm-idman
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    nodeName: {{ org.services.idman.name | lower }}
    bashDebug: false
    prefix: {{ org.name }}
    metadata:
      namespace: {{ component_ns }}
    image:
      initContainer: {{ network.docker.url }}/{{ init_container_image }}
      idmanContainer: {{ network.docker.url }}/{{ main_container_image }}
      enterpriseCliContainer: {{ docker_images.cenm["enterpriseCli-1.5"] }}
      pullPolicy: IfNotPresent
      imagePullSecrets:
        - name: "regcred"
    storage:
      name: {{ sc_name }}
      memory: 700Mi
    acceptLicense: YES
    vault:
      address: {{ org.vault.url }}
      certSecretPrefix: {{ org.vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}
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
      adminListener:
        port: 6000
    database:
      driverClassName: "org.h2.Driver"
      url: "jdbc:h2:file:./h2/identity-manager-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0"
      user: "{{ org.services.idman.name }}-db-user"
      password: "{{ org.services.idman.name }}-db-password"
      runMigration: "true"
    config:
      volume:
        baseDir: /opt/cenm
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
    cenmServices:
      gatewayName: {{ org.services.gateway.name }}
      gatewayPort: {{ org.services.gateway.ports.servicePort }}
      zoneName: {{ org.services.zone.name }}
      zonePort: {{ org.services.zone.ports.admin }}
      zoneEnmPort: {{ org.services.zone.ports.enm }}
      authName: {{ org.services.auth.name }}
      authPort: {{ org.services.auth.port }}
