apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ org.services.signer.name }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ org.services.signer.name }}
  interval: 1m
  chart:
   spec:
    chart: {{ org.gitops.chart_source }}/{{ chart }}
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    nodeName: {{ org.services.signer.name }}
    metadata:
      namespace: {{ component_ns }}
    image:
      initContainer: {{ network.docker.url }}/{{ init_container_image }}
      signerContainer: {{ network.docker.url }}/{{ main_container_image }}
      pullPolicy: IfNotPresent
      imagePullSecrets:
        - name: "regcred"
    acceptLicense: YES
    vault:
      address: {{ vault.url }}
      role: vault-role
      authPath: {{ component_auth }}
      serviceAccountName: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ name }}
      retries: 10
      sleepTimeAfterError: 15
    service:
      type: ClusterIP
      adminListener:
          port: 6000
    serviceLocations:
      identityManager:
        host: {{ org.services.idman.name }}.{{ name }}-ent
        publicIp: {{ org.services.idman.name }}.{{ org.external_url_suffix }}
        port: 5052
        publicPort: 443
      networkMap:
        host: {{ org.services.networkmap.name }}.{{ name }}-ent
        port: 5050
      revocation:
        port: 5053
    cenmServices:
      authName: {{ org.services.auth.name }}
      authPort: {{ org.services.auth.port }}
      idmanName: {{ org.services.idman.name }}
    signers:
      CSR:
        schedule:
          interval: 1m
      CRL:
        schedule:
          interval: 1d
      NetworkMap:
        schedule:
          interval: 1m
      NetworkParameters:
        schedule:
          interval: 1m
    config:
      volume:
        baseDir: /opt/cenm
      jarPath: bin
      configPath: etc
      cordaJar:
        memorySize: 512
        unit: M
      pod:
        resources:
          limits: 512M
          requests: 512M
      replicas: 1
