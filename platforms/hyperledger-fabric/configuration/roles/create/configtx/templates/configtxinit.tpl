---
Capabilities:
  Global: &ChannelCapabilities
    V1_1: true
  Orderer: &OrdererCapabilities
    V1_1: true
  Application: &ApplicationCapabilities
    V1_1: true

Application: &ApplicationDefaults
  Organizations:
  Capabilities:
    <<: *ApplicationCapabilities

Channel: &ChannelDefaults
  Capabilities:
    <<: *ChannelCapabilities

Organizations:
