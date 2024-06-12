apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ org.services.zone.name }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ org.services.zone.name }}
  interval: 1m
  chart:
   spec:
    chart: {{ org.gitops.chart_source }}/{{ chart }}
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      namespace: {{ component_ns }}
      nodeName: {{ org.services.zone.name }}
      prefix: {{ org.name }}
    image:
      initContainer: {{ network.docker.url }}/{{ init_container_image }}
      zoneContainer: {{ network.docker.url }}/{{ main_container_image }}
      pullPolicy: IfNotPresent
      imagePullSecrets:
        - name: "regcred"
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
      authName: {{ org.services.auth.name }}
      authPort: {{ org.services.auth.port }}
    database:
      driverClassName: "org.h2.Driver"
      jdbcDriver: ""
      url: "jdbc:h2:file:./h2/zone-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0"
      user: "example-db-user"
      password: "example-db-password"
      runMigration: true
    service:
      type: ClusterIP
      port: 80
    listenerPort:
      enm: {{ org.services.zone.ports.enm }}
      admin: {{ org.services.zone.ports.admin }}
    storageClass: {{ sc_name }}
    vault:
      address: {{ vault.url }}
      role: vault-role
      authPath: {{ component_auth }}
      serviceAccountName: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ name }}
      retries: 10
      sleepTimeAfterError: 15
