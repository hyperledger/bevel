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
    path: {{ charts_dir }}/float
  values:
    deployment:
      annotations: {}
    nodeName: {{ component_name }}
    peerName: {{ org.name | lower }}
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
      authpath: cordaentfloat{{ org.name | lower }}
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
