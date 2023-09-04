apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: mongodb-{{ nodename }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: mongodb-{{ nodename }}
  interval: 1m
  chart:
    spec:
      chart: {{ org.gitops.chart_source }}/{{ chart }}
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
  values:
    nodeName: mongodb-{{ nodename }}
    metadata:
      namespace: {{ component_ns }}
    image:
      containerName: mongo:3.6.6
{% if network.docker.username is defined %}
      imagePullSecret: regcred
{% endif %}
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
    storage:
      memory: 512Mi
      name: {{ sc_name }}
      mountPath: /data/db
      volname: hostvol
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: {{ component_auth }}
      secretprefix: {{ nodename }}/data/credentials/mongodb
      serviceaccountname: vault-auth
      certsecretprefix: {{nodename}}/data/certs
    service:
      tcp:
          port: 27017
          targetPort: 27017
      type: NodePort
      annotations: {}
    deployment:
      annotations: {}
    pvc:
      annotations: {}
    mongodb:
      username: {{ nodename }}
    cluster:
      enabled: false
