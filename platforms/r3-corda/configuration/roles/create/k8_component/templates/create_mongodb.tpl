apiVersion: helm.toolkit.fluxcd.io/v2
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
      secretprefix: {{ vault.secret_path | default(org_name) }}/data/{{ org_name }}/{{ nodename }}/credentials/mongodb
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default(org_name) }}/data/{{ org_name }}/{{ nodename }}/certs
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
