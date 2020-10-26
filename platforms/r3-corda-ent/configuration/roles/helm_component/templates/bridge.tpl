apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ org.gitops.git_ssh }}
    ref: {{ org.gitops.branch }}
    path: {{ charts_dir }}/bridge
  values:
    deployment:
      annotations: {}
    nodeName: {{ component_name }}
    metadata:
      namespace: {{ component_ns }}
      labels: {}
    replicas: 1
    image:
      initContainerName: {{ network.docker.url }}/{{ init_image }}
      mainContainerName: {{ network.docker.url }}/{{ docker_image }}
      imagePullSecret: regcred
      pullPolicy: Always
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: cordaent{{ peer.name | lower }}
      serviceaccountname: vault-auth
      certsecretprefix: secret/{{ peer.name | lower }}/{{ peer.name | lower }}
      retries: 20
      sleepTimeAfterError: 20
    volume:
      baseDir: /opt/corda/base
    storage:
      name: cordaentsc
    pvc:
      annotations: {}
    cordaJarMx: 1024
    healthCheckNodePort: 0
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold:: 15
    float:
      address: {{ peer.firewall.float.name | lower }}.{{ component_ns }}
      port: {{ peer.firewall.float.port }}
      subject: {{ peer.firewall.float.subject }}
    node:
      messagingServerAddress: {{ (peer.name | lower) ~ '.' ~ component_ns }}
      messagingServerPort: {{ peer.p2p.port }}
    tunnel:
      port: {{ peer.firewall.bridge.tunnelport }}
