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
    git: "{{ git_url }}"
    ref: {{ git_branch }}
    path: {{ charts_dir }}/idman
  values:
    deployment:
      annotations: {}
    nodeName: {{ float_name }}
    metadata:
      namespace: {{ component_ns }}
      labels: {}
    replicas: 1
    initContainerImage:
      name: {{ init_container_name }}
    image:
      name: {{ docker_image }}
      pullsecret: {{ image_pull_secret }}
      pullPolicy: Always
    vault:
      address: {{ vault_addr }}
      role: {{ vault_role }}
      authpath: {{ auth_path }}
      serviceaccountname: {{ vault_serviceaccountname }}
      certsecretprefix: {{ vault_cert_secret_prefix }}
    volume:
      baseDir: /opt/corda
    storage:
      name: {{ storageclass }}
    pvc:
      annotations: {}
    sleepTime: 0
    cordaJarMx: 100
    bridge:
      legalName: {{ bridge_subject }}
      tunnelPort: {{ bridge_tunnel_port }}
    healthCheckNodePort: 0
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 15
    float:
      loadBalancerIP: "{{ float_address }}"
    node:
      p2pPort: {{ float_port }}
    dmz:
      internal: "{{ dmz_internal }}"
      external: "{{ dmz_external }}"
