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
    chart: {{ charts_dir }}/cenm-networkmap
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    global:
      serviceAccountName: vault-auth
      cluster:
        provider: "{{ cloud_provider }}"
        cloudNativeServices: false
      vault:
        type: hashicorp
        role: vault-role
        address: 
        authPath: "{{ org_name }}"
        secretEngine: secretsv2
        secretPrefix: "data/{{ org_name }}"
      proxy:
        provider: "ambassador"
        externalUrlSuffix: "{{ external_url_suffix }}"
      cenm:
        prefix: "{{ org_name }}-cenm"
        sharedCreds:
          truststore: {{ cred_truststore }}
          keystore: {{ cred_keystore}}
        identityManager:
          internal:
            port: {{ idman_int_port }}
          port: {{ idman_ext_port }}
          revocation:
            port: {{ idman_rev_port }}
        auth:
          port: {{ auth_port }}
        gateway:
          port: {{ gateway_port }}
        zone:
          enmPort: {{ zone_enm_port }}
        networkmap:
          internal:
            port: {{ network_map_int_port }}
          port: {{ network_map_ext_port }}

    storage:
      size: 1Gi
      dbSize: 5Gi
      allowedTopologies:
        enabled: false

    database:
      driverClassName: "org.h2.Driver"
      jdbcDriver: ""
      url: "jdbc:h2:file:./h2/networkmap-manager-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0"
      user: "networkmap-db-user"
      password: "networkmap-db-password"
      runMigration: true

    nmapUpdate: false
    sleepTimeAfterError: 120
    baseDir: /opt/cenm
    
    adminListener:
      port: {{ network_map_admin_listener_port }}
