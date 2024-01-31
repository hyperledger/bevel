apiVersion: hlf.kungfusoftware.es/v1alpha1
kind: FabricMainChannel
metadata:
  name: {{ channel_name }}
spec:
  name: {{ channel_name }}
  adminOrdererOrganizations:
    - mspID: {{ orderer_msp }}
  adminPeerOrganizations:
    - mspID: {{ creator_msp }}
  channelConfig:
    application:
      acls: null
      capabilities:
        - V2_0
      policies: null
    capabilities:
      - V2_0
    orderer:
      batchSize:
        absoluteMaxBytes: 1048576
        maxMessageCount: 120
        preferredMaxBytes: 524288
      batchTimeout: 2s
      capabilities:
        - V2_0
      etcdRaft:
        options:
          electionTick: 10
          heartbeatTick: 1
          maxInflightBlocks: 5
          snapshotIntervalSize: 16777216
          tickInterval: 500ms
      ordererType: etcdraft
      policies: null
      state: STATE_NORMAL
    policies: null
  externalOrdererOrganizations: []
  peerOrganizations:
{% for peer_org in participants %}
    - mspID: {{ peer_org.name | lower }}MSP
      caName: "{{ peer_org.name | lower }}-ca"
      caNamespace: "{{ peer_org.name | lower }}-net"
{% endfor %}
  identities:
    {{ orderer_msp }}:
      secretKey: user.yaml
      secretName: "{{ orderer_admin }}"
      secretNamespace: "{{ orderer_namespace }}"
    {{ creator_msp }}:
      secretKey: user.yaml
      secretName: "{{ creator_admin }}"
      secretNamespace: "{{ creator_namespace }}"
  externalPeerOrganizations: []
  ordererOrganizations:
    - caName: "{{ orderer_ca }}"
      caNamespace: "{{ orderer_namespace }}"
      externalOrderersToJoin:
{% for orderer in network.orderers %}
        - host: {{ orderer.name }}.{{ orderer_namespace }}
          port: 7053
{% endfor %}
      mspID: {{ orderer_msp }}
      ordererEndpoints:
{% for orderer in network.orderers %}
        - {{ orderer.uri }}
{% endfor %}
      orderersToJoin: []
  orderers:
{% for orderer in network.orderers %}
    - host: {{ orderer.uri.split(':')[0] }}
      port: {{ orderer.uri.split(':')[1] }}
      tlsCert: |-
        {{ lookup('file', orderer.certificate) | indent(width=8, first=False) }}
{% endfor %}
