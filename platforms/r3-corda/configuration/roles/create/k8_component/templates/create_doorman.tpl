apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ services.doorman.name }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ services.doorman.name }}
  interval: 1m
  chart:
    spec:
      chart: {{ org.gitops.chart_source }}/{{ chart }}
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
  values:
    nodeName: {{ services.doorman.name }}
    metadata:
      namespace: {{component_ns }}
    image:
      authusername: sa
      containerName: {{ network.docker.url }}/bevel-doorman-linuxkit:latest
      env:
      - name: DOORMAN_PORT
        value: 8080
      - name: DOORMAN_ROOT_CA_NAME
        value: {{ services.doorman.subject }}
      - name: DOORMAN_TLS
        value: {{ chart_tls }}
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
{% if network.docker.username is defined %}
      imagePullSecret: regcred
{% endif %}
      tlsCertificate: {{ chart_tls }}
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
      mountPath:
        basePath: /opt/doorman
    storage:
      memory: 512Mi
      name: {{ sc_name }}
    mountPath:
      basePath: /opt/doorman
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: {{ component_auth }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default(org_name) }}/data/{{ org_name}}/{{ component_name }}/certs
      dbcredsecretprefix: {{ vault.secret_path | default(org_name) }}/data/{{ org_name}}/{{ component_name }}/credentials/mongodb
      secretdoormanpass: {{ vault.secret_path | default(org_name) }}/data/{{ org_name}}/{{ component_name }}/credentials/userpassword
      tlscertsecretprefix: {{ vault.secret_path | default(org_name) }}/data/{{ org_name}}/{{ component_name }}/tlscerts
      dbcertsecretprefix: {{ vault.secret_path | default(org_name) }}/data/{{ org_name}}/{{ component_name }}/certs
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
      dburl: mongodb-{{ services.doorman.name }}:27017
    service:
      port: {{ services.doorman.ports.servicePort }}
      targetPort: {{ services.doorman.ports.targetPort }}
{% if services.doorman.ports.nodePort is defined %}
      type: NodePort
      nodePort: {{ services.doorman.ports.nodePort }}
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
