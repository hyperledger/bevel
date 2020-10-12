apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: mongodb-{{ nodename }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  replicaCount: 1
  replicas: 1
  releaseName: mongodb-{{ nodename }}
  chart:
    path: {{ org.gitops.chart_source }}/{{ chart }}
    git: {{ org.gitops.git_ssh }}
    ref: {{ org.gitops.branch }}
  values:
    nodeName: mongodb-{{ nodename }}
    metadata:
      namespace: {{ component_ns }}
    image:
      containerName: mongo:3.6.6
      imagePullSecret: regcred
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
    storage:
      memory: 512Mi
      name: {{ org.cloud_provider }}storageclass
      mountPath: /data/db
      volname: hostvol
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: {{ component_auth }}
      secretprefix: {{ nodename }}/credentials/mongodb
      serviceaccountname: vault-auth
      certsecretprefix: {{nodename}}/certs
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