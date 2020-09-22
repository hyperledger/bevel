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
{% if '2.' in network.version %}
  Policies: &ApplicationDefaultPolicies
    LifecycleEndorsement:
        Type: ImplicitMeta
        Rule: "MAJORITY Endorsement"
    Endorsement:
        Type: ImplicitMeta
        Rule: "MAJORITY Endorsement"
    Readers:
        Type: ImplicitMeta
        Rule: "ANY Readers"
    Writers:
        Type: ImplicitMeta
        Rule: "ANY Writers"
    Admins:
        Type: ImplicitMeta
        Rule: "MAJORITY Admins"
{% endif %}
  Capabilities:
    <<: *ApplicationCapabilities

Channel: &ChannelDefaults
{% if '2.' in network.version %}
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
{% endif %}
  Capabilities:
    <<: *ChannelCapabilities

Organizations:

