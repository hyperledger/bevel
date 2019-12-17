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
      annotations: |- 
          ---
          apiVersion: ambassador/v1
          kind: TLSContext
          name: tls_context_{{ peer_name }}_{{ peer_ns }}
          hosts:
          - {{ peer_name }}.{{ peer_ns }}.{{item.external_url_suffix}}
          secret: {{ peer_name }}-{{ peer_ns }}-ambassador-certs
          alpn_protocols: h2
          ---
          apiVersion: ambassador/v1
          kind: Mapping
          tls: tls_context_{{ peer_name }}_{{ peer_ns }}
          grpc: True
          name: {{ peer_name }}_{{ peer_ns }}_mapping
          headers:
            :authority: {{ peer_name }}.{{ peer_ns }}.{{item.external_url_suffix}}:8443
          prefix: /
          rewrite: /
          service: https://{{ peer_name }}.{{ peer_ns }}:7051
          ---
          apiVersion: ambassador/v1
          kind: Mapping
          tls: tls_context_{{ peer_name }}_{{ peer_ns }}
          grpc: True
          name: {{ peer_name }}_{{ peer_ns }}_mapping_rest
          headers:
            :authority: {{ peer_name }}.{{ peer_ns }}.{{item.external_url_suffix}}
          prefix: /
          rewrite: /
          service: https://{{ peer_name }}.{{ peer_ns }}:7051

