apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ org.services.auth.name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ org.gitops.git_url }}
    ref: {{ org.gitops.branch }}
    path: {{ charts_dir }}/auth
  values:
    bashDebug: false
    prefix: cenm
    nodeName: auth
    image:
      initContainerName: {{ network.docker.url }}/{{ init_image }}
      mainContainerName: {{ network.docker.url }}/{{ docker_image }}
      imagePullSecret: regcred
      pullPolicy: Always
    config:
      volume:
        baseDir: /opt/cenm
      replicas: 1

      pvc:
        annotations: {}
        volumeSizeAuthEtc: 1Gi
        volumeSizeAuthH2: 5Gi
        volumeSizeAuthLogs: 5Gi
      deployment:
        annotations: {}
      pod:
        resources:
          limits: 512M
          requests:512M

      authSubject: "{{ services.auth.subject }}"
      nodeSelector: {}
      tolerations: []
      affinity: {}

      podSecurityContext:
        runAsUser: 1000
        runAsGroup: 1000
        fsGroup: 1000

      securityContext: {}
      logsContainersEnabled: true
      
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: cordaent{{ org.type | lower }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.type | lower }}
      retries: 20
      sleepTimeAfterError: 20

    database:
      driverClassName: "org.h2.Driver"
      jdbcDriver: ""
      url: "jdbc:h2:file:./h2/auth-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0"
      user: "{{ org.services.auth.name }}-db-user"
      password: "{{ org.services.auth.name }}-db-password"
      runMigration: "true"

    storageClass: cordaentsc
    sleepTimeAfterError: 300
    logsContainerEnabled: true
     
    nameOverride: ""
    fullnameOverride: ""

    service:
      type: ClusterIP
      port: 8081
