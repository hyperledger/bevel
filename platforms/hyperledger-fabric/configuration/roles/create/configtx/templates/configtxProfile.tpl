Profiles:
{% for channel in network.channels %}
  {{channel.genesis.name}}:
    Capabilities:
      <<: *ChannelCapabilities
    Orderer:
      <<: *OrdererDefaults
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
