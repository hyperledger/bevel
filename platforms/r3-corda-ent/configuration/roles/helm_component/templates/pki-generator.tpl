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
    chart: {{ charts_dir }}/cenm-pki-gen
    sourceRef:
      kind: GitRepository
      name: flux-{{ network.env.type }}
      namespace: flux-{{ network.env.type }}
  values:
    nodeName: {{ name }}
    metadata:
      namespace: {{ component_ns }}
    image:
      initContainerName: {{ network.docker.url }}/{{ init_container_image }}
      pkiContainerName: {{ network.docker.url }}/{{ main_container_image }}
      imagePullSecret: regcred
      pullPolicy: IfNotPresent
    acceptLicense: YES
    volume:
      baseDir: /opt/cenm
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: cordaent{{ org.name | lower }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}
      retries: 20
      sleepTimeAfterError: 20
    cenmServices:
      signerName: {{ services.signer.name }}
      idmanName: {{ services.idman.name }}
      networkmapName: {{ services.networkmap.name }}
    identityManager:
      publicIp: {{ org.services.idman.name }}.{{ org.external_url_suffix }}
      publicPort: 443
    subjects:
      tlscrlsigner: "{{ services.signer.subject }}"
      tlscrlissuer: "{{ services.idman.crlissuer_subject }}"
      rootca: "{{ org.subject }}"
      subordinateca: "{{ org.subordinate_ca_subject }}"
      idmanca: "{{ services.idman.subject }}"
      networkmap: "{{ services.networkmap.subject }}"
    replicas: 1
    cordaJarMx: 256
    configPath: etc
