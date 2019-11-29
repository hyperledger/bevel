apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ services.doorman.name }}
  annotations:
    flux.weave.works/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ services.doorman.name }}
  chart:
    path: {{ org.gitops.chart_source }}/doorman
    git: {{ org.gitops.git_ssh }}
    ref: {{ org.gitops.branch }}
  values:
    nodeName: {{ services.doorman.name }}
    metadata:
      namespace: {{component_ns }}
      external_url_suffix: {{item.external_url_suffix}}
      servicePort: {{services.doorman.ports.servicePort}}
    image:
      authusername: sa
      containerName: {{ network.docker.url }}/doorman:latest
      env:
      - name: DOORMAN_PORT
        value: 8080
      - name: DOORMAN_ROOT_CA_NAME
        value: {{ services.doorman.subject }}
      - name: DOORMAN_TLS
        value: false
      - name: DOORMAN_DB
        value: /opt/doorman/db
      - name: DOORMAN_AUTH_USERNAME
        value: sa
      - name: DB_URL
        value: mongodb-{{ services.doorman.name }}
      - name: DB_PORT
        value: 27017
      - name: DATABASE
        value: admin
      - name: DB_USERNAME
        value: {{ services.doorman.name }}
      imagePullSecret: regcred
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
      mountPath:
        basePath: /opt/doorman
    storage:
      memory: 512Mi
      name: {{ org.cloud_provider }}storageclass
    mountPath:
      basePath: /opt/doorman
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: {{ component_auth }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ services.doorman.name }}/certs
      dbcredsecretprefix: {{ services.doorman.name }}/credentials/mongodb
      secretdoormanpass: {{ services.doorman.name }}/credentials/userpassword
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
      dburl: mongodb-{{ services.doorman.name }}:27017
    service:
      port: {{ services.doorman.ports.servicePort }}
      targetPort: {{ services.doorman.ports.targetPort }}
      type: ClusterIP
      annotations: {}
    deployment:
      annotations: {}
    pvc:
      annotations: {}
    
        