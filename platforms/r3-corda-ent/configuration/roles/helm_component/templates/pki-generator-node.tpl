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
    chart: {{ charts_dir }}/corda-ent-node-pki-gen
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
      baseDir: /opt/corda
    vault:
      address: {{ vault.url }}
      floatVaultAddress: {{ org.services.float.vault.url }}
      role: vault-role
      authpath: cordaent{{ org.name | lower }}
      authpathFloat: cordaent{{ org.name | lower }}float
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}/{{ org.name | lower }}
      retries: 20
      sleepTimeAfterError: 20
    subjects:
      firewallca: "{{ org.firewall.subject }}"
      float: "{{ org.services.float.subject }}"
      bridge: "{{ org.services.bridge.subject }}"
    replicas: 1
    cordaJarMx: 256
    configPath: etc
