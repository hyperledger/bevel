apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ org.services.zone.name }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ org.services.zone.name }}
  chart:
    path: {{ org.gitops.chart_source }}/{{ chart }}
    git: {{ org.gitops.git_url }}
    ref: {{ org.gitops.branch }}
  values:
    metadata:
      namespace: {{ component_ns }}
      nodeName: {{ org.services.zone.name }}
      prefix: cenm
    image:
      initContainerName: {{ network.docker.url }}/{{ init_image }}
      zoneContainerName: {{ network.docker.url }}/{{ docker_image }}
      imagePullSecret: regcred
      pullPolicy: IfNotPresent
    config:
      volume:
        baseDir: /opt/cenm
      pvc:
        volumeSizeZoneH2: 1Gi
        volumeSizeZoneLogs: 1Gi
        volumeSizeZoneData: 1Gi
      pod:
        resources:
          limits:
            memory: 1Gi
          requests:
            memory: 1Gi
      zoneJar:
        path: bin
    cenmServices:
      idmanName: {{ org.services.idman.name }}
      sslTruststore: {{ org.credentials.truststore.ssl }}
      sslIdmanKeystore: {{ org.credentials.ssl.idman }}
    database:
      driverClassName: "org.h2.Driver"
      jdbcDriver: ""
      url: "jdbc:h2:file:./h2/zone-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0"
      user: "example-db-user"
      password: "example-db-password"
      runMigration: true
    authService:
      host: {{ org.services.auth.name }}
      port: {{ org.services.auth.port }}
    service:
      type: ClusterIP
      port: 80
    listenerPort:
      enm: 25000
      admin: 12345
    storageClass: cordaentsc
    vault:
      address: {{ vault.url }}
      role: vault-role
      authPath: {{ component_auth }}
      serviceAccountName: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}
      retries: 10
      sleepTimeAfterError: 15
