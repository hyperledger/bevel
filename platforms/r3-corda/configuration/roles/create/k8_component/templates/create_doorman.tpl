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
        value: /opt/{{ services.doorman.name }}/db
      - name: DOORMAN_AUTH_USERNAME
        value: sa
      - name: DB_URL
        value: mongodb-doorman
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
      certsecretprefix: doorman/certs
      dbcredsecretprefix: doorman/credentials/mongodb
      secretdoormanpass: doorman/credentials/userpassword
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
      dburl: mongodb-doorman:27017
    service:
      port: {{ services.doorman.ports.servicePort }}
      targetPort: {{ services.doorman.ports.targetPort }}
      type: ClusterIP
      annotations: {}
    deployment:
      annotations: {}
    pvc:
      annotations: {}
    ambassador:
      annotations: |- 
        ---
        apiVersion: ambassador/v1
        kind: Mapping
        name: doorman_mapping
        prefix: /
        service: {{ services.doorman.name }}.{{ component_ns }}:{{ services.doorman.ports.servicePort }}
        host: doorman.{{ item.external_url_suffix }}:8443
        tls: false
        ---
        apiVersion: ambassador/v1
        kind: TLSContext
        name: doorman_mapping_tlscontext
        hosts:
        - doorman.{{ item.external_url_suffix }}
        secret: doorman-ambassador-certs
