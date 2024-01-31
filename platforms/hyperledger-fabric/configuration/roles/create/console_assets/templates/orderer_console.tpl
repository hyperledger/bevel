{
    "display_name": "ordering node - {{ item.name | lower }}",
    "grpcwp_url": "https://{{ orderer.name }}-proxy.{{ item.external_url_suffix }}",
    "api_url": "grpcs://{{ orderer.ordererAddress }}",
    "operations_url": "http://{{ orderer.name }}-ops.{{ item.external_url_suffix }}",
    "type": "fabric-orderer",
    "msp_id": "{{ item.name | lower }}MSP",
    "system_channel_id": "syschannel",    
    "cluster_id": "orderer_supplychain_raft",
    "cluster_name": "orderer_supplychain",
    "name": "ordering node - {{ item.name | lower }}",
    "msp": {
        "component": {
            "tls_cert": "{{ ca_info.CAChain }}"
        },
        "ca": {
            "root_certs": [
                "{{ ca_info.CAChain }}"
            ]
        },
        "tlsca": {
            "root_certs": [
                "{{ ca_info.CAChain }}"
            ]
        }
    },
    "pem": "{{ ca_info.CAChain }}",
    "tls_cert": "{{ ca_info.CAChain }}",
    "tls_ca_root_cert": "{{ ca_info.CAChain }}"
}
