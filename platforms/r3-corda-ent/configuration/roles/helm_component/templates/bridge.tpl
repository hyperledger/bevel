apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  interval: 1m
  chart:
   spec:
    chart: {{ charts_dir }}/corda-ent-bridge
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    deployment:
      annotations: {}
    nodeName: {{ component_name }}
    metadata:
      namespace: {{ component_ns }}
      labels: {}
    replicas: 1
    image:
      initContainerName: {{ network.docker.url }}/{{ init_container_image }}
      mainContainerName: {{ network.docker.url }}/{{ main_container_image }}
      imagePullSecret: regcred
      pullPolicy: IfNotPresent
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: {{ network.env.type }}{{ name }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ name }}/{{ peer.name | lower }}
      retries: 20
      sleepTimeAfterError: 20
    volume:
      baseDir: /opt/corda/base
    storage:
      name: {{ sc_name }}
    pvc:
      annotations: {}
    cordaJarMx: 1024
    healthCheckNodePort: 0
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold:: 15
    float:
      address: {{ org.services.float.name | lower }}.{{ name }}.{{ org.services.float.external_url_suffix }}
      port: {{ org.services.float.ports.ambassador_p2p_port }}
      subject: {{ org.services.float.subject }}
    node:
      messagingServerAddress: {{ (org.services.peers[0].name | lower) ~ '.' ~ component_ns }}
      messagingServerPort: {{ org.services.peers[0].p2p.port }}
    tunnel:
      port: {{ org.services.float.ports.ambassador_tunnel_port }}
