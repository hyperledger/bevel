apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: zkkafka-{{ org_name }}-orderer
  namespace: {{ namespace }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: zkkafka-{{ org_name }}-orderer
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/zkkafka    
  values:
    metadata: 
      namespace: {{ namespace }}
      images:
        kafka: {{ docker_url }}/{{ kafka_image }}
        zookeeper: {{ docker_url }}/{{ zookeeper_image }}
    storage: 
      storageclassname: {{ sc_name }}
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