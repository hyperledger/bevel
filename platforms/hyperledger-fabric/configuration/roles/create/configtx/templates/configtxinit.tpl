---
Capabilities:
{% if consensus.name == 'kafka' %}
  Global: &ChannelCapabilities
    V1_1: true
  Orderer: &OrdererCapabilities
    V1_1: true
  Application: &ApplicationCapabilities
    V1_1: true
{% endif %}
{% if consensus.name == 'raft' %}
  Global: &ChannelCapabilities
    V1_4_3: true
  Orderer: &OrdererCapabilities
    V1_4_2: true
  Application: &ApplicationCapabilities
    V1_4_2: true
{% endif %}

Application: &ApplicationDefaults
  Organizations:
  Capabilities:
    <<: *ApplicationCapabilities

Channel: &ChannelDefaults
  Capabilities:
    <<: *ChannelCapabilities

Organizations:
