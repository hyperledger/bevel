Profiles:
{% for channel in network.channels %}
  {{channel.genesis.name}}:
    <<: *ChannelDefaults
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
    Consortiums:
      {{channel.consortium}}:
        Organizations:
{% for org in network.organizations %}
{% if org.type != 'orderer' %}
          - *{{org.name}}Org
{% endif %}          
{% endfor %}
  {{channel.channel_name}}:
    <<: *ChannelDefaults
    Consortium: {{channel.consortium}}
    Application:
      <<: *ApplicationDefaults
      Organizations:
{% for org in channel.participants %}
        - *{{org.name}}Org
{% endfor %}
{% endfor %}
