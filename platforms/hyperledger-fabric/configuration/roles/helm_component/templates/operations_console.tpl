apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ name }}-operations-console
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ name }}-operations-console
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/operations_console
{% if git_protocol == 'https' %}
    secretRef:
      name: gitcredentials
{% endif %}
  values:
    metadata:
      namespace: {{ component_ns }}
      images:
        couchdb: couchdb:3.1.1
        console: "{{ network.docker.url }}/fabric-console:latest"
        configtxlator: hyperledger/fabric-tools:{{ network.version }}
    storage:
      couchdb:
        storageclassname: {{ name }}sc
        storagesize: 512Mi
    service:
      name: {{ name }}console
      default_consortium: {{ default_consortium }}
      serviceaccountname: default
      imagesecretname: regcred
      servicetype: ClusterIP
      ports:
        console:
          clusteripport: 3000
        couchdb:
          clusteripport: 5984
    proxy:    
      provider: "{{ network.env.proxy }}"
      external_url_suffix: {{ item.external_url_suffix }}
