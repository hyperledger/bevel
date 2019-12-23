  - &{{ component_name }}Org
    Name: {{ component_name }}MSP
    ID: {{ component_name }}MSP
    MSPDir: ./crypto-config/{{ component_type }}Organizations/{{ component_ns }}/msp
    {% if component_type == 'peer' %}      
    AnchorPeers:
      # AnchorPeers defines the location of peers which can be used
      # for cross org gossip communication.  Note, this value is only
      # encoded in the genesis block in the Application section context
{% for peer in  item.services.peers %}
      - Host: {{ peer.name }}.{{ component_ns }}.{{ item.external_url_suffix }}
        Port: 8443
{% endfor %}
    {% endif %} 
