apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ name }}-springboot
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ name }}-springboot
  chart:
    path: {{ component_gitops.chart_source }}/springbootwebserver
    git: "{{ component_gitops.git_ssh }}"
    ref: "{{ component_gitops.branch }}"
  values:
    nodeName: {{ name }}-springboot
    replicas: 1
    metadata:
      namespace: {{ component_ns }}
    image:
      containerName: {{ network.docker.url }}/supplychain_corda:{{ image_tag }}
      initContainerName: {{ network.docker.url }}/alpine-utils:1.0
      imagePullSecret: regcred
      privateCertificate: true
    smartContract:
      JAVA_OPTIONS : -Xmx512m
    volume:
      mountPath: /opt/corda
    nodeConf:
      node: {{ node.name|e }}
      nodeRpcPort: {{ node.rpc.port|e }}
      nodeRpcAdminPort: {{ node.rpcadmin.port|e }}
      controllerName: Controller
      trustStorePath: /opt/corda/certificates/sslkeystore.jks
      trustStoreProvider: jks
      legalName: {{ node.subject|e }}
      devMode: false
      useHTTPS: true
      useSSL: false
      tlsAlias: cordaclienttls
      ssl:
        certificatesDirectory: na-ssl-false
        sslKeystoreFileName: na-ssl-false
        ssltruststore: na-ssl-false
    credentials:
      rpcUser: {{ node.name|e }}operations
    resources:
      limits: "512Mi"
      requests: "512Mi"
    storage:
      provisioner: kubernetes.io/aws-ebs
      memory: 512Mi
      name: {{organization_data.cloud_provider}}storageclass
      parameters:
        type: gp2
        encrypted: "true"
      annotations: {}
    web:
      targetPort: {{ node.springboot.targetPort|e }}
      port: {{ node.springboot.port|e }}
    service:
      type: NodePort
      annotations: {}
    vault:
      address: "{{ component_vault.url }}"
      role: vault-role
      authpath: corda{{ node.name|e }}
      serviceaccountname: vault-auth
      rpcusersecretprefix: {{ node.name|e }}/credentials/rpcusers
      keystoresecretprefix: {{ node.name|e }}/credentials/keystore
      certsecretprefix: {{ node.name|e }}/certs
    node:
      readinesscheckinterval: 10
      readinessthreshold: 15
    deployment:
      annotations: {}
    pvc:
      annotations: {}
