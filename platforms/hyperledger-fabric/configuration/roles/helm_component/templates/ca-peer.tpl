apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ component_name }}-ca
  namespace: {{ component_name }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  releaseName: {{ component_name }}-ca
  chart:
    git: {{ git_url }}
    ref: {{ git_branch }}
    path: {{ charts_dir }}/ca    
  values:
    metadata:
      namespace: {{ component_name | e }}
    server:
      name: {{ component_services.ca.name }}
      tlsstatus: true
      admin: {{ component }}-admin
    storage:
      storageclassname: {{ component | lower }}sc
      storagesize: 1Gi
    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ component_name | e }}-auth
      secretcert: secret/crypto/peerOrganizations/{{ component_name | e }}/ca?ca.{{ component_name | e }}-cert.pem
      secretkey: secret/crypto/peerOrganizations/{{ component_name | e }}/ca?{{ component_name | e }}-CA.key
      secretadminpass: secret/credentials/{{ component_name | e }}/ca/{{ component }}?user
      serviceaccountname: vault-auth
      imagesecretname: regcred
    service:
      servicetype: ClusterIP
      ports:
        tcp:
          port: {{ component_services.ca.grpc.port }}
{% if component_services.ca.grpc.nodePort is defined %}
          nodeport: {{ component_services.ca.grpc.nodePort }}
{% endif %}
    ambassador:
    #Provide annotations for ambassador service configuration
    #Only use HTTPS as HTTP and HTTPS don't work together ( https://github.com/datawire/ambassador/issues/1000 )
      annotations: |- 
        ---
        apiVersion: ambassador/v1
        kind:  Mapping
        name:  ca_{{ component_name }}_mapping
        prefix: /
        host: ca.{{ component_name }}:7054
        service: ca.{{ component_name }}:7054
        tls: ca_{{ component_name }}_tls
        ---
        apiVersion: ambassador/v1
        kind: TLSContext
        name: ca_{{ component_name }}_tls
        hosts:
        - ca.{{ component_name }}
        secret: ca-{{ component_name }}-ambassador-certs
    