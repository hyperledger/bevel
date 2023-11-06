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
{% if consensus.name == 'raft' %}
  EtcdRaft:
    Consenters:
{% for orderer in orderers %}
{% set component_ns = orderer.org_name.lower() + '-net' %}
{% if provider == 'none' %}
      - Host: {{orderer.name}}.{{ component_ns }}
        Port: 7050
{% else %}
{% set path = orderer.uri.split(':') %}
      - Host: {{ path[0] }}
        Port: {{ path[1] }}
{% endif %}
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
