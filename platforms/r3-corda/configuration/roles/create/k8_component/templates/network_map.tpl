apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
    spec:
      chart: {{ org.gitops.chart_source }}/{{ chart }}
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
  values:
    nodeName: {{ component_name }}
    metadata:
      namespace: {{ component_ns }}
    image:
      authusername: sa
      containerName: {{ network.docker.url }}/bevel-networkmap-linuxkit:latest
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
{% if network.docker.username is defined %}
      imagePullSecret: regcred
{% endif %}
      tlsCertificate: {{ chart_tls }}
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
      mountPath:
          basePath: /opt/networkmap
    storage:
      memory: 512Mi
      mountPath: "/opt/h2-data"
      name: {{ sc_name }}
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: {{ component_auth }}
      serviceaccountname: vault-auth
      secretprefix: {{ component_name }}
      certsecretprefix: {{ component_name }}/data/certs
      dbcredsecretprefix: {{ component_name }}/data/credentials/mongodb
      secretnetworkmappass: {{ component_name }}/data/credentials/userpassword
      tlscertsecretprefix: {{ component_name }}/data/tlscerts
      dbcertsecretprefix: {{ component_name }}/data/certs
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
{% if network.env.proxy == 'ambassador' %}
    ambassador:
      external_url_suffix: {{item.external_url_suffix}}
{% endif %}
