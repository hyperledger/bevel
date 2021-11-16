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
    path: {{ charts_dir }}/gateway
  values:
    nodeName: {{ component_name }}}
    metadata:
      namespace: {{ component_ns }}
      labels:
    prefix: {{ org.name }}
    image:
      initContainerName: {{ network.docker.url }}/{{ init_image }}
      gatewayContainerName: {{ network.docker.url }}/{{ docker_image }}
      imagePullSecrets: 
        - name: "regcred"
      pullPolicy: IfNotPresent
    cenmServices:
      idmanName: {{ org.services.idman.name }}
    storage:
      name: cordaentsc
    acceptLicense: YES
    vault:
      address: {{ vault.url }}
      role: vault-role
      authPath: {{ component_auth }}
      serviceAccountName: vault-auth
      certSecretPrefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}
      retries: 10
      sleepTimeAfterError: 15
    config:
      volume:
        baseDir: /opt/cenm
      jarPath: bin
      configPath: etc
      pvc:
        volumeSizeGatewayEtc: 1Gi
        volumeSizeGatewayLogs: 5Gi
      pod:
        resources:
          limits: 
            memory: 2Gi
          requests: 
            memory: 2Gi
      replicas: 1
    service:
      type: ClusterIP
      port: 8080
    zoneName: {{ org.services.zone.name }}
    zonePort: 12345
    gatewayPort: {{ org.services.gateway.port }}
    authName: {{ org.services.auth.name }}
    authPort: {{ org.services.auth.port }}
