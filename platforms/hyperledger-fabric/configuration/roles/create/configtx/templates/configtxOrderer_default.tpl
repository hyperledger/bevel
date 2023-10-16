Orderer: &OrdererDefaults
{% if consensus.name == 'raft' %}
  OrdererType: etcdraft
{% else %}
  OrdererType: {{ consensus.name }}
{% endif %}
  Addresses:
{% for orderer in orderers %}
{% if provider == 'none' %}
    - {{ orderer.name }}.{{ orderer.org_name | lower }}-net:7050
{% else %}
    - {{ orderer.uri }}
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
{% for org in network.organizations %}
{% if org.services.orderers is defined and org.services.orderers|length > 0 %}
{% for i in range(consensus.replicas) %}
      - {{ consensus.name }}-{{ i }}.{{ consensus.type }}.{{ org.name |lower }}-net.svc.cluster.local:{{ consensus.grpc.port }}
{% endfor %}
{% endif %}
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
