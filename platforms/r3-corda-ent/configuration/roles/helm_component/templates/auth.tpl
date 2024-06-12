apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ org.services.auth.name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/cenm-auth
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    metadata:
      namespace: {{ component_ns }}
      labels: {}
    prefix: {{ name }}
    nodeName: {{ component_name }}
    image:
      initContainerName: {{ network.docker.url }}/{{ init_container_image }}
      authContainerName: {{ network.docker.url }}/{{ main_container_image }}
      imagePullSecrets:
        - name: regcred
      pullPolicy: IfNotPresent
    storage:
      name: {{ sc_name }}
    vault:
      address: {{ vault.url }}
      role: vault-role
      authPath: {{ component_auth }}
      serviceAccountName: vault-auth
      certSecretPrefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ name }}

    database:
      driverClassName: "org.h2.Driver"
      jdbcDriver: ""
      url: "jdbc:h2:file:./h2/auth-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0"
      user: "{{ org.services.auth.name }}-db-user"
      password: "{{ org.services.auth.name }}-db-password"
      runMigration: "true"

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
          limits: 514Mi
          requests: 514Mi

    sleepTimeAfterError: 300
    logsContainerEnabled: true

    nameOverride: ""
    fullnameOverride: ""

    service:
      type: ClusterIP
      port: {{ org.services.auth.port }}

    authSubject: "{{ org.services.auth.subject }}"
