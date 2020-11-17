apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ org.services.signer.name }}
  annotations:
    fluxcd.io/automated: "false"
  namespace: {{ component_ns }}
spec:
  releaseName: {{ org.services.signer.name }}
  chart:
    path: {{ org.gitops.chart_source }}/{{ chart }}
    git: {{ org.gitops.git_ssh }}
    ref: {{ org.gitops.branch }}
  values:
    nodeName: {{ org.services.signer.name }}
    metadata:
      namespace: {{ component_ns }}
    image:
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
      signerContainerName: {{ network.docker.url }}/corda/enterprise-signer:1.2-zulu-openjdk8u242
      imagePullSecret: regcred
      pullPolicy: Always
    acceptLicense: YES
    vault:
      address: {{ vault.url }}
      role: vault-role
      authPath: {{ component_auth }}
      serviceAccountName: vault-auth
      certSecretPrefix: {{ vault.secret_path | default('secret') }}/{{ org.name | lower }}
      retries: 10
      sleepTimeAfterError: 15
    service:
      ssh:
        port: 2222
        targetPort: 2222
        type: ClusterIP
      shell:
        user: signer
        password: signerP
    serviceLocations:
      identityManager:
        host: {{ org.services.idman.name }}.{{ org.name | lower }}-ent
        publicIp: {{ org.services.idman.name }}.{{ org.external_url_suffix }}
        port: 5052
        publicPort: 8443
      networkMap:
        host: {{ org.services.networkmap.name }}.{{ org.name | lower }}-ent
        port: 5050
      revocation:
        port: 5053
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
        baseDir: /opt/corda
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
