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
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/notary-initial-registration
  values:
    nodeName: {{ notary_service.name }}-initial-registration
    nodePath: {{ notary_service.name }}
    metadata:
      namespace: {{ component_ns }}
    image:
      initContainerName: {{ init_container_name }}
      imagepullsecret: {{ image_pull_secret }}
    dockerImage:
      notaryContainerName: {{ docker_image }}
      pullPolicy: Always
      imagePullSecret: {{ image_pull_secret }}
    acceptLicense: YES
    cenmServices:
      idmanName: {{ idman_name }}
      networkmapName: {{ networkmap_name }}
    vault:
      address: {{ vault_addr }}
      certsecretprefix: {{ vault_cert_secret_prefix }}
      serviceaccountname: vault-auth
      role: vault-role
      authpath: {{ vault_authpath }}
    volume:
      baseDir: /opt/corda
    devMode: false
    ambassador_p2pPort: {{ ambassador_p2pPort }}
    p2pPort: {{ notary_service.p2p.port }}
    rpcSettingsAddress: "0.0.0.0"
    rpcSettingsAddressPort: 10003
    rpcSettingsAdminAddress: "localhost"
    rpcSettingsAdminAddressPort: 10770
    rpcSettingsStandAloneBroker: false
    rpcSettingsUseSsl: false
    networkServices:
      doormanURL: {{ idman_url }}
      networkMapURL: {{ networkmap_url }}
    notary:
      validating: {{ is_validating }}
    legalName: {{ notary_legal_name }}
    emailAddress: {{ notary_service.emailAddress }}
    notaryPublicIP: {{ notary_public_ip }}
    rpcUsers:
      username: notary
      password: notaryP
    healthCheckNodePort: 0
    jarPath: bin
    bashDebug: false
    configPath: etc
    sleepTimeAfterError: 120
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
