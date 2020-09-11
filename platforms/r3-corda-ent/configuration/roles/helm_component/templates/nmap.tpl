apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ org.gitops.git_ssh }}
    ref: {{ org.gitops.branch }}
    path: {{ charts_dir }}/nmap
  values:
    nodeName: {{ org.services.networkmap.name | lower }}
    metadata:
      namespace: {{ component_ns }}
    storage:
      name: "cordaentsc"
      memory: 512Mi
    image:
      initContainerName: {{ network.docker.url }}/{{ init_image }}
      nmapContainerName: {{ network.docker.url }}/{{ docker_image }}
      imagePullSecret: "regcred"
      pullPolicy: Always
    acceptLicense: YES
    vault:
      address: {{ org.vault.url }}
      role: vault-role
      authPath: cordaent{{ org.name | lower }}
      serviceAccountName: vault-auth
      certSecretPrefix: secret/{{ org.name | lower }}
      retries: 10
      sleepTimeAfterError: 15
    service: 
      external:
        port: {{ org.services.networkmap.ports.servicePort }}
      internal:
        port: 5050
      revocation:
        port: 5053
      shell:
        sshdPort: 2222
        user: "nmap"
        password: "nmapP"
    serviceLocations:
      identityManager:
        name: {{ org.services.idman.name }}
        domain: {{ idman_url.split(':')[1] | regex_replace('/', '') }}
        host: {{ org.services.idman.name }}.{{ component_ns }}
        port: 5052
      notary:
        name: {{ org.services.notary.name }}
    database:
      driverClassName: "org.h2.Driver"
      url: "jdbc:h2:file:./h2/networkmap-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0"
      user: "{{ org.services.networkmap.name }}-db-user"
      password: "{{ org.services.networkmap.name }}-db-password"
      runMigration: "true"
    config:
      volume:
        baseDir: /opt/corda
      jarPath: bin
      configPath: etc
      cordaJar:
        memorySize: 1024
        unit: M
      pod:
        resources:
          limits: 1026M
          requests: 1024M
      replicas: 1
    ambassador:
      external_url_suffix: "{{ org.external_url_suffix }}"
