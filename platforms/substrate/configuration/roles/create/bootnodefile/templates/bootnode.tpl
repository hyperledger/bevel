bootnodes:
{%- for enode in node_list %}    
/dns4/{{ enode.external_url }}/tcp/{{ enode.p2p_port }}/p2p/{{ enode.bootnode_id }}
{%- endfor %}  
