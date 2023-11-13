apiVersion: helm.toolkit.fluxcd.io/v2beta1
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
    chart: {{ charts_dir }}/cenm-networkmap
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    nodeName: {{ org.services.networkmap.name | lower }}
    bashDebug: false
    prefix: {{ org.name }}
    metadata:
      namespace: {{ component_ns }}
    storage:
      name: {{ sc_name }}
      memory: 512Mi
    image:
      initContainer: {{ network.docker.url }}/{{ init_container_image }}
      nmapContainer: {{ network.docker.url }}/{{ main_container_image }}
      enterpriseCliContainer: {{ docker_images.cenm["enterpriseCli-1.5"] }}
      pullPolicy: IfNotPresent
      imagePullSecrets:
        - name: "regcred"
    acceptLicense: YES
    vault:
      address: {{ org.vault.url }}
      role: vault-role
      authPath: cordaent{{ org.name | lower }}
      serviceAccountName: vault-auth
      certSecretPrefix: {{ org.vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}
      retries: 10
      sleepTimeAfterError: 15
    service:
      external:
        port: {{ org.services.networkmap.ports.servicePort }}
      internal:
        port: 5050
      revocation:
        port: 5053
      adminListener:
        port: 6000
    serviceLocations:
      identityManager:
        name: {{ org.services.idman.name }}
        domain: {{ idman_url.split(':')[1] | regex_replace('/', '') }}
        host: {{ org.services.idman.name }}.{{ component_ns }}
        port: 5052
      notary:
{% for notary in org.services.notaries %}
        - {{ notary.name }}
{% endfor %}
    database:
      driverClassName: "org.h2.Driver"
      url: "jdbc:h2:file:./h2/networkmap-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0"
      user: "{{ org.services.networkmap.name }}-db-user"
      password: "{{ org.services.networkmap.name }}-db-password"
      runMigration: "true"
    config:
      volume:
        baseDir: /opt/cenm
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
    cenmServices:
      gatewayName: {{ org.services.gateway.name }}
      gatewayPort: {{ org.services.gateway.ports.servicePort }}
      zoneName: {{ org.services.zone.name }}
      zonePort: {{ org.services.zone.ports.admin }}
      zoneEnmPort: {{ org.services.zone.ports.enm }}
      authName: {{ org.services.auth.name }}
      authPort: {{ org.services.auth.port }}
{% if nmap_update is defined and nmap_update %}
    nmapUpdate: true
    addNotaries:
{% for enode in node_list %}
      - notary:
          nodeinfoFileName: {{ enode.nodeinfo_name }}
          nodeinfoFile: {{ enode.nodeinfo }}
          validating: {{ enode.validating }}
{% endfor %}
{% else %}
    nmapUpdate: false
    addNotaries:
      - notary:
          nodeinfoFileName: dummy
          nodeinfoFile: dummy
          validating: false
{% endif %}
