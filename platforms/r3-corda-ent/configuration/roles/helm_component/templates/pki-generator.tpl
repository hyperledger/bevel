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
    path: {{ charts_dir }}/generate-pki
  values:
    nodeName: {{ name }}
    metadata:
      namespace: {{ component_ns }}
    image:
      initContainerName: {{ network.docker.url }}/{{ init_image }}
      pkiContainerName: {{ network.docker.url }}/{{ docker_image }}
      imagePullSecret: regcred
      pullPolicy: Always
    acceptLicense: YES
    volume:
      baseDir: /opt/corda
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: cordaent{{ org.name | lower }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secret') }}/{{ org.name | lower }}
      retries: 20
      sleepTimeAfterError: 20
    cenmServices:
      signerName: {{ services.signer.name }}
      idmanName: {{ services.idman.name }}
      networkmapName: {{ services.networkmap.name }}
      notaryName: {{ services.notary.name }}
    identityManager:
      publicIp: {{ org.services.idman.name }}.{{ org.external_url_suffix }}
      publicPort: 8443
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
