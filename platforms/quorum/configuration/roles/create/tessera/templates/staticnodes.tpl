{% if network.config.consensus == 'ibft' %}
{% for enode in enode_data_list %}
  - enode://{{ enode.enodeval }}@{{ enode.peer_name }}.{{ enode.external_url }}:{{ enode.p2p_ambassador }}?discport=0
{% endfor %}
{% endif %}
{% if network.config.consensus == 'raft' %}
{% for enode in enode_data_list %}
  - enode://{{ enode.enodeval }}@{{ enode.peer_name }}.{{ enode.external_url }}:{{ enode.p2p_ambassador }}?discport=0&raftport={{ enode.raft_ambassador }}
{% endfor %}
{% endif %}
