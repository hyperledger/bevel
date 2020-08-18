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
    path: {{ charts_dir }}/generate-pki
  values:
    nodeName: {{ node_name }}
    cenmServices:
      signerName: {{ signerName }}
      idmanName: {{ idmanName }}
      networkmapName: {{ networkmapName }}
      notaryName: {{ notaryName }}
    replicas: 1
    metadata:
      namespace: {{ component_ns }}
    dockerImagePki:
      name: {{ docker_url }}
      tag: {{ docker_tag }}
      pullPolicy: Always
    image:
      initContainerName: {{ init_container_name }}
      imagePullSecret: regcred
    volume:
      baseDir: /opt/corda
    vault:
      address: {{ vault_address }}
      role: vault-role
      authpath: {{ authpath }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ certsecretprefix }}
    healthcheck:
      readinesscheckinterval: 20
      readinessthreshold: 20
    serviceSsh:
      type: ClusterIP
      port: 2222
      targetPort: 2222
      nodePort:
    shell:
      user: {{ username }}
      password: {{ password }}
    idmanPublicIP: {{ idman_ip }}
    idmanPort: {{ idman_port }}
    serviceLocations:
      identityManager:
        host: {{ idman_host }}
        port: 5052
      networkMap:
        host: {{ networkmap_host }}
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
    cordaJarMx: 1
    healthCheckNodePort: 0
    jarPath: bin
    configPath: etc
    pki:
      certificates:
        tlscrlsigner:
          subject: "{{ tls_crl_signer_subject }}"
          crl:
            issuer: "{{ tls_crl_signer_issuer }}"
        cordarootca:
          subject: "{{ corda_root_ca_subject }}"
        subordinateca:
          subject: "{{ subordinate_ca_subject }}"
        identitymanagerca:
          subject: "{{ idman_ca_subject }}"
        networkmap:
          subject: "{{ networkmap_ca_subject }}"
