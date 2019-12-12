apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ name }}-{{ peer_name }}
  namespace: {{ peer_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ name }}-{{ peer_name }}
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/peernode    
  values:
    metadata:
      namespace: {{ peer_ns }}
        
    peer:
      name: {{ peer_name }}
      gossippeeraddress: {{ peer.gossippeeraddress }}
      gossipexternalendpoint: {{ peer_name }}.{{ peer_ns }}.{{item.external_url_suffix}}:8443
      localmspid: {{ name }}MSP
      loglevel: info
      tlsstatus: true
      couchdb:
        username: {{ name }}-user

    storage:
      peer:
        storageclassname: {{ name }}sc
        storagesize: 512Mi
      couchdb:
        storageclassname: {{ name }}sc
        storagesize: 1Gi

    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ namespace }}-auth
      secretprefix: secret/crypto/peerOrganizations/{{ namespace }}/peers/{{ peer_name }}.{{ namespace }}
      secretambassador: secret/crypto/peerOrganizations/{{ namespace }}/ambassador
      serviceaccountname: vault-auth
      imagesecretname: regcred
      secretcouchdbpass: secret/credentials/{{ namespace }}/couchdb/{{ name }}?user

    service:
      servicetype: ClusterIP
      ports:
        grpc:
          clusteripport: {{ peer.grpc.port }}
{% if peer.grpc.nodePort is defined %}
          nodeport: {{ peer.grpc.nodePort }}
{% endif %}
        events:
          clusteripport: {{ peer.events.port }}
{% if peer.events.nodePort is defined %}
          nodeport: {{ peer.events.nodePort }}
{% endif %}
        couchdb:
          clusteripport: {{ peer.couchdb.port }}
{% if peer.couchdb.nodePort is defined %}
          nodeport: {{ peer.couchdb.nodePort }}
{% endif %}
          
    ambassador:
      external_url_suffix: {{ item.external_url_suffix }}
      ambassador_id: ambassador-{{ name }}

