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
    git: {{ org.gitops.git_url }}
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
      authpath: cordaent{{ org.name | lower }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}/{{ org.name | lower }}
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
      address: {{ org.services.float.name | lower }}.{{ org.name | lower }}.{{ org.services.float.external_url_suffix }}
      port: {{ org.services.float.ports.ambassador_p2p_port }}
      subject: {{ org.services.float.subject }}
    node:
      messagingServerAddress: {{ (org.services.peers[0].name | lower) ~ '.' ~ component_ns }}
      messagingServerPort: {{ org.services.peers[0].p2p.port }}
    tunnel:
      port: {{ org.services.float.ports.ambassador_tunnel_port }}
