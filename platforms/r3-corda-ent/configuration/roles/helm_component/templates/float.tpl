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
    chart: {{ charts_dir }}/corda-ent-float
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
      authpath: {{ network.env.type }}{{ name }}float
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
    sleepTime: 0
    cordaJarMx: 1024
    bridge:
      subject: {{ org.services.bridge.subject }}
      tunnelPort: {{ org.services.float.ports.tunnelport }}
    healthCheckNodePort: 0
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
    float:
      loadBalancerIP: {{ org.services.float.name | lower }}.{{ component_ns }}
    node:
      p2pPort: {{ org.services.float.ports.p2p_port }}
    ambassador:
      p2pPort: {{ org.services.float.ports.ambassador_p2p_port }}
      tunnelPort: {{ org.services.float.ports.ambassador_tunnel_port }}
      external_url_suffix: {{ org.services.float.external_url_suffix }}
    dmz:
      internal: "0.0.0.0"
      external: "0.0.0.0"
