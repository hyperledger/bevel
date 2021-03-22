apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: zkkafka-{{ org_name }}-orderer
  namespace: {{ namespace }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: zkkafka-{{ org_name }}-orderer
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/zkkafka    
  values:
    metadata: 
      namespace: {{ namespace }}
      images:
        kafka: {{ kafka_image }}
        zookeeper: {{ zookeeper_image }}
    storage: 
      storageclassname: {{ org_name }}sc
      storagesize: 512Mi
    kafka: 
      brokerservicename: {{consensus.type}}
      name: {{consensus.name}}
      replicas: {{consensus.replicas}}    
    zookeeper: 
      name: zookeeper
      peerservicename: zoo
      readinesscheckinterval: 10
      readinessthreshold: 10
      replicas: 3