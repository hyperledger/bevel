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
    path: {{ charts_dir }}/float
  values:
    deployment:
      annotations: {}
    nodeName: {{ component_name }}
    peerName: {{ peer.name | lower }}
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
      certsecretprefix: {{ vault.secret_path | default('secret') }}/{{ peer.name | lower }}/{{ peer.name | lower }}
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
      subject: {{ peer.firewall.bridge.subject }}
      tunnelPort: {{ peer.firewall.bridge.tunnelport }}
    healthCheckNodePort: 0
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
    float:
      loadBalancerIP: {{ peer.firewall.float.name | lower }}.{{ component_ns }}
    node:
      p2pPort: {{ peer.firewall.float.port }}
    ambassador:
      p2pPort: {{ peer.p2p.ambassador }}
      tunnelPort: {{ peer.firewall.bridge.ambassadorTunnelPort }}
      external_url_suffix: {{ org.external_url_suffix }}
    dmz:
      internal: "0.0.0.0"
      external: "0.0.0.0"
