Profiles:
{% for channel in network.channels %}
  {{channel.genesis.name}}:
    Capabilities:
      <<: *ChannelCapabilities
    Orderer:
      <<: *OrdererDefaults
{% if consensus.name == 'raft' %}
      OrdererType: etcdraft
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
        - *{{ channel.orderer.name }}Org
      Capabilities:
        <<: *OrdererCapabilities
    Consortiums:
      {{channel.consortium}}:
        Organizations:
{% for org in channel.participants %}
          - *{{org.name}}Org
{% endfor %}
  {{channel.channel_name}}:
    Consortium: {{channel.consortium}}
    Application:
      <<: *ApplicationDefaults
      Organizations:
{% for org in channel.participants %}
        - *{{org.name}}Org
{% endfor %}
      Capabilities:
        <<: *ApplicationCapabilities
{% endfor %}
