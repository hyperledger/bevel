apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}
  chart:
    path: {{ org.gitops.chart_source }}/{{ chart }}
    git: {{ org.gitops.git_ssh }}
    ref: {{ org.gitops.branch }}
  values:
    nodeName: {{ component_name }}
    metadata:
      namespace: {{ component_ns }}
    image:
      authusername: sa
      containerName: {{ network.docker.url }}/networkmap-linuxkit:latest
      env:
      - name: NETWORKMAP_PORT
        value: 8080
      - name: NETWORKMAP_ROOT_CA_NAME
        value: {{ services.nms.subject }}
      - name: NETWORKMAP_TLS
        value: {{ chart_tls }}
      - name: NETWORKMAP_DB
        value: /opt/networkmap/db
      - name: DB_USERNAME
        value: {{ component_name }}
      - name: NETWORKMAP_AUTH_USERNAME
        value: sa
      - name: DB_URL
        value: mongodb-{{ component_name }}
      - name: DB_PORT
        value: 27017
      - name: DATABASE
        value: admin
      - name: NETWORKMAP_CACHE_TIMEOUT
        value: 60S
      - name: NETWORKMAP_MONGOD_DATABASE
        value: networkmap
      imagePullSecret: regcred
      tlsCertificate: {{ chart_tls }}
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
      mountPath:
          basePath: /opt/networkmap
    storage:
      memory: 512Mi
      mountPath: "/opt/h2-data"
      name: {{ org.cloud_provider }}storageclass
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: {{ component_auth }}
      serviceaccountname: vault-auth
      secretprefix: {{ component_name }}
      certsecretprefix: {{ component_name }}/certs
      dbcredsecretprefix: {{ component_name }}/credentials/mongodb
      secretnetworkmappass: {{ component_name }}/credentials/userpassword
      tlscertsecretprefix: {{ component_name }}/tlscerts
      dbcertsecretprefix: {{ component_name }}/certs
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
      dburl: mongodb-{{ component_name }}:27017
    service:
      port: {{ services.nms.ports.servicePort }}
      targetPort: {{ services.nms.ports.targetPort }}
{% if services.nms.ports.nodePort is defined %}
      type: NodePort
      nodePort: {{ services.nms.ports.nodePort }}
{% else %}
      type: ClusterIP
{% endif %}
      annotations: {}
    deployment:
      annotations: {}
    pvc:
      annotations: {}
    ambassador:
      external_url_suffix: {{item.external_url_suffix}}
      