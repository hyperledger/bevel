  - &{{ component_name }}Org
    Name: {{ component_name }}MSP
    ID: {{ component_name }}MSP
    MSPDir: ./crypto-config/{{ component_type }}Organizations/{{ component_ns }}/msp
    Policies:
      Readers:
        Type: Signature
        Rule: "OR('{{ component_name }}MSP.member')"
      Writers:
        Type: Signature
        Rule: "OR('{{ component_name }}MSP.member')"
      Admins:
        Type: Signature
        Rule: "OR('{{ component_name }}MSP.admin')"
      Endorsement:
        Type: Signature
        Rule: "OR('{{ component_name }}MSP.member')"
{% if component_type == 'peer' and '2.5' not in network.version %}      
    AnchorPeers:
      # AnchorPeers defines the location of peers which can be used
      # for cross org gossip communication.  Note, this value is only
      # encoded in the genesis block in the Application section context
{% for peer in  item.services.peers %}
{% if peer.type == 'anchor' %}
{% if provider == 'none' %}
      - Host: {{ peer.name }}.{{ component_ns }}
        Port: 7051
{% else %}
{% set path = peer.peerAddress.split(':') %}
      - Host: {{ path[0] }}
        Port: {{ path[1] }}
{% endif %}
{% endif %}
{% endfor %}
{% endif %}
{% if component_type == 'orderer' %}
    OrdererEndpoints:
{% for orderer in orderers %}
{% if provider == 'none' %}
      - {{ orderer.name }}.{{ orderer.org_name | lower }}-net:7050
{% else %}
      - {{ orderer.uri }}
{% endif %}
{% endfor %}
{% endif %} 
