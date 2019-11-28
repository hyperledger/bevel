apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  annotations:
    flux.weave.works/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ component_name }}
  chart:
    path: {{ org.gitops.chart_source }}/nms
    git: {{ org.gitops.git_ssh }}
    ref: {{ org.gitops.branch }}
  values:
    nodeName: {{ component_name }}
    metadata:
      namespace: {{ component_ns }}
    image:
      authusername: sa
      containerName: {{ network.docker.url }}/nms:0.3.11-network-map-service
      env:
      -   name: rootcaname
          value: {{ services.nms.subject }}
      -   name: tlscertpath
          value: /opt/cordite/db/certs
      -   name: tlskeypath
          value: /opt/cordite/db/certs/network-map/keys.jks
      -   name: tls
          value: false
      -   name: doorman
          value: true
      -   name: certman
          value: true
      -   name: database
          value: /opt/cordite/db
      -   name: dataSourceUrl
          value: embed
      imagePullSecret: regcred
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
      mountPath:
          basePath: /opt/cordite
    storage:
      memory: 1Gi
      mountPath: "/opt/h2-data"
      name: {{ org.cloud_provider }}storageclass
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: {{ component_auth }}
      serviceaccountname: vault-auth
      secretprefix: networkmap
      certsecretprefix: networkmap/certs
      dbcredsecretprefix: networkmap/credentials/mongodb
      secretnetworkmappass: networkmap/credentials/userpassword
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
      dburl: mongodb-networkmap:27017
    service:
      port: {{ services.nms.ports.servicePort }}
      targetPort: {{ services.nms.ports.targetPort }}
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
        name: networkmap_mapping
        prefix: /
        service: {{ component_name }}.{{ component_ns }}:{{ services.nms.ports.servicePort }}
        host: networkmap.{{ item.external_url_suffix }}:8443
        tls: false
        ---
        apiVersion: ambassador/v1
        kind: TLSContext
        name: networkmap_mapping_tlscontext
        hosts:
        - networkmap.{{ item.external_url_suffix }}
        secret: networkmap-ambassador-certs 
