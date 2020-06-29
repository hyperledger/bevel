Orderer: &OrdererDefaults
{% if consensus.name == 'raft' %}
  OrdererType: etcdraft
{% else %}
  OrdererType: {{ consensus.name }}
{% endif %}
  Addresses:
{% for orderer in orderers %}
{% if provider == 'minikube' %}
    - {{orderer.name}}.{{ component_ns }}:7050
{% else %}
    - {{orderer.name}}.{{ item.external_url_suffix }}:8443
{% endif %}
{% endfor %}

  BatchTimeout: 2s
  BatchSize:
    MaxMessageCount: 10
    AbsoluteMaxBytes: 98 MB
    PreferredMaxBytes: 1024 KB
{% if consensus.name == 'kafka' %}
  Kafka:
    Brokers:
{% for i in range(consensus.replicas) %}
      - {{ consensus.name }}-{{ i }}.{{ consensus.type }}.{{ component_ns }}.svc.cluster.local:{{ consensus.grpc.port }}
{% endfor %}
{% endif %}
{% if consensus.name == 'raft' %}
  EtcdRaft:
    Consenters:
{% for orderer in orderers %}
      - Host: {{ orderer.name }}.{{ item.external_url_suffix }}
        Port: 8443
        ClientTLSCert: ./crypto-config/ordererOrganizations/{{ component_ns }}/orderers/{{ orderer.name }}.{{ component_ns }}/tls/server.crt
        ServerTLSCert: ./crypto-config/ordererOrganizations/{{ component_ns }}/orderers/{{ orderer.name }}.{{ component_ns }}/tls/server.crt
{% endfor %}
{% endif %}
  Organizations:
  Policies:
    Readers:
      Type: ImplicitMeta
      Rule: "ANY Readers"
    Writers:
      Type: ImplicitMeta
      Rule: "ANY Writers"
    Admins:
      Type: ImplicitMeta
      Rule: "MAJORITY Admins"
    BlockValidation:
      Type: ImplicitMeta
      Rule: "ANY Writers"
  Capabilities:
    <<: *OrdererCapabilities
